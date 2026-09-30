import 'dart:developer' show log;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';

import '../services/background_video_config.dart';

@visibleForTesting
VideoViewType backgroundVideoViewType(TargetPlatform platform) {
  // On physical iOS devices the texture renderer goes through Flutter's
  // external-texture/Impeller path. That path can initialize AVPlayer
  // successfully while still producing an empty texture on some older
  // devices (notably the iPhone X on iOS 16). Render AVPlayer's native view
  // directly on iOS; keep textures elsewhere so desktop blur/compositing is
  // unchanged.
  return platform == TargetPlatform.iOS
      ? VideoViewType.platformView
      : VideoViewType.textureView;
}

class BackgroundVideoLoop extends StatefulWidget {
  const BackgroundVideoLoop({super.key, required this.backgroundId});

  final String? backgroundId;

  @override
  State<BackgroundVideoLoop> createState() => _BackgroundVideoLoopState();
}

class _BackgroundVideoLoopState extends State<BackgroundVideoLoop>
    with SingleTickerProviderStateMixin {
  static const _epsilon = Duration(milliseconds: 1000 ~/ 30);

  VideoPlayerController? _controller;
  Ticker? _ticker;
  Object? _loadError;
  int _loadGeneration = 0;
  bool _hasPlaybackError = false;

  int _direction = 1;
  Duration _reverseStartedAtElapsed = Duration.zero;
  Duration _reverseStartedFrom = Duration.zero;
  Duration _lastSeekTarget = Duration.zero;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant BackgroundVideoLoop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backgroundId != widget.backgroundId) {
      _load();
    }
  }

  Future<void> _load() async {
    log('load background ${widget.backgroundId}');
    final generation = ++_loadGeneration;
    final entry = BackgroundVideoConfig.entryFor(widget.backgroundId);

    await _teardown();
    if (!mounted || generation != _loadGeneration || entry == null) return;

    final asset = BackgroundVideoConfig.assetFor(entry);
    final controller = VideoPlayerController.asset(
      asset,
      viewType: backgroundVideoViewType(defaultTargetPlatform),
      // The background video is always muted (`setVolume(0)` below). Without
      // `mixWithOthers`, ExoPlayer still grabs Android audio focus on every
      // `play()` and abandons it on every `pause()` — and this widget's
      // reverse-loop ticker pauses/plays constantly — which repeatedly kills
      // and resumes the `audioplayers` BGM. Mixing keeps the video out of the
      // audio-focus fight entirely.
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller;
    _loadError = null;
    _hasPlaybackError = false;
    _direction = 1;
    controller.addListener(
      () => _handleControllerValue(controller, generation),
    );

    try {
      await controller.initialize();
      log('initialize background video');
      if (!mounted || generation != _loadGeneration) {
        await controller.dispose();
        return;
      }

      await controller.setVolume(0);

      if (entry.loop == BackgroundLoopMode.restart) {
        await controller.setLooping(true);
        await controller.play();
      } else {
        await controller.setLooping(false);
        await controller.play();
        _ticker = createTicker(_onTick)..start();
      }

      if (mounted && generation == _loadGeneration) setState(() {});
      log('background video loaded: $asset');
    } catch (error, stackTrace) {
      log('Background video failed to load: $asset ($error)');
      debugPrint('Background video failed to load: $asset ($error)');
      debugPrintStack(stackTrace: stackTrace);
      if (identical(_controller, controller)) {
        _controller = null;
        _loadError = error;
      }
      await controller.dispose();
      if (mounted && generation == _loadGeneration) setState(() {});
    }
  }

  void _handleControllerValue(
    VideoPlayerController controller,
    int generation,
  ) {
    if (!mounted ||
        generation != _loadGeneration ||
        !identical(_controller, controller)) {
      return;
    }

    final hasError = controller.value.hasError;
    if (hasError == _hasPlaybackError) return;
    setState(() => _hasPlaybackError = hasError);
  }

  void _onTick(Duration elapsed) {
    final controller = _controller;
    final duration = controller?.value.duration;
    if (controller == null || duration == null || duration == Duration.zero) {
      return;
    }

    if (_direction == 1) {
      final position = controller.value.position;
      if (position >= duration - (_epsilon * 2)) {
        controller.pause();
        _direction = -1;
        _reverseStartedAtElapsed = elapsed;
        _reverseStartedFrom = position > duration ? duration : position;
      }
      return;
    }

    final reverseElapsed = elapsed - _reverseStartedAtElapsed;
    final target = _reverseStartedFrom - reverseElapsed;

    if (target <= _epsilon) {
      _direction = 1;
      _reverseStartedAtElapsed = Duration.zero;
      _reverseStartedFrom = Duration.zero;
      controller.seekTo(Duration.zero);
      controller.play();
      return;
    }

    if ((controller.value.position - target).abs() >= _epsilon &&
        target != _lastSeekTarget) {
      _lastSeekTarget = target;
      controller.seekTo(target);
    }
  }

  Future<void> _teardown() async {
    _ticker?.dispose();
    _ticker = null;
    final controller = _controller;
    _controller = null;
    _hasPlaybackError = false;
    if (controller != null) {
      await controller.dispose();
    }
  }

  @override
  void dispose() {
    _loadGeneration++;
    _teardown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final entry = BackgroundVideoConfig.entryFor(widget.backgroundId);
    if (entry == null) return const SizedBox.shrink();

    final poster = _buildPoster(entry);
    if (controller == null ||
        !controller.value.isInitialized ||
        _hasPlaybackError) {
      assert(() {
        if (_loadError != null) {
          debugPrint(
            'Background video is showing its fallback after: $_loadError',
          );
        }
        return true;
      }());
      return poster;
    }

    // Keep the poster behind the player even after initialization. Native
    // iOS platform views can take an extra frame to present decoded video;
    // the poster prevents a flash of the plain scene background during that
    // hand-off. The controller listener restores it on runtime errors.
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [poster, _buildVideo(controller, entry)],
      ),
    );
  }

  Widget _buildPoster(BackgroundVideoEntry entry) {
    Widget poster = Image.asset(
      BackgroundVideoConfig.posterAssetFor(entry),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Background poster failed to load: $error');
        return const SizedBox.expand();
      },
    );

    poster = _applyConfiguredBlur(poster, entry);
    return ClipRect(child: poster);
  }

  Widget _buildVideo(
    VideoPlayerController controller,
    BackgroundVideoEntry entry,
  ) {
    Widget video = FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );

    return _applyConfiguredBlur(video, entry);
  }

  Widget _applyConfiguredBlur(Widget child, BackgroundVideoEntry entry) {
    if (entry.blur <= 0 || defaultTargetPlatform == TargetPlatform.iOS) {
      return child;
    }
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: entry.blur, sigmaY: entry.blur),
      child: child,
    );
  }
}
