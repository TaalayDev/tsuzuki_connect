// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialogue_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BackgroundLineImpl _$$BackgroundLineImplFromJson(Map<String, dynamic> json) =>
    _$BackgroundLineImpl(
      bg: json['bg'] as String,
      time: json['time'] as String,
      transition: json['transition'] as String? ?? 'fade',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$BackgroundLineImplToJson(
  _$BackgroundLineImpl instance,
) => <String, dynamic>{
  'bg': instance.bg,
  'time': instance.time,
  'transition': instance.transition,
  'type': instance.$type,
};

_$CharacterLineImpl _$$CharacterLineImplFromJson(Map<String, dynamic> json) =>
    _$CharacterLineImpl(
      name: json['name'] as String,
      position: json['position'] as String? ?? 'center',
      expression: json['expression'] as String? ?? 'neutral',
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$CharacterLineImplToJson(_$CharacterLineImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'expression': instance.expression,
      'type': instance.$type,
    };

_$CharacterHideLineImpl _$$CharacterHideLineImplFromJson(
  Map<String, dynamic> json,
) => _$CharacterHideLineImpl(
  name: json['name'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$CharacterHideLineImplToJson(
  _$CharacterHideLineImpl instance,
) => <String, dynamic>{'name': instance.name, 'type': instance.$type};

_$CharacterHideAllLineImpl _$$CharacterHideAllLineImplFromJson(
  Map<String, dynamic> json,
) => _$CharacterHideAllLineImpl($type: json['type'] as String?);

Map<String, dynamic> _$$CharacterHideAllLineImplToJson(
  _$CharacterHideAllLineImpl instance,
) => <String, dynamic>{'type': instance.$type};

_$CharacterMoveLineImpl _$$CharacterMoveLineImplFromJson(
  Map<String, dynamic> json,
) => _$CharacterMoveLineImpl(
  name: json['name'] as String,
  position: json['position'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$CharacterMoveLineImplToJson(
  _$CharacterMoveLineImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'position': instance.position,
  'type': instance.$type,
};

_$CharacterExpressLineImpl _$$CharacterExpressLineImplFromJson(
  Map<String, dynamic> json,
) => _$CharacterExpressLineImpl(
  name: json['name'] as String,
  expression: json['expression'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$CharacterExpressLineImplToJson(
  _$CharacterExpressLineImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'expression': instance.expression,
  'type': instance.$type,
};

_$NarrationLineImpl _$$NarrationLineImplFromJson(Map<String, dynamic> json) =>
    _$NarrationLineImpl(
      text: json['text'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$NarrationLineImplToJson(_$NarrationLineImpl instance) =>
    <String, dynamic>{'text': instance.text, 'type': instance.$type};

_$DialogueTextLineImpl _$$DialogueTextLineImplFromJson(
  Map<String, dynamic> json,
) => _$DialogueTextLineImpl(
  speaker: json['speaker'] as String,
  text: json['text'] as String,
  expression: json['expression'] as String?,
  translation: json['translation'] as String?,
  transcription: json['transcription'] as String?,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$DialogueTextLineImplToJson(
  _$DialogueTextLineImpl instance,
) => <String, dynamic>{
  'speaker': instance.speaker,
  'text': instance.text,
  'expression': instance.expression,
  'translation': instance.translation,
  'transcription': instance.transcription,
  'type': instance.$type,
};

_$JumpLineImpl _$$JumpLineImplFromJson(Map<String, dynamic> json) =>
    _$JumpLineImpl(
      target: json['target'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$JumpLineImplToJson(_$JumpLineImpl instance) =>
    <String, dynamic>{'target': instance.target, 'type': instance.$type};

_$EndLineImpl _$$EndLineImplFromJson(Map<String, dynamic> json) =>
    _$EndLineImpl($type: json['type'] as String?);

Map<String, dynamic> _$$EndLineImplToJson(_$EndLineImpl instance) =>
    <String, dynamic>{'type': instance.$type};

_$ChoiceLineImpl _$$ChoiceLineImplFromJson(Map<String, dynamic> json) =>
    _$ChoiceLineImpl(
      choices: (json['choices'] as List<dynamic>)
          .map((e) => DialogueChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ChoiceLineImplToJson(_$ChoiceLineImpl instance) =>
    <String, dynamic>{'choices': instance.choices, 'type': instance.$type};

_$RelationshipLineImpl _$$RelationshipLineImplFromJson(
  Map<String, dynamic> json,
) => _$RelationshipLineImpl(
  character: json['character'] as String,
  change: (json['change'] as num).toInt(),
  reason: json['reason'] as String? ?? '',
  $type: json['type'] as String?,
);

Map<String, dynamic> _$$RelationshipLineImplToJson(
  _$RelationshipLineImpl instance,
) => <String, dynamic>{
  'character': instance.character,
  'change': instance.change,
  'reason': instance.reason,
  'type': instance.$type,
};

_$EffectLineImpl _$$EffectLineImplFromJson(Map<String, dynamic> json) =>
    _$EffectLineImpl(
      effect: json['effect'] as String,
      duration: (json['duration'] as num?)?.toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$EffectLineImplToJson(_$EffectLineImpl instance) =>
    <String, dynamic>{
      'effect': instance.effect,
      'duration': instance.duration,
      'type': instance.$type,
    };

_$MusicLineImpl _$$MusicLineImplFromJson(Map<String, dynamic> json) =>
    _$MusicLineImpl(
      track: json['track'] as String,
      fadeIn: json['fadeIn'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$MusicLineImplToJson(_$MusicLineImpl instance) =>
    <String, dynamic>{
      'track': instance.track,
      'fadeIn': instance.fadeIn,
      'type': instance.$type,
    };

_$SfxLineImpl _$$SfxLineImplFromJson(Map<String, dynamic> json) =>
    _$SfxLineImpl(
      sound: json['sound'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SfxLineImplToJson(_$SfxLineImpl instance) =>
    <String, dynamic>{'sound': instance.sound, 'type': instance.$type};

_$FlagLineImpl _$$FlagLineImplFromJson(Map<String, dynamic> json) =>
    _$FlagLineImpl(
      flag: json['flag'] as String,
      value: json['value'] as bool? ?? true,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$FlagLineImplToJson(_$FlagLineImpl instance) =>
    <String, dynamic>{
      'flag': instance.flag,
      'value': instance.value,
      'type': instance.$type,
    };

_$ConditionLineImpl _$$ConditionLineImplFromJson(Map<String, dynamic> json) =>
    _$ConditionLineImpl(
      flag: json['flag'] as String,
      ifTrue: json['ifTrue'] as String,
      ifFalse: json['ifFalse'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ConditionLineImplToJson(_$ConditionLineImpl instance) =>
    <String, dynamic>{
      'flag': instance.flag,
      'ifTrue': instance.ifTrue,
      'ifFalse': instance.ifFalse,
      'type': instance.$type,
    };

_$WaitLineImpl _$$WaitLineImplFromJson(Map<String, dynamic> json) =>
    _$WaitLineImpl(
      duration: (json['duration'] as num?)?.toInt() ?? 1000,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$WaitLineImplToJson(_$WaitLineImpl instance) =>
    <String, dynamic>{'duration': instance.duration, 'type': instance.$type};

_$TitleCardLineImpl _$$TitleCardLineImplFromJson(Map<String, dynamic> json) =>
    _$TitleCardLineImpl(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 4000,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TitleCardLineImplToJson(_$TitleCardLineImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'duration': instance.duration,
      'type': instance.$type,
    };

_$DialogueChoiceImpl _$$DialogueChoiceImplFromJson(Map<String, dynamic> json) =>
    _$DialogueChoiceImpl(
      text: json['text'] as String,
      next: json['next'] as String,
      hint: json['hint'] as String?,
      relationship: json['relationship'] as String?,
    );

Map<String, dynamic> _$$DialogueChoiceImplToJson(
  _$DialogueChoiceImpl instance,
) => <String, dynamic>{
  'text': instance.text,
  'next': instance.next,
  'hint': instance.hint,
  'relationship': instance.relationship,
};
