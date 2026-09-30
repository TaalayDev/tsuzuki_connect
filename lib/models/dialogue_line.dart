import 'package:freezed_annotation/freezed_annotation.dart';

part 'dialogue_line.freezed.dart';
part 'dialogue_line.g.dart';

@Freezed(unionKey: 'type')
sealed class DialogueLine with _$DialogueLine {
  const factory DialogueLine.background({
    required String bg,
    required String time,
    @Default('fade') String transition,
  }) = BackgroundLine;

  const factory DialogueLine.character({
    required String name,
    @Default('center') String position,
    @Default('neutral') String expression,
  }) = CharacterLine;

  @FreezedUnionValue('character-hide')
  const factory DialogueLine.characterHide({required String name}) = CharacterHideLine;

  @FreezedUnionValue('character-hide-all')
  const factory DialogueLine.characterHideAll() = CharacterHideAllLine;

  @FreezedUnionValue('character-move')
  const factory DialogueLine.characterMove({required String name, required String position}) = CharacterMoveLine;

  @FreezedUnionValue('character-express')
  const factory DialogueLine.characterExpress({required String name, required String expression}) =
      CharacterExpressLine;

  const factory DialogueLine.narration({required String text}) = NarrationLine;

  const factory DialogueLine.dialogue({
    required String speaker,
    required String text,
    String? expression,
    String? translation,
    String? transcription,
  }) = DialogueTextLine;

  const factory DialogueLine.jump({required String target}) = JumpLine;

  const factory DialogueLine.end() = EndLine;

  const factory DialogueLine.choice({required List<DialogueChoice> choices}) = ChoiceLine;

  const factory DialogueLine.relationship({
    required String character,
    required int change,
    @Default('') String reason,
  }) = RelationshipLine;

  const factory DialogueLine.effect({required String effect, int? duration}) = EffectLine;

  const factory DialogueLine.music({required String track, @Default(false) bool fadeIn}) = MusicLine;

  const factory DialogueLine.sfx({required String sound}) = SfxLine;

  const factory DialogueLine.flag({required String flag, @Default(true) bool value}) = FlagLine;

  const factory DialogueLine.condition({required String flag, required String ifTrue, String? ifFalse}) = ConditionLine;

  const factory DialogueLine.wait({@Default(1000) int duration}) = WaitLine;

  @FreezedUnionValue('title-card')
  const factory DialogueLine.titleCard({
    required String title,
    @Default('') String subtitle,
    @Default(4000) int duration,
  }) = TitleCardLine;

  factory DialogueLine.fromJson(Map<String, dynamic> json) => _$DialogueLineFromJson(json);
}

@freezed
sealed class DialogueChoice with _$DialogueChoice {
  const factory DialogueChoice({required String text, required String next, String? hint, String? relationship}) =
      _DialogueChoice;

  factory DialogueChoice.fromJson(Map<String, dynamic> json) => _$DialogueChoiceFromJson(json);
}
