import 'package:freezed_annotation/freezed_annotation.dart';

import 'dialogue_line.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
sealed class DialogueScene with _$DialogueScene {
  const factory DialogueScene({required String id, required String label, required List<DialogueLine> lines}) =
      _DialogueScene;

  factory DialogueScene.fromJson(Map<String, dynamic> json) => _$DialogueSceneFromJson(json);
}

String _idFromJson(dynamic value) => value.toString();

@freezed
sealed class Story with _$Story {
  const factory Story({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String title,
    required String subtitle,
    @Default('') String description,
    @Default('') String estimatedTime,
    @Default('A1') String cefrFocus,
    required List<DialogueScene> scenes,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
}
