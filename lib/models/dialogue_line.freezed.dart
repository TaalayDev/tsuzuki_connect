// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dialogue_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DialogueLine _$DialogueLineFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'background':
      return BackgroundLine.fromJson(json);
    case 'character':
      return CharacterLine.fromJson(json);
    case 'character-hide':
      return CharacterHideLine.fromJson(json);
    case 'character-hide-all':
      return CharacterHideAllLine.fromJson(json);
    case 'character-move':
      return CharacterMoveLine.fromJson(json);
    case 'character-express':
      return CharacterExpressLine.fromJson(json);
    case 'narration':
      return NarrationLine.fromJson(json);
    case 'dialogue':
      return DialogueTextLine.fromJson(json);
    case 'jump':
      return JumpLine.fromJson(json);
    case 'end':
      return EndLine.fromJson(json);
    case 'choice':
      return ChoiceLine.fromJson(json);
    case 'relationship':
      return RelationshipLine.fromJson(json);
    case 'effect':
      return EffectLine.fromJson(json);
    case 'music':
      return MusicLine.fromJson(json);
    case 'sfx':
      return SfxLine.fromJson(json);
    case 'flag':
      return FlagLine.fromJson(json);
    case 'condition':
      return ConditionLine.fromJson(json);
    case 'wait':
      return WaitLine.fromJson(json);
    case 'title-card':
      return TitleCardLine.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'type',
        'DialogueLine',
        'Invalid union type "${json['type']}"!',
      );
  }
}

/// @nodoc
mixin _$DialogueLine {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this DialogueLine to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogueLineCopyWith<$Res> {
  factory $DialogueLineCopyWith(
    DialogueLine value,
    $Res Function(DialogueLine) then,
  ) = _$DialogueLineCopyWithImpl<$Res, DialogueLine>;
}

/// @nodoc
class _$DialogueLineCopyWithImpl<$Res, $Val extends DialogueLine>
    implements $DialogueLineCopyWith<$Res> {
  _$DialogueLineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BackgroundLineImplCopyWith<$Res> {
  factory _$$BackgroundLineImplCopyWith(
    _$BackgroundLineImpl value,
    $Res Function(_$BackgroundLineImpl) then,
  ) = __$$BackgroundLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String bg, String time, String transition});
}

/// @nodoc
class __$$BackgroundLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$BackgroundLineImpl>
    implements _$$BackgroundLineImplCopyWith<$Res> {
  __$$BackgroundLineImplCopyWithImpl(
    _$BackgroundLineImpl _value,
    $Res Function(_$BackgroundLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bg = null,
    Object? time = null,
    Object? transition = null,
  }) {
    return _then(
      _$BackgroundLineImpl(
        bg: null == bg
            ? _value.bg
            : bg // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        transition: null == transition
            ? _value.transition
            : transition // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackgroundLineImpl implements BackgroundLine {
  const _$BackgroundLineImpl({
    required this.bg,
    required this.time,
    this.transition = 'fade',
    final String? $type,
  }) : $type = $type ?? 'background';

  factory _$BackgroundLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackgroundLineImplFromJson(json);

  @override
  final String bg;
  @override
  final String time;
  @override
  @JsonKey()
  final String transition;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.background(bg: $bg, time: $time, transition: $transition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackgroundLineImpl &&
            (identical(other.bg, bg) || other.bg == bg) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.transition, transition) ||
                other.transition == transition));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bg, time, transition);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackgroundLineImplCopyWith<_$BackgroundLineImpl> get copyWith =>
      __$$BackgroundLineImplCopyWithImpl<_$BackgroundLineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return background(bg, time, transition);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return background?.call(bg, time, transition);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (background != null) {
      return background(bg, time, transition);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return background(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return background?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (background != null) {
      return background(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BackgroundLineImplToJson(this);
  }
}

abstract class BackgroundLine implements DialogueLine {
  const factory BackgroundLine({
    required final String bg,
    required final String time,
    final String transition,
  }) = _$BackgroundLineImpl;

  factory BackgroundLine.fromJson(Map<String, dynamic> json) =
      _$BackgroundLineImpl.fromJson;

  String get bg;
  String get time;
  String get transition;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackgroundLineImplCopyWith<_$BackgroundLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CharacterLineImplCopyWith<$Res> {
  factory _$$CharacterLineImplCopyWith(
    _$CharacterLineImpl value,
    $Res Function(_$CharacterLineImpl) then,
  ) = __$$CharacterLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, String position, String expression});
}

/// @nodoc
class __$$CharacterLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$CharacterLineImpl>
    implements _$$CharacterLineImplCopyWith<$Res> {
  __$$CharacterLineImplCopyWithImpl(
    _$CharacterLineImpl _value,
    $Res Function(_$CharacterLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? expression = null,
  }) {
    return _then(
      _$CharacterLineImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
        expression: null == expression
            ? _value.expression
            : expression // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterLineImpl implements CharacterLine {
  const _$CharacterLineImpl({
    required this.name,
    this.position = 'center',
    this.expression = 'neutral',
    final String? $type,
  }) : $type = $type ?? 'character';

  factory _$CharacterLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterLineImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey()
  final String position;
  @override
  @JsonKey()
  final String expression;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.character(name: $name, position: $position, expression: $expression)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterLineImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.expression, expression) ||
                other.expression == expression));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, position, expression);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterLineImplCopyWith<_$CharacterLineImpl> get copyWith =>
      __$$CharacterLineImplCopyWithImpl<_$CharacterLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return character(name, position, expression);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return character?.call(name, position, expression);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (character != null) {
      return character(name, position, expression);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return character(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return character?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (character != null) {
      return character(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterLineImplToJson(this);
  }
}

abstract class CharacterLine implements DialogueLine {
  const factory CharacterLine({
    required final String name,
    final String position,
    final String expression,
  }) = _$CharacterLineImpl;

  factory CharacterLine.fromJson(Map<String, dynamic> json) =
      _$CharacterLineImpl.fromJson;

  String get name;
  String get position;
  String get expression;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterLineImplCopyWith<_$CharacterLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CharacterHideLineImplCopyWith<$Res> {
  factory _$$CharacterHideLineImplCopyWith(
    _$CharacterHideLineImpl value,
    $Res Function(_$CharacterHideLineImpl) then,
  ) = __$$CharacterHideLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$CharacterHideLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$CharacterHideLineImpl>
    implements _$$CharacterHideLineImplCopyWith<$Res> {
  __$$CharacterHideLineImplCopyWithImpl(
    _$CharacterHideLineImpl _value,
    $Res Function(_$CharacterHideLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$CharacterHideLineImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterHideLineImpl implements CharacterHideLine {
  const _$CharacterHideLineImpl({required this.name, final String? $type})
    : $type = $type ?? 'character-hide';

  factory _$CharacterHideLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterHideLineImplFromJson(json);

  @override
  final String name;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.characterHide(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterHideLineImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterHideLineImplCopyWith<_$CharacterHideLineImpl> get copyWith =>
      __$$CharacterHideLineImplCopyWithImpl<_$CharacterHideLineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return characterHide(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return characterHide?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (characterHide != null) {
      return characterHide(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return characterHide(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return characterHide?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (characterHide != null) {
      return characterHide(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterHideLineImplToJson(this);
  }
}

abstract class CharacterHideLine implements DialogueLine {
  const factory CharacterHideLine({required final String name}) =
      _$CharacterHideLineImpl;

  factory CharacterHideLine.fromJson(Map<String, dynamic> json) =
      _$CharacterHideLineImpl.fromJson;

  String get name;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterHideLineImplCopyWith<_$CharacterHideLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CharacterHideAllLineImplCopyWith<$Res> {
  factory _$$CharacterHideAllLineImplCopyWith(
    _$CharacterHideAllLineImpl value,
    $Res Function(_$CharacterHideAllLineImpl) then,
  ) = __$$CharacterHideAllLineImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CharacterHideAllLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$CharacterHideAllLineImpl>
    implements _$$CharacterHideAllLineImplCopyWith<$Res> {
  __$$CharacterHideAllLineImplCopyWithImpl(
    _$CharacterHideAllLineImpl _value,
    $Res Function(_$CharacterHideAllLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$CharacterHideAllLineImpl implements CharacterHideAllLine {
  const _$CharacterHideAllLineImpl({final String? $type})
    : $type = $type ?? 'character-hide-all';

  factory _$CharacterHideAllLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterHideAllLineImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.characterHideAll()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterHideAllLineImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return characterHideAll();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return characterHideAll?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (characterHideAll != null) {
      return characterHideAll();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return characterHideAll(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return characterHideAll?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (characterHideAll != null) {
      return characterHideAll(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterHideAllLineImplToJson(this);
  }
}

abstract class CharacterHideAllLine implements DialogueLine {
  const factory CharacterHideAllLine() = _$CharacterHideAllLineImpl;

  factory CharacterHideAllLine.fromJson(Map<String, dynamic> json) =
      _$CharacterHideAllLineImpl.fromJson;
}

/// @nodoc
abstract class _$$CharacterMoveLineImplCopyWith<$Res> {
  factory _$$CharacterMoveLineImplCopyWith(
    _$CharacterMoveLineImpl value,
    $Res Function(_$CharacterMoveLineImpl) then,
  ) = __$$CharacterMoveLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, String position});
}

/// @nodoc
class __$$CharacterMoveLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$CharacterMoveLineImpl>
    implements _$$CharacterMoveLineImplCopyWith<$Res> {
  __$$CharacterMoveLineImplCopyWithImpl(
    _$CharacterMoveLineImpl _value,
    $Res Function(_$CharacterMoveLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? position = null}) {
    return _then(
      _$CharacterMoveLineImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterMoveLineImpl implements CharacterMoveLine {
  const _$CharacterMoveLineImpl({
    required this.name,
    required this.position,
    final String? $type,
  }) : $type = $type ?? 'character-move';

  factory _$CharacterMoveLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterMoveLineImplFromJson(json);

  @override
  final String name;
  @override
  final String position;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.characterMove(name: $name, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterMoveLineImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, position);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterMoveLineImplCopyWith<_$CharacterMoveLineImpl> get copyWith =>
      __$$CharacterMoveLineImplCopyWithImpl<_$CharacterMoveLineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return characterMove(name, position);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return characterMove?.call(name, position);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (characterMove != null) {
      return characterMove(name, position);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return characterMove(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return characterMove?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (characterMove != null) {
      return characterMove(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterMoveLineImplToJson(this);
  }
}

abstract class CharacterMoveLine implements DialogueLine {
  const factory CharacterMoveLine({
    required final String name,
    required final String position,
  }) = _$CharacterMoveLineImpl;

  factory CharacterMoveLine.fromJson(Map<String, dynamic> json) =
      _$CharacterMoveLineImpl.fromJson;

  String get name;
  String get position;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterMoveLineImplCopyWith<_$CharacterMoveLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CharacterExpressLineImplCopyWith<$Res> {
  factory _$$CharacterExpressLineImplCopyWith(
    _$CharacterExpressLineImpl value,
    $Res Function(_$CharacterExpressLineImpl) then,
  ) = __$$CharacterExpressLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, String expression});
}

/// @nodoc
class __$$CharacterExpressLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$CharacterExpressLineImpl>
    implements _$$CharacterExpressLineImplCopyWith<$Res> {
  __$$CharacterExpressLineImplCopyWithImpl(
    _$CharacterExpressLineImpl _value,
    $Res Function(_$CharacterExpressLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? expression = null}) {
    return _then(
      _$CharacterExpressLineImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        expression: null == expression
            ? _value.expression
            : expression // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterExpressLineImpl implements CharacterExpressLine {
  const _$CharacterExpressLineImpl({
    required this.name,
    required this.expression,
    final String? $type,
  }) : $type = $type ?? 'character-express';

  factory _$CharacterExpressLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterExpressLineImplFromJson(json);

  @override
  final String name;
  @override
  final String expression;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.characterExpress(name: $name, expression: $expression)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterExpressLineImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.expression, expression) ||
                other.expression == expression));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, expression);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterExpressLineImplCopyWith<_$CharacterExpressLineImpl>
  get copyWith =>
      __$$CharacterExpressLineImplCopyWithImpl<_$CharacterExpressLineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return characterExpress(name, expression);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return characterExpress?.call(name, expression);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (characterExpress != null) {
      return characterExpress(name, expression);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return characterExpress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return characterExpress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (characterExpress != null) {
      return characterExpress(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterExpressLineImplToJson(this);
  }
}

abstract class CharacterExpressLine implements DialogueLine {
  const factory CharacterExpressLine({
    required final String name,
    required final String expression,
  }) = _$CharacterExpressLineImpl;

  factory CharacterExpressLine.fromJson(Map<String, dynamic> json) =
      _$CharacterExpressLineImpl.fromJson;

  String get name;
  String get expression;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterExpressLineImplCopyWith<_$CharacterExpressLineImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NarrationLineImplCopyWith<$Res> {
  factory _$$NarrationLineImplCopyWith(
    _$NarrationLineImpl value,
    $Res Function(_$NarrationLineImpl) then,
  ) = __$$NarrationLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$NarrationLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$NarrationLineImpl>
    implements _$$NarrationLineImplCopyWith<$Res> {
  __$$NarrationLineImplCopyWithImpl(
    _$NarrationLineImpl _value,
    $Res Function(_$NarrationLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null}) {
    return _then(
      _$NarrationLineImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NarrationLineImpl implements NarrationLine {
  const _$NarrationLineImpl({required this.text, final String? $type})
    : $type = $type ?? 'narration';

  factory _$NarrationLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$NarrationLineImplFromJson(json);

  @override
  final String text;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.narration(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NarrationLineImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NarrationLineImplCopyWith<_$NarrationLineImpl> get copyWith =>
      __$$NarrationLineImplCopyWithImpl<_$NarrationLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return narration(text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return narration?.call(text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (narration != null) {
      return narration(text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return narration(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return narration?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (narration != null) {
      return narration(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NarrationLineImplToJson(this);
  }
}

abstract class NarrationLine implements DialogueLine {
  const factory NarrationLine({required final String text}) =
      _$NarrationLineImpl;

  factory NarrationLine.fromJson(Map<String, dynamic> json) =
      _$NarrationLineImpl.fromJson;

  String get text;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NarrationLineImplCopyWith<_$NarrationLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DialogueTextLineImplCopyWith<$Res> {
  factory _$$DialogueTextLineImplCopyWith(
    _$DialogueTextLineImpl value,
    $Res Function(_$DialogueTextLineImpl) then,
  ) = __$$DialogueTextLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String speaker,
    String text,
    String? expression,
    String? translation,
    String? transcription,
  });
}

/// @nodoc
class __$$DialogueTextLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$DialogueTextLineImpl>
    implements _$$DialogueTextLineImplCopyWith<$Res> {
  __$$DialogueTextLineImplCopyWithImpl(
    _$DialogueTextLineImpl _value,
    $Res Function(_$DialogueTextLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? speaker = null,
    Object? text = null,
    Object? expression = freezed,
    Object? translation = freezed,
    Object? transcription = freezed,
  }) {
    return _then(
      _$DialogueTextLineImpl(
        speaker: null == speaker
            ? _value.speaker
            : speaker // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        expression: freezed == expression
            ? _value.expression
            : expression // ignore: cast_nullable_to_non_nullable
                  as String?,
        translation: freezed == translation
            ? _value.translation
            : translation // ignore: cast_nullable_to_non_nullable
                  as String?,
        transcription: freezed == transcription
            ? _value.transcription
            : transcription // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DialogueTextLineImpl implements DialogueTextLine {
  const _$DialogueTextLineImpl({
    required this.speaker,
    required this.text,
    this.expression,
    this.translation,
    this.transcription,
    final String? $type,
  }) : $type = $type ?? 'dialogue';

  factory _$DialogueTextLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$DialogueTextLineImplFromJson(json);

  @override
  final String speaker;
  @override
  final String text;
  @override
  final String? expression;
  @override
  final String? translation;
  @override
  final String? transcription;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.dialogue(speaker: $speaker, text: $text, expression: $expression, translation: $translation, transcription: $transcription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogueTextLineImpl &&
            (identical(other.speaker, speaker) || other.speaker == speaker) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.expression, expression) ||
                other.expression == expression) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    speaker,
    text,
    expression,
    translation,
    transcription,
  );

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogueTextLineImplCopyWith<_$DialogueTextLineImpl> get copyWith =>
      __$$DialogueTextLineImplCopyWithImpl<_$DialogueTextLineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return dialogue(speaker, text, expression, translation, transcription);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return dialogue?.call(
      speaker,
      text,
      expression,
      translation,
      transcription,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (dialogue != null) {
      return dialogue(speaker, text, expression, translation, transcription);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return dialogue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return dialogue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (dialogue != null) {
      return dialogue(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DialogueTextLineImplToJson(this);
  }
}

abstract class DialogueTextLine implements DialogueLine {
  const factory DialogueTextLine({
    required final String speaker,
    required final String text,
    final String? expression,
    final String? translation,
    final String? transcription,
  }) = _$DialogueTextLineImpl;

  factory DialogueTextLine.fromJson(Map<String, dynamic> json) =
      _$DialogueTextLineImpl.fromJson;

  String get speaker;
  String get text;
  String? get expression;
  String? get translation;
  String? get transcription;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DialogueTextLineImplCopyWith<_$DialogueTextLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$JumpLineImplCopyWith<$Res> {
  factory _$$JumpLineImplCopyWith(
    _$JumpLineImpl value,
    $Res Function(_$JumpLineImpl) then,
  ) = __$$JumpLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String target});
}

/// @nodoc
class __$$JumpLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$JumpLineImpl>
    implements _$$JumpLineImplCopyWith<$Res> {
  __$$JumpLineImplCopyWithImpl(
    _$JumpLineImpl _value,
    $Res Function(_$JumpLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? target = null}) {
    return _then(
      _$JumpLineImpl(
        target: null == target
            ? _value.target
            : target // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JumpLineImpl implements JumpLine {
  const _$JumpLineImpl({required this.target, final String? $type})
    : $type = $type ?? 'jump';

  factory _$JumpLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$JumpLineImplFromJson(json);

  @override
  final String target;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.jump(target: $target)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JumpLineImpl &&
            (identical(other.target, target) || other.target == target));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, target);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JumpLineImplCopyWith<_$JumpLineImpl> get copyWith =>
      __$$JumpLineImplCopyWithImpl<_$JumpLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return jump(target);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return jump?.call(target);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (jump != null) {
      return jump(target);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return jump(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return jump?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (jump != null) {
      return jump(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$JumpLineImplToJson(this);
  }
}

abstract class JumpLine implements DialogueLine {
  const factory JumpLine({required final String target}) = _$JumpLineImpl;

  factory JumpLine.fromJson(Map<String, dynamic> json) =
      _$JumpLineImpl.fromJson;

  String get target;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JumpLineImplCopyWith<_$JumpLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EndLineImplCopyWith<$Res> {
  factory _$$EndLineImplCopyWith(
    _$EndLineImpl value,
    $Res Function(_$EndLineImpl) then,
  ) = __$$EndLineImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EndLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$EndLineImpl>
    implements _$$EndLineImplCopyWith<$Res> {
  __$$EndLineImplCopyWithImpl(
    _$EndLineImpl _value,
    $Res Function(_$EndLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$EndLineImpl implements EndLine {
  const _$EndLineImpl({final String? $type}) : $type = $type ?? 'end';

  factory _$EndLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$EndLineImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.end()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EndLineImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return end();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return end?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (end != null) {
      return end();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return end(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return end?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (end != null) {
      return end(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EndLineImplToJson(this);
  }
}

abstract class EndLine implements DialogueLine {
  const factory EndLine() = _$EndLineImpl;

  factory EndLine.fromJson(Map<String, dynamic> json) = _$EndLineImpl.fromJson;
}

/// @nodoc
abstract class _$$ChoiceLineImplCopyWith<$Res> {
  factory _$$ChoiceLineImplCopyWith(
    _$ChoiceLineImpl value,
    $Res Function(_$ChoiceLineImpl) then,
  ) = __$$ChoiceLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<DialogueChoice> choices});
}

/// @nodoc
class __$$ChoiceLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$ChoiceLineImpl>
    implements _$$ChoiceLineImplCopyWith<$Res> {
  __$$ChoiceLineImplCopyWithImpl(
    _$ChoiceLineImpl _value,
    $Res Function(_$ChoiceLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? choices = null}) {
    return _then(
      _$ChoiceLineImpl(
        choices: null == choices
            ? _value._choices
            : choices // ignore: cast_nullable_to_non_nullable
                  as List<DialogueChoice>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChoiceLineImpl implements ChoiceLine {
  const _$ChoiceLineImpl({
    required final List<DialogueChoice> choices,
    final String? $type,
  }) : _choices = choices,
       $type = $type ?? 'choice';

  factory _$ChoiceLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChoiceLineImplFromJson(json);

  final List<DialogueChoice> _choices;
  @override
  List<DialogueChoice> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.choice(choices: $choices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChoiceLineImpl &&
            const DeepCollectionEquality().equals(other._choices, _choices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_choices));

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChoiceLineImplCopyWith<_$ChoiceLineImpl> get copyWith =>
      __$$ChoiceLineImplCopyWithImpl<_$ChoiceLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return choice(choices);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return choice?.call(choices);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (choice != null) {
      return choice(choices);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return choice(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return choice?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (choice != null) {
      return choice(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ChoiceLineImplToJson(this);
  }
}

abstract class ChoiceLine implements DialogueLine {
  const factory ChoiceLine({required final List<DialogueChoice> choices}) =
      _$ChoiceLineImpl;

  factory ChoiceLine.fromJson(Map<String, dynamic> json) =
      _$ChoiceLineImpl.fromJson;

  List<DialogueChoice> get choices;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChoiceLineImplCopyWith<_$ChoiceLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RelationshipLineImplCopyWith<$Res> {
  factory _$$RelationshipLineImplCopyWith(
    _$RelationshipLineImpl value,
    $Res Function(_$RelationshipLineImpl) then,
  ) = __$$RelationshipLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String character, int change, String reason});
}

/// @nodoc
class __$$RelationshipLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$RelationshipLineImpl>
    implements _$$RelationshipLineImplCopyWith<$Res> {
  __$$RelationshipLineImplCopyWithImpl(
    _$RelationshipLineImpl _value,
    $Res Function(_$RelationshipLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? character = null,
    Object? change = null,
    Object? reason = null,
  }) {
    return _then(
      _$RelationshipLineImpl(
        character: null == character
            ? _value.character
            : character // ignore: cast_nullable_to_non_nullable
                  as String,
        change: null == change
            ? _value.change
            : change // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationshipLineImpl implements RelationshipLine {
  const _$RelationshipLineImpl({
    required this.character,
    required this.change,
    this.reason = '',
    final String? $type,
  }) : $type = $type ?? 'relationship';

  factory _$RelationshipLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationshipLineImplFromJson(json);

  @override
  final String character;
  @override
  final int change;
  @override
  @JsonKey()
  final String reason;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.relationship(character: $character, change: $change, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationshipLineImpl &&
            (identical(other.character, character) ||
                other.character == character) &&
            (identical(other.change, change) || other.change == change) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, character, change, reason);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationshipLineImplCopyWith<_$RelationshipLineImpl> get copyWith =>
      __$$RelationshipLineImplCopyWithImpl<_$RelationshipLineImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return relationship(this.character, change, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return relationship?.call(this.character, change, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (relationship != null) {
      return relationship(this.character, change, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return relationship(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return relationship?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (relationship != null) {
      return relationship(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationshipLineImplToJson(this);
  }
}

abstract class RelationshipLine implements DialogueLine {
  const factory RelationshipLine({
    required final String character,
    required final int change,
    final String reason,
  }) = _$RelationshipLineImpl;

  factory RelationshipLine.fromJson(Map<String, dynamic> json) =
      _$RelationshipLineImpl.fromJson;

  String get character;
  int get change;
  String get reason;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RelationshipLineImplCopyWith<_$RelationshipLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EffectLineImplCopyWith<$Res> {
  factory _$$EffectLineImplCopyWith(
    _$EffectLineImpl value,
    $Res Function(_$EffectLineImpl) then,
  ) = __$$EffectLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String effect, int? duration});
}

/// @nodoc
class __$$EffectLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$EffectLineImpl>
    implements _$$EffectLineImplCopyWith<$Res> {
  __$$EffectLineImplCopyWithImpl(
    _$EffectLineImpl _value,
    $Res Function(_$EffectLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? effect = null, Object? duration = freezed}) {
    return _then(
      _$EffectLineImpl(
        effect: null == effect
            ? _value.effect
            : effect // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EffectLineImpl implements EffectLine {
  const _$EffectLineImpl({
    required this.effect,
    this.duration,
    final String? $type,
  }) : $type = $type ?? 'effect';

  factory _$EffectLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$EffectLineImplFromJson(json);

  @override
  final String effect;
  @override
  final int? duration;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.effect(effect: $effect, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EffectLineImpl &&
            (identical(other.effect, effect) || other.effect == effect) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, effect, duration);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EffectLineImplCopyWith<_$EffectLineImpl> get copyWith =>
      __$$EffectLineImplCopyWithImpl<_$EffectLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return effect(this.effect, duration);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return effect?.call(this.effect, duration);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (effect != null) {
      return effect(this.effect, duration);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return effect(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return effect?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (effect != null) {
      return effect(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EffectLineImplToJson(this);
  }
}

abstract class EffectLine implements DialogueLine {
  const factory EffectLine({
    required final String effect,
    final int? duration,
  }) = _$EffectLineImpl;

  factory EffectLine.fromJson(Map<String, dynamic> json) =
      _$EffectLineImpl.fromJson;

  String get effect;
  int? get duration;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EffectLineImplCopyWith<_$EffectLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MusicLineImplCopyWith<$Res> {
  factory _$$MusicLineImplCopyWith(
    _$MusicLineImpl value,
    $Res Function(_$MusicLineImpl) then,
  ) = __$$MusicLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String track, bool fadeIn});
}

/// @nodoc
class __$$MusicLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$MusicLineImpl>
    implements _$$MusicLineImplCopyWith<$Res> {
  __$$MusicLineImplCopyWithImpl(
    _$MusicLineImpl _value,
    $Res Function(_$MusicLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? track = null, Object? fadeIn = null}) {
    return _then(
      _$MusicLineImpl(
        track: null == track
            ? _value.track
            : track // ignore: cast_nullable_to_non_nullable
                  as String,
        fadeIn: null == fadeIn
            ? _value.fadeIn
            : fadeIn // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MusicLineImpl implements MusicLine {
  const _$MusicLineImpl({
    required this.track,
    this.fadeIn = false,
    final String? $type,
  }) : $type = $type ?? 'music';

  factory _$MusicLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$MusicLineImplFromJson(json);

  @override
  final String track;
  @override
  @JsonKey()
  final bool fadeIn;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.music(track: $track, fadeIn: $fadeIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MusicLineImpl &&
            (identical(other.track, track) || other.track == track) &&
            (identical(other.fadeIn, fadeIn) || other.fadeIn == fadeIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, track, fadeIn);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MusicLineImplCopyWith<_$MusicLineImpl> get copyWith =>
      __$$MusicLineImplCopyWithImpl<_$MusicLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return music(track, fadeIn);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return music?.call(track, fadeIn);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (music != null) {
      return music(track, fadeIn);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return music(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return music?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (music != null) {
      return music(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MusicLineImplToJson(this);
  }
}

abstract class MusicLine implements DialogueLine {
  const factory MusicLine({required final String track, final bool fadeIn}) =
      _$MusicLineImpl;

  factory MusicLine.fromJson(Map<String, dynamic> json) =
      _$MusicLineImpl.fromJson;

  String get track;
  bool get fadeIn;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MusicLineImplCopyWith<_$MusicLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SfxLineImplCopyWith<$Res> {
  factory _$$SfxLineImplCopyWith(
    _$SfxLineImpl value,
    $Res Function(_$SfxLineImpl) then,
  ) = __$$SfxLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sound});
}

/// @nodoc
class __$$SfxLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$SfxLineImpl>
    implements _$$SfxLineImplCopyWith<$Res> {
  __$$SfxLineImplCopyWithImpl(
    _$SfxLineImpl _value,
    $Res Function(_$SfxLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sound = null}) {
    return _then(
      _$SfxLineImpl(
        sound: null == sound
            ? _value.sound
            : sound // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SfxLineImpl implements SfxLine {
  const _$SfxLineImpl({required this.sound, final String? $type})
    : $type = $type ?? 'sfx';

  factory _$SfxLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$SfxLineImplFromJson(json);

  @override
  final String sound;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.sfx(sound: $sound)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SfxLineImpl &&
            (identical(other.sound, sound) || other.sound == sound));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sound);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SfxLineImplCopyWith<_$SfxLineImpl> get copyWith =>
      __$$SfxLineImplCopyWithImpl<_$SfxLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return sfx(sound);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return sfx?.call(sound);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (sfx != null) {
      return sfx(sound);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return sfx(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return sfx?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (sfx != null) {
      return sfx(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SfxLineImplToJson(this);
  }
}

abstract class SfxLine implements DialogueLine {
  const factory SfxLine({required final String sound}) = _$SfxLineImpl;

  factory SfxLine.fromJson(Map<String, dynamic> json) = _$SfxLineImpl.fromJson;

  String get sound;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SfxLineImplCopyWith<_$SfxLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FlagLineImplCopyWith<$Res> {
  factory _$$FlagLineImplCopyWith(
    _$FlagLineImpl value,
    $Res Function(_$FlagLineImpl) then,
  ) = __$$FlagLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String flag, bool value});
}

/// @nodoc
class __$$FlagLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$FlagLineImpl>
    implements _$$FlagLineImplCopyWith<$Res> {
  __$$FlagLineImplCopyWithImpl(
    _$FlagLineImpl _value,
    $Res Function(_$FlagLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? flag = null, Object? value = null}) {
    return _then(
      _$FlagLineImpl(
        flag: null == flag
            ? _value.flag
            : flag // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlagLineImpl implements FlagLine {
  const _$FlagLineImpl({
    required this.flag,
    this.value = true,
    final String? $type,
  }) : $type = $type ?? 'flag';

  factory _$FlagLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlagLineImplFromJson(json);

  @override
  final String flag;
  @override
  @JsonKey()
  final bool value;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.flag(flag: $flag, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlagLineImpl &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, flag, value);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlagLineImplCopyWith<_$FlagLineImpl> get copyWith =>
      __$$FlagLineImplCopyWithImpl<_$FlagLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return flag(this.flag, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return flag?.call(this.flag, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (flag != null) {
      return flag(this.flag, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return flag(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return flag?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (flag != null) {
      return flag(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$FlagLineImplToJson(this);
  }
}

abstract class FlagLine implements DialogueLine {
  const factory FlagLine({required final String flag, final bool value}) =
      _$FlagLineImpl;

  factory FlagLine.fromJson(Map<String, dynamic> json) =
      _$FlagLineImpl.fromJson;

  String get flag;
  bool get value;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlagLineImplCopyWith<_$FlagLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConditionLineImplCopyWith<$Res> {
  factory _$$ConditionLineImplCopyWith(
    _$ConditionLineImpl value,
    $Res Function(_$ConditionLineImpl) then,
  ) = __$$ConditionLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String flag, String ifTrue, String? ifFalse});
}

/// @nodoc
class __$$ConditionLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$ConditionLineImpl>
    implements _$$ConditionLineImplCopyWith<$Res> {
  __$$ConditionLineImplCopyWithImpl(
    _$ConditionLineImpl _value,
    $Res Function(_$ConditionLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flag = null,
    Object? ifTrue = null,
    Object? ifFalse = freezed,
  }) {
    return _then(
      _$ConditionLineImpl(
        flag: null == flag
            ? _value.flag
            : flag // ignore: cast_nullable_to_non_nullable
                  as String,
        ifTrue: null == ifTrue
            ? _value.ifTrue
            : ifTrue // ignore: cast_nullable_to_non_nullable
                  as String,
        ifFalse: freezed == ifFalse
            ? _value.ifFalse
            : ifFalse // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConditionLineImpl implements ConditionLine {
  const _$ConditionLineImpl({
    required this.flag,
    required this.ifTrue,
    this.ifFalse,
    final String? $type,
  }) : $type = $type ?? 'condition';

  factory _$ConditionLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConditionLineImplFromJson(json);

  @override
  final String flag;
  @override
  final String ifTrue;
  @override
  final String? ifFalse;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.condition(flag: $flag, ifTrue: $ifTrue, ifFalse: $ifFalse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConditionLineImpl &&
            (identical(other.flag, flag) || other.flag == flag) &&
            (identical(other.ifTrue, ifTrue) || other.ifTrue == ifTrue) &&
            (identical(other.ifFalse, ifFalse) || other.ifFalse == ifFalse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, flag, ifTrue, ifFalse);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConditionLineImplCopyWith<_$ConditionLineImpl> get copyWith =>
      __$$ConditionLineImplCopyWithImpl<_$ConditionLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return condition(this.flag, ifTrue, ifFalse);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return condition?.call(this.flag, ifTrue, ifFalse);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (condition != null) {
      return condition(this.flag, ifTrue, ifFalse);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return condition(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return condition?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (condition != null) {
      return condition(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConditionLineImplToJson(this);
  }
}

abstract class ConditionLine implements DialogueLine {
  const factory ConditionLine({
    required final String flag,
    required final String ifTrue,
    final String? ifFalse,
  }) = _$ConditionLineImpl;

  factory ConditionLine.fromJson(Map<String, dynamic> json) =
      _$ConditionLineImpl.fromJson;

  String get flag;
  String get ifTrue;
  String? get ifFalse;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConditionLineImplCopyWith<_$ConditionLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WaitLineImplCopyWith<$Res> {
  factory _$$WaitLineImplCopyWith(
    _$WaitLineImpl value,
    $Res Function(_$WaitLineImpl) then,
  ) = __$$WaitLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int duration});
}

/// @nodoc
class __$$WaitLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$WaitLineImpl>
    implements _$$WaitLineImplCopyWith<$Res> {
  __$$WaitLineImplCopyWithImpl(
    _$WaitLineImpl _value,
    $Res Function(_$WaitLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null}) {
    return _then(
      _$WaitLineImpl(
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WaitLineImpl implements WaitLine {
  const _$WaitLineImpl({this.duration = 1000, final String? $type})
    : $type = $type ?? 'wait';

  factory _$WaitLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$WaitLineImplFromJson(json);

  @override
  @JsonKey()
  final int duration;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.wait(duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WaitLineImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, duration);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WaitLineImplCopyWith<_$WaitLineImpl> get copyWith =>
      __$$WaitLineImplCopyWithImpl<_$WaitLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return wait(duration);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return wait?.call(duration);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (wait != null) {
      return wait(duration);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return wait(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return wait?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (wait != null) {
      return wait(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$WaitLineImplToJson(this);
  }
}

abstract class WaitLine implements DialogueLine {
  const factory WaitLine({final int duration}) = _$WaitLineImpl;

  factory WaitLine.fromJson(Map<String, dynamic> json) =
      _$WaitLineImpl.fromJson;

  int get duration;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WaitLineImplCopyWith<_$WaitLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TitleCardLineImplCopyWith<$Res> {
  factory _$$TitleCardLineImplCopyWith(
    _$TitleCardLineImpl value,
    $Res Function(_$TitleCardLineImpl) then,
  ) = __$$TitleCardLineImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String title, String subtitle, int duration});
}

/// @nodoc
class __$$TitleCardLineImplCopyWithImpl<$Res>
    extends _$DialogueLineCopyWithImpl<$Res, _$TitleCardLineImpl>
    implements _$$TitleCardLineImplCopyWith<$Res> {
  __$$TitleCardLineImplCopyWithImpl(
    _$TitleCardLineImpl _value,
    $Res Function(_$TitleCardLineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? subtitle = null,
    Object? duration = null,
  }) {
    return _then(
      _$TitleCardLineImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: null == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TitleCardLineImpl implements TitleCardLine {
  const _$TitleCardLineImpl({
    required this.title,
    this.subtitle = '',
    this.duration = 4000,
    final String? $type,
  }) : $type = $type ?? 'title-card';

  factory _$TitleCardLineImpl.fromJson(Map<String, dynamic> json) =>
      _$$TitleCardLineImplFromJson(json);

  @override
  final String title;
  @override
  @JsonKey()
  final String subtitle;
  @override
  @JsonKey()
  final int duration;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'DialogueLine.titleCard(title: $title, subtitle: $subtitle, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TitleCardLineImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, subtitle, duration);

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TitleCardLineImplCopyWith<_$TitleCardLineImpl> get copyWith =>
      __$$TitleCardLineImplCopyWithImpl<_$TitleCardLineImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String bg, String time, String transition)
    background,
    required TResult Function(String name, String position, String expression)
    character,
    required TResult Function(String name) characterHide,
    required TResult Function() characterHideAll,
    required TResult Function(String name, String position) characterMove,
    required TResult Function(String name, String expression) characterExpress,
    required TResult Function(String text) narration,
    required TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )
    dialogue,
    required TResult Function(String target) jump,
    required TResult Function() end,
    required TResult Function(List<DialogueChoice> choices) choice,
    required TResult Function(String character, int change, String reason)
    relationship,
    required TResult Function(String effect, int? duration) effect,
    required TResult Function(String track, bool fadeIn) music,
    required TResult Function(String sound) sfx,
    required TResult Function(String flag, bool value) flag,
    required TResult Function(String flag, String ifTrue, String? ifFalse)
    condition,
    required TResult Function(int duration) wait,
    required TResult Function(String title, String subtitle, int duration)
    titleCard,
  }) {
    return titleCard(title, subtitle, duration);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String bg, String time, String transition)? background,
    TResult? Function(String name, String position, String expression)?
    character,
    TResult? Function(String name)? characterHide,
    TResult? Function()? characterHideAll,
    TResult? Function(String name, String position)? characterMove,
    TResult? Function(String name, String expression)? characterExpress,
    TResult? Function(String text)? narration,
    TResult? Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult? Function(String target)? jump,
    TResult? Function()? end,
    TResult? Function(List<DialogueChoice> choices)? choice,
    TResult? Function(String character, int change, String reason)?
    relationship,
    TResult? Function(String effect, int? duration)? effect,
    TResult? Function(String track, bool fadeIn)? music,
    TResult? Function(String sound)? sfx,
    TResult? Function(String flag, bool value)? flag,
    TResult? Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult? Function(int duration)? wait,
    TResult? Function(String title, String subtitle, int duration)? titleCard,
  }) {
    return titleCard?.call(title, subtitle, duration);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String bg, String time, String transition)? background,
    TResult Function(String name, String position, String expression)?
    character,
    TResult Function(String name)? characterHide,
    TResult Function()? characterHideAll,
    TResult Function(String name, String position)? characterMove,
    TResult Function(String name, String expression)? characterExpress,
    TResult Function(String text)? narration,
    TResult Function(
      String speaker,
      String text,
      String? expression,
      String? translation,
      String? transcription,
    )?
    dialogue,
    TResult Function(String target)? jump,
    TResult Function()? end,
    TResult Function(List<DialogueChoice> choices)? choice,
    TResult Function(String character, int change, String reason)? relationship,
    TResult Function(String effect, int? duration)? effect,
    TResult Function(String track, bool fadeIn)? music,
    TResult Function(String sound)? sfx,
    TResult Function(String flag, bool value)? flag,
    TResult Function(String flag, String ifTrue, String? ifFalse)? condition,
    TResult Function(int duration)? wait,
    TResult Function(String title, String subtitle, int duration)? titleCard,
    required TResult orElse(),
  }) {
    if (titleCard != null) {
      return titleCard(title, subtitle, duration);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BackgroundLine value) background,
    required TResult Function(CharacterLine value) character,
    required TResult Function(CharacterHideLine value) characterHide,
    required TResult Function(CharacterHideAllLine value) characterHideAll,
    required TResult Function(CharacterMoveLine value) characterMove,
    required TResult Function(CharacterExpressLine value) characterExpress,
    required TResult Function(NarrationLine value) narration,
    required TResult Function(DialogueTextLine value) dialogue,
    required TResult Function(JumpLine value) jump,
    required TResult Function(EndLine value) end,
    required TResult Function(ChoiceLine value) choice,
    required TResult Function(RelationshipLine value) relationship,
    required TResult Function(EffectLine value) effect,
    required TResult Function(MusicLine value) music,
    required TResult Function(SfxLine value) sfx,
    required TResult Function(FlagLine value) flag,
    required TResult Function(ConditionLine value) condition,
    required TResult Function(WaitLine value) wait,
    required TResult Function(TitleCardLine value) titleCard,
  }) {
    return titleCard(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BackgroundLine value)? background,
    TResult? Function(CharacterLine value)? character,
    TResult? Function(CharacterHideLine value)? characterHide,
    TResult? Function(CharacterHideAllLine value)? characterHideAll,
    TResult? Function(CharacterMoveLine value)? characterMove,
    TResult? Function(CharacterExpressLine value)? characterExpress,
    TResult? Function(NarrationLine value)? narration,
    TResult? Function(DialogueTextLine value)? dialogue,
    TResult? Function(JumpLine value)? jump,
    TResult? Function(EndLine value)? end,
    TResult? Function(ChoiceLine value)? choice,
    TResult? Function(RelationshipLine value)? relationship,
    TResult? Function(EffectLine value)? effect,
    TResult? Function(MusicLine value)? music,
    TResult? Function(SfxLine value)? sfx,
    TResult? Function(FlagLine value)? flag,
    TResult? Function(ConditionLine value)? condition,
    TResult? Function(WaitLine value)? wait,
    TResult? Function(TitleCardLine value)? titleCard,
  }) {
    return titleCard?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BackgroundLine value)? background,
    TResult Function(CharacterLine value)? character,
    TResult Function(CharacterHideLine value)? characterHide,
    TResult Function(CharacterHideAllLine value)? characterHideAll,
    TResult Function(CharacterMoveLine value)? characterMove,
    TResult Function(CharacterExpressLine value)? characterExpress,
    TResult Function(NarrationLine value)? narration,
    TResult Function(DialogueTextLine value)? dialogue,
    TResult Function(JumpLine value)? jump,
    TResult Function(EndLine value)? end,
    TResult Function(ChoiceLine value)? choice,
    TResult Function(RelationshipLine value)? relationship,
    TResult Function(EffectLine value)? effect,
    TResult Function(MusicLine value)? music,
    TResult Function(SfxLine value)? sfx,
    TResult Function(FlagLine value)? flag,
    TResult Function(ConditionLine value)? condition,
    TResult Function(WaitLine value)? wait,
    TResult Function(TitleCardLine value)? titleCard,
    required TResult orElse(),
  }) {
    if (titleCard != null) {
      return titleCard(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TitleCardLineImplToJson(this);
  }
}

abstract class TitleCardLine implements DialogueLine {
  const factory TitleCardLine({
    required final String title,
    final String subtitle,
    final int duration,
  }) = _$TitleCardLineImpl;

  factory TitleCardLine.fromJson(Map<String, dynamic> json) =
      _$TitleCardLineImpl.fromJson;

  String get title;
  String get subtitle;
  int get duration;

  /// Create a copy of DialogueLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TitleCardLineImplCopyWith<_$TitleCardLineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DialogueChoice _$DialogueChoiceFromJson(Map<String, dynamic> json) {
  return _DialogueChoice.fromJson(json);
}

/// @nodoc
mixin _$DialogueChoice {
  String get text => throw _privateConstructorUsedError;
  String get next => throw _privateConstructorUsedError;

  /// Optional short hint shown under the choice text (`choice(text, next, { hint })`).
  String? get hint => throw _privateConstructorUsedError;

  /// Optional relationship-change shorthand (`choice(text, next, { relationship })`).
  String? get relationship => throw _privateConstructorUsedError;

  /// Serializes this DialogueChoice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DialogueChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DialogueChoiceCopyWith<DialogueChoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogueChoiceCopyWith<$Res> {
  factory $DialogueChoiceCopyWith(
    DialogueChoice value,
    $Res Function(DialogueChoice) then,
  ) = _$DialogueChoiceCopyWithImpl<$Res, DialogueChoice>;
  @useResult
  $Res call({String text, String next, String? hint, String? relationship});
}

/// @nodoc
class _$DialogueChoiceCopyWithImpl<$Res, $Val extends DialogueChoice>
    implements $DialogueChoiceCopyWith<$Res> {
  _$DialogueChoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DialogueChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? next = null,
    Object? hint = freezed,
    Object? relationship = freezed,
  }) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            next: null == next
                ? _value.next
                : next // ignore: cast_nullable_to_non_nullable
                      as String,
            hint: freezed == hint
                ? _value.hint
                : hint // ignore: cast_nullable_to_non_nullable
                      as String?,
            relationship: freezed == relationship
                ? _value.relationship
                : relationship // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DialogueChoiceImplCopyWith<$Res>
    implements $DialogueChoiceCopyWith<$Res> {
  factory _$$DialogueChoiceImplCopyWith(
    _$DialogueChoiceImpl value,
    $Res Function(_$DialogueChoiceImpl) then,
  ) = __$$DialogueChoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String next, String? hint, String? relationship});
}

/// @nodoc
class __$$DialogueChoiceImplCopyWithImpl<$Res>
    extends _$DialogueChoiceCopyWithImpl<$Res, _$DialogueChoiceImpl>
    implements _$$DialogueChoiceImplCopyWith<$Res> {
  __$$DialogueChoiceImplCopyWithImpl(
    _$DialogueChoiceImpl _value,
    $Res Function(_$DialogueChoiceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueChoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? next = null,
    Object? hint = freezed,
    Object? relationship = freezed,
  }) {
    return _then(
      _$DialogueChoiceImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        next: null == next
            ? _value.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String,
        hint: freezed == hint
            ? _value.hint
            : hint // ignore: cast_nullable_to_non_nullable
                  as String?,
        relationship: freezed == relationship
            ? _value.relationship
            : relationship // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DialogueChoiceImpl implements _DialogueChoice {
  const _$DialogueChoiceImpl({
    required this.text,
    required this.next,
    this.hint,
    this.relationship,
  });

  factory _$DialogueChoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$DialogueChoiceImplFromJson(json);

  @override
  final String text;
  @override
  final String next;

  /// Optional short hint shown under the choice text (`choice(text, next, { hint })`).
  @override
  final String? hint;

  /// Optional relationship-change shorthand (`choice(text, next, { relationship })`).
  @override
  final String? relationship;

  @override
  String toString() {
    return 'DialogueChoice(text: $text, next: $next, hint: $hint, relationship: $relationship)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogueChoiceImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, next, hint, relationship);

  /// Create a copy of DialogueChoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogueChoiceImplCopyWith<_$DialogueChoiceImpl> get copyWith =>
      __$$DialogueChoiceImplCopyWithImpl<_$DialogueChoiceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DialogueChoiceImplToJson(this);
  }
}

abstract class _DialogueChoice implements DialogueChoice {
  const factory _DialogueChoice({
    required final String text,
    required final String next,
    final String? hint,
    final String? relationship,
  }) = _$DialogueChoiceImpl;

  factory _DialogueChoice.fromJson(Map<String, dynamic> json) =
      _$DialogueChoiceImpl.fromJson;

  @override
  String get text;
  @override
  String get next;

  /// Optional short hint shown under the choice text (`choice(text, next, { hint })`).
  @override
  String? get hint;

  /// Optional relationship-change shorthand (`choice(text, next, { relationship })`).
  @override
  String? get relationship;

  /// Create a copy of DialogueChoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DialogueChoiceImplCopyWith<_$DialogueChoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
