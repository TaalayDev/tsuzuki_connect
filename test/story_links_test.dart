import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/models/dialogue_line.dart';
import 'package:tsuzuki_connect/novel/stories/story_translations.dart';
import 'package:tsuzuki_connect/services/content_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await storyTranslations.load();
  });

  // A choice or jump that points at a missing scene silently ends the story
  // (the player treats an unknown label as "finished"), so every target in
  // every chapter has to exist.
  test('every choice and jump in every chapter points at a scene', () async {
    for (var index = 0; index < 8; index++) {
      final story = await ContentService().loadStory(
        ContentCategory.chapter,
        'story$index',
      );
      final targets = <String>{
        for (final scene in story.scenes) ...<String>[scene.id, scene.label],
      };
      for (final line in story.scenes.expand((scene) => scene.lines)) {
        if (line case ChoiceLine(choices: final choices)) {
          for (final choice in choices) {
            expect(targets, contains(choice.next), reason: 'story$index');
          }
        }
        if (line case JumpLine(target: final target)) {
          expect(targets, contains(target), reason: 'story$index');
        }
      }
    }
  });
}
