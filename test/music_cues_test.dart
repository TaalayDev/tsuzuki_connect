import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/services/audio_service.dart';

void main() {
  test(
    'every music cue used by the stories and lessons has a bundled track',
    () {
      final cue = RegExp(r'''\.music\(\s*["']([A-Za-z_]+)["']''');
      final cues = <String>{};
      for (final entity in Directory('lib/novel').listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        for (final match in cue.allMatches(entity.readAsStringSync())) {
          cues.add(match.group(1)!);
        }
      }
      cues.remove('stop');

      expect(cues, isNotEmpty);
      for (final track in cues) {
        final asset = AudioService.assetForMusic(track);
        expect(asset, isNotNull, reason: 'music cue "$track" has no track');
        expect(File('assets/$asset').existsSync(), isTrue, reason: asset);
      }
    },
  );
}
