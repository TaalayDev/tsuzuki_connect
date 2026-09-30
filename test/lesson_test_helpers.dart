import 'package:flutter_test/flutter_test.dart';
import 'package:tsuzuki_connect/models/dialogue_line.dart';
import 'package:tsuzuki_connect/models/story.dart';
import 'package:tsuzuki_connect/novel/stories/story_translations.dart';

/// Languages every lesson line has to be translated into.
const lessonLanguages = <String>['en', 'ru', 'zh', 'ja', 'romaji'];

/// Checks that every text in [story] resolves in all [lessonLanguages], that
/// every choice points to an existing scene, and that no scene is left
/// without a way out. Returns the number of choices in the story.
int expectStoryIsValid(Story story) {
  final sceneTargets = <String>{
    for (final scene in story.scenes) ...<String>[scene.id, scene.label],
  };
  var choiceCount = 0;

  for (final line in story.scenes.expand((scene) => scene.lines)) {
    final keys = switch (line) {
      DialogueTextLine(text: final text) => <String>[text],
      NarrationLine(text: final text) => <String>[text],
      TitleCardLine(title: final title, subtitle: final subtitle) => <String>[
        title,
        subtitle,
      ],
      ChoiceLine(choices: final choices) => <String>[
        for (final choice in choices) choice.text,
      ],
      _ => const <String>[],
    };

    for (final key in keys.where((value) => value.isNotEmpty)) {
      expect(storyTranslations.containsKey(key), isTrue, reason: key);
      for (final language in lessonLanguages) {
        expect(
          storyTranslations.t(key, language: language),
          isNot(key),
          reason: '$key ($language)',
        );
      }
    }

    if (line case ChoiceLine(choices: final choices)) {
      choiceCount += choices.length;
      for (final choice in choices) {
        expect(sceneTargets, contains(choice.next), reason: choice.text);
      }
    }
    if (line case JumpLine(target: final target)) {
      expect(sceneTargets, contains(target));
    }
  }

  for (final scene in story.scenes) {
    final last = scene.lines.last;
    expect(
      last is JumpLine || last is EndLine || last is ChoiceLine,
      isTrue,
      reason: 'scene ${scene.id} ends without a jump, choice or end',
    );
  }
  return choiceCount;
}
