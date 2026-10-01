import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/services/character_assets.dart';

void main() {
  test('every character that speaks or appears in a story has a sprite', () {
    final named = RegExp(r'''\.(?:say|show)\(\s*["']([a-z_]+)["']''');
    final names = <String>{};
    for (final entity in Directory('lib/novel').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      for (final match in named.allMatches(entity.readAsStringSync())) {
        names.add(match.group(1)!);
      }
    }
    names.remove('player');

    expect(names, isNotEmpty);
    for (final name in names) {
      final path = CharacterAssets.path(name, 'neutral');
      expect(path, isNotNull, reason: 'character "$name" has no sprite');
      expect(File(path!).existsSync(), isTrue, reason: path);
    }
  });
}
