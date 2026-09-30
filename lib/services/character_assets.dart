class CharacterAssets {
  CharacterAssets._();

  static const basePath = 'assets/characters/';

  static const Map<String, Map<String, String>> _mappings = {
    'ken': {
      'neutral': 'ken_neutral.png',
      'happy': 'ken_smile.png',
      'laugh': 'ken_laugh.png',
      'surprised': 'ken_surprised.png',
      'angry': 'ken_annoyed.png',
      'annoyed': 'ken_annoyed.png',
      'sad': 'ken_concerned.png',
      'concerned': 'ken_concerned.png',
      'serious': 'ken_serious.png',
      'speaking': 'ken_speaking.png',
      'silhouette': 'ken_silhouette.png',
    },
    'mei': {
      'neutral': 'mei_neutral.png',
      'happy': 'mei_smile.png',
      'laugh': 'mei_laugh.png',
      'surprised': 'mei_surprised.png',
      'angry': 'mei_annoyed.png',
      'annoyed': 'mei_annoyed.png',
      'sad': 'mei_concerned.png',
      'concerned': 'mei_concerned.png',
      'serious': 'mei_serious.png',
      'speaking': 'mei_speaking.png',
      'silhouette': 'mei_silhouette.png',
    },
    'alex': {
      'neutral': 'alex_neutral.png',
      'happy': 'alex_smile.png',
      'laugh': 'alex_laugh.png',
      'surprised': 'alex_surprised.png',
      'angry': 'alex_annoyed.png',
      'annoyed': 'alex_annoyed.png',
      'sad': 'alex_concerned.png',
      'concerned': 'alex_concerned.png',
      'serious': 'alex_serious.png',
      'speaking': 'alex_speaking.png',
    },
    'tanaka': {
      'neutral': 'tanaka_neutral.png',
      'happy': 'tanaka_smile.png',
      'laugh': 'tanaka_laugh.png',
      'surprised': 'tanaka_surprised.png',
      'angry': 'tanaka_annoyed.png',
      'annoyed': 'tanaka_annoyed.png',
      'sad': 'tanaka_concerned.png',
      'concerned': 'tanaka_concerned.png',
      'serious': 'tanaka_serious.png',
      'speaking': 'tanaka_speaking.png',
      'silhouette': 'tanaka_silhouette.png',
    },
    'yuki': {
      'neutral': 'yuki_neutral.png',
      'happy': 'yuki_happy.png',
      'playful': 'yuki_playful_smile.png',
      'laugh': 'yuki_cheerful_laugh.png',
      'surprised': 'yuki_surprised.png',
      'shocked': 'yuki_shocked.png',
      'subtle_surprise': 'yuki_subtle_surprise.png',
      'sad': 'yuki_worried.png',
      'worried': 'yuki_worried.png',
      'confused': 'yuki_confused.png',
      'serious': 'yuki_serious.png',
      'gentle': 'yuki_gentle_content.png',
      'speaking': 'yuki_speaking.png',
      'silhouette': 'yuki_silhouette.png',
    },
    'father': {'neutral': 'father_neutral.png'},
    'mother': {'neutral': 'mother_neutral.png'},
    'grandpa': {'neutral': 'grandpa_neutral.png'},
    'grandma': {'neutral': 'grandma_neutral.png'},
    'little_boy': {'neutral': 'little_boy_neutral.png'},
    'little_girl': {'neutral': 'little_girl_neutral.png'},
  };

  /// Anthology-story character aliases -> renderer key, ported from
  /// `CHARACTER_ALIASES` in `js/graphics/characters/CharacterRegistry.js`.
  /// Not exhaustive (the JS map has ~60 entries across 20 chapters) — add
  /// entries here as each chapter is wired into the player.
  static const Map<String, String> aliases = {
    'regular': 'grandpa',
    'diego': 'ken',
    'freya': 'mei',
    'aisha': 'yuki',
    'tom': 'ken',
    'interviewer': 'alex',
    'kana': 'yuki',
    'grandfather': 'grandpa',
    'grandmother': 'grandma',
    'mom': 'mother',
    'server': 'mei',
    'daichi': 'ken',
    'obaachan': 'grandma',
    'mika': 'mei',
    'caseworker': 'mei',
    'elena': 'yuki',
    'walter': 'grandpa',
    'nadia': 'mei',
    'sofia': 'mei',
    'robbie': 'grandpa',
    'cafe_owner': 'mother',
    'marcus': 'ken',
    'professor_hale': 'grandpa',
    'clerk': 'grandma',
    'teacher': 'mei',
    'daughter': 'little_girl',
    'james': 'ken',
  };

  /// `heightRatio` per renderer class (`js/graphics/characters/*.js`) —
  /// keyed by the *game* character id (the renderer class stays tied to
  /// the original character even after the frame-cast art rename, e.g.
  /// 'tanaka' keeps `Tanaka.js`'s 0.88 even though it now draws
  /// `hartley_*.png`). Falls back to `CharacterBase`'s default of 0.9.
  static const Map<String, double> _heightRatios = {
    'alex': 0.85,
    'ken': 0.95,
    'mei': 0.88,
    'yuki': 0.82,
    'tanaka': 0.88,
    'father': 0.95,
    'mother': 0.90,
    'grandpa': 0.92,
    'grandma': 0.85,
    'little_boy': 0.70,
    'little_girl': 0.70,
  };

  static double heightRatio(String characterId) {
    final resolvedId = aliases[characterId.toLowerCase()] ?? characterId.toLowerCase();
    return _heightRatios[resolvedId] ?? 0.9;
  }

  /// Width / height of the source sprite. All expressions for a character
  /// use the same canvas size, so the renderer can reserve the sprite's real
  /// width before applying the hip-up crop.
  static double aspectRatio(String characterId) {
    final resolvedId = aliases[characterId.toLowerCase()] ?? characterId.toLowerCase();
    return switch (resolvedId) {
      'alex' => 400 / 1300,
      'ken' => 400 / 1100,
      'mei' || 'tanaka' => 500 / 1100,
      _ => 400 / 1050,
    };
  }

  /// Resolves a character id + expression to an asset path, applying the
  /// same expression-substring fallback chain as `CharacterAssets.getPath()`
  /// (e.g. any expression containing "smile" falls back to 'happy' if
  /// there's no exact match). Returns null if the character id is unknown.
  static String? path(String characterId, String expression) {
    final resolvedId = aliases[characterId.toLowerCase()] ?? characterId.toLowerCase();
    final charMap = _mappings[resolvedId];
    if (charMap == null) return null;

    final exprLower = expression.toLowerCase();
    var file = charMap[exprLower];

    if (file == null) {
      if (exprLower.contains('smile')) {
        file = charMap['happy'];
      } else if (exprLower.contains('laugh')) {
        file = charMap['laugh'] ?? charMap['happy'];
      } else if (exprLower.contains('cry')) {
        file = charMap['sad'];
      } else if (exprLower.contains('angry')) {
        file = charMap['annoyed'];
      } else if (exprLower.contains('think')) {
        file = charMap['serious'];
      } else if (exprLower.contains('blush')) {
        file = charMap['happy'];
      } else {
        file = charMap['neutral'];
      }
    }

    return file == null ? null : '$basePath$file';
  }
}
