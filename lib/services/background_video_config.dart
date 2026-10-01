enum BackgroundLoopMode { restart, reverse }

class BackgroundVideoEntry {
  const BackgroundVideoEntry({
    required this.file,
    required this.loop,
    this.blur = 0,
    this.speed = 1.0,
  });

  final String file;
  final BackgroundLoopMode loop;

  final double blur;

  final double speed;
}

class BackgroundVideoConfig {
  BackgroundVideoConfig._();

  static const basePath = 'assets/backgrounds/';

  static const Map<String, BackgroundVideoEntry> _entries = {
    'classroom': BackgroundVideoEntry(
      file: 'classroom.mp4',
      loop: BackgroundLoopMode.restart,
      speed: 0.6,
    ),

    // Not a scene background — the main menu's fixed `.page-background-video`
    // in `index.html` (always this clip, restart-loop, muted). Reuses the
    // same [BackgroundVideoLoop] widget/config shape rather than a
    // separate one-off player.
    'menu_background': BackgroundVideoEntry(
      file: 'menu.mp4',
      loop: BackgroundLoopMode.restart,
    ),
  };

  static bool hasVideo(String? id) => id != null && _entries.containsKey(id);

  static BackgroundVideoEntry? entryFor(String? id) =>
      id == null ? null : _entries[id];

  static String assetFor(BackgroundVideoEntry entry) =>
      '$basePath${entry.file}';

  /// Static poster generated from the corresponding video. Posters are
  /// bundled beside the MP4 files and stay visible while the native player
  /// initializes or whenever video playback is unavailable.
  static String posterAssetFor(BackgroundVideoEntry entry) {
    final extensionStart = entry.file.lastIndexOf('.');
    final basename = extensionStart == -1
        ? entry.file
        : entry.file.substring(0, extensionStart);
    return '$basePath$basename.webp';
  }
}
