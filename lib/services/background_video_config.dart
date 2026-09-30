/// Background id -> looping video config, ported 1:1 from
/// `js/graphics/backgrounds/BackgroundAssets.js`'s `VIDEO_CONFIG`.
///
/// Video is ambient (not time-of-day specific) — the JS version still
/// layers a time-of-day color overlay on top via `BackgroundRenderer`,
/// which isn't ported here (see [BackgroundVideoLoop] docs / ARCHITECTURE.md
/// for the still-deferred procedural art layer).
enum BackgroundLoopMode { restart, reverse }

class BackgroundVideoEntry {
  const BackgroundVideoEntry({
    required this.file,
    required this.loop,
    this.blur = 0,
  });

  final String file;
  final BackgroundLoopMode loop;

  /// Pixels of Gaussian blur to apply over the video (0 = none) — ported
  /// from the JS `blur` field, used for a soft out-of-focus ambient layer.
  final double blur;
}

class BackgroundVideoConfig {
  BackgroundVideoConfig._();

  static const basePath = 'assets/backgrounds/';

  static const Map<String, BackgroundVideoEntry> _entries = {
    'street': BackgroundVideoEntry(
      file: 'local_street_road.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'classroom': BackgroundVideoEntry(
      file: 'empty_business_office.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'cafe': BackgroundVideoEntry(
      file: 'coffee_shop_background.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'apartment': BackgroundVideoEntry(
      file: 'apartment.mp4',
      loop: BackgroundLoopMode.reverse,
    ),
    'apartment_exterior': BackgroundVideoEntry(
      file: 'apartment_exterior.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'bedroom': BackgroundVideoEntry(
      file: 'apartment_bedroom.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'train': BackgroundVideoEntry(
      file: 'train.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'backstreet': BackgroundVideoEntry(
      file: 'road_street.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'kitchen': BackgroundVideoEntry(
      file: 'apartment_kitchen.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'bathroom': BackgroundVideoEntry(
      file: 'bathroom.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'station': BackgroundVideoEntry(
      file: 'bus_stop.mp4',
      loop: BackgroundLoopMode.reverse,
      blur: 4,
    ),
    'home_office': BackgroundVideoEntry(
      file: 'office.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'shopping_mall': BackgroundVideoEntry(
      file: 'shopping_mall.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'airport': BackgroundVideoEntry(
      file: 'airport.mp4',
      loop: BackgroundLoopMode.reverse,
    ),
    'cafe_tables': BackgroundVideoEntry(
      file: 'cafe_tables_on_a_night.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    'library': BackgroundVideoEntry(
      file: 'library.mp4',
      loop: BackgroundLoopMode.restart,
      blur: 4,
    ),
    'park': BackgroundVideoEntry(
      file: 'park.mp4',
      loop: BackgroundLoopMode.restart,
      blur: 6,
    ),
    'university_building': BackgroundVideoEntry(
      file: 'university_building.mp4',
      loop: BackgroundLoopMode.restart,
    ),
    // The apartment video is the available moving fallback for this room.
    'livingroom': BackgroundVideoEntry(
      file: 'apartment.mp4',
      loop: BackgroundLoopMode.reverse,
    ),

    // Not a scene background — the main menu's fixed `.page-background-video`
    // in `index.html` (always this clip, restart-loop, muted). Reuses the
    // same [BackgroundVideoLoop] widget/config shape rather than a
    // separate one-off player.
    'menu_background': BackgroundVideoEntry(
      file: 'cafe_tables_on_a_night.mp4',
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
