import 'package:flutter/material.dart';

import '../services/background_image_config.dart';
import '../services/background_video_config.dart';
import 'background_video.dart';

/// Draws the picture or video behind a dialogue scene: a looping video for
/// the few ids that still have one, a still image for everything else.
class SceneBackground extends StatelessWidget {
  const SceneBackground({super.key, required this.backgroundId, this.time});

  final String? backgroundId;
  final String? time;

  @override
  Widget build(BuildContext context) {
    if (BackgroundVideoConfig.hasVideo(backgroundId)) {
      return BackgroundVideoLoop(backgroundId: backgroundId);
    }
    final asset = BackgroundImageConfig.assetFor(backgroundId, time);
    if (asset == null) return const SizedBox.shrink();
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Background image failed to load: $error');
        return const SizedBox.expand();
      },
    );
  }
}
