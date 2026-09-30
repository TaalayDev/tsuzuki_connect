// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DialogueScene _$DialogueSceneFromJson(Map<String, dynamic> json) {
  return _DialogueScene.fromJson(json);
}

/// @nodoc
mixin _$DialogueScene {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<DialogueLine> get lines => throw _privateConstructorUsedError;

  /// Serializes this DialogueScene to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DialogueScene
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DialogueSceneCopyWith<DialogueScene> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DialogueSceneCopyWith<$Res> {
  factory $DialogueSceneCopyWith(
    DialogueScene value,
    $Res Function(DialogueScene) then,
  ) = _$DialogueSceneCopyWithImpl<$Res, DialogueScene>;
  @useResult
  $Res call({String id, String label, List<DialogueLine> lines});
}

/// @nodoc
class _$DialogueSceneCopyWithImpl<$Res, $Val extends DialogueScene>
    implements $DialogueSceneCopyWith<$Res> {
  _$DialogueSceneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DialogueScene
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? label = null, Object? lines = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<DialogueLine>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DialogueSceneImplCopyWith<$Res>
    implements $DialogueSceneCopyWith<$Res> {
  factory _$$DialogueSceneImplCopyWith(
    _$DialogueSceneImpl value,
    $Res Function(_$DialogueSceneImpl) then,
  ) = __$$DialogueSceneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, List<DialogueLine> lines});
}

/// @nodoc
class __$$DialogueSceneImplCopyWithImpl<$Res>
    extends _$DialogueSceneCopyWithImpl<$Res, _$DialogueSceneImpl>
    implements _$$DialogueSceneImplCopyWith<$Res> {
  __$$DialogueSceneImplCopyWithImpl(
    _$DialogueSceneImpl _value,
    $Res Function(_$DialogueSceneImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DialogueScene
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? label = null, Object? lines = null}) {
    return _then(
      _$DialogueSceneImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<DialogueLine>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DialogueSceneImpl implements _DialogueScene {
  const _$DialogueSceneImpl({
    required this.id,
    required this.label,
    required final List<DialogueLine> lines,
  }) : _lines = lines;

  factory _$DialogueSceneImpl.fromJson(Map<String, dynamic> json) =>
      _$$DialogueSceneImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  final List<DialogueLine> _lines;
  @override
  List<DialogueLine> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'DialogueScene(id: $id, label: $label, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DialogueSceneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of DialogueScene
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DialogueSceneImplCopyWith<_$DialogueSceneImpl> get copyWith =>
      __$$DialogueSceneImplCopyWithImpl<_$DialogueSceneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DialogueSceneImplToJson(this);
  }
}

abstract class _DialogueScene implements DialogueScene {
  const factory _DialogueScene({
    required final String id,
    required final String label,
    required final List<DialogueLine> lines,
  }) = _$DialogueSceneImpl;

  factory _DialogueScene.fromJson(Map<String, dynamic> json) =
      _$DialogueSceneImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  List<DialogueLine> get lines;

  /// Create a copy of DialogueScene
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DialogueSceneImplCopyWith<_$DialogueSceneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Story _$StoryFromJson(Map<String, dynamic> json) {
  return _Story.fromJson(json);
}

/// @nodoc
mixin _$Story {
  @JsonKey(fromJson: _idFromJson)
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get subtitle => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get estimatedTime => throw _privateConstructorUsedError;
  String get cefrFocus => throw _privateConstructorUsedError;
  List<DialogueScene> get scenes => throw _privateConstructorUsedError;

  /// Serializes this Story to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryCopyWith<Story> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCopyWith<$Res> {
  factory $StoryCopyWith(Story value, $Res Function(Story) then) =
      _$StoryCopyWithImpl<$Res, Story>;
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String title,
    String subtitle,
    String description,
    String estimatedTime,
    String cefrFocus,
    List<DialogueScene> scenes,
  });
}

/// @nodoc
class _$StoryCopyWithImpl<$Res, $Val extends Story>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? description = null,
    Object? estimatedTime = null,
    Object? cefrFocus = null,
    Object? scenes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: null == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedTime: null == estimatedTime
                ? _value.estimatedTime
                : estimatedTime // ignore: cast_nullable_to_non_nullable
                      as String,
            cefrFocus: null == cefrFocus
                ? _value.cefrFocus
                : cefrFocus // ignore: cast_nullable_to_non_nullable
                      as String,
            scenes: null == scenes
                ? _value.scenes
                : scenes // ignore: cast_nullable_to_non_nullable
                      as List<DialogueScene>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryImplCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$$StoryImplCopyWith(
    _$StoryImpl value,
    $Res Function(_$StoryImpl) then,
  ) = __$$StoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: _idFromJson) String id,
    String title,
    String subtitle,
    String description,
    String estimatedTime,
    String cefrFocus,
    List<DialogueScene> scenes,
  });
}

/// @nodoc
class __$$StoryImplCopyWithImpl<$Res>
    extends _$StoryCopyWithImpl<$Res, _$StoryImpl>
    implements _$$StoryImplCopyWith<$Res> {
  __$$StoryImplCopyWithImpl(
    _$StoryImpl _value,
    $Res Function(_$StoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = null,
    Object? description = null,
    Object? estimatedTime = null,
    Object? cefrFocus = null,
    Object? scenes = null,
  }) {
    return _then(
      _$StoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: null == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedTime: null == estimatedTime
            ? _value.estimatedTime
            : estimatedTime // ignore: cast_nullable_to_non_nullable
                  as String,
        cefrFocus: null == cefrFocus
            ? _value.cefrFocus
            : cefrFocus // ignore: cast_nullable_to_non_nullable
                  as String,
        scenes: null == scenes
            ? _value._scenes
            : scenes // ignore: cast_nullable_to_non_nullable
                  as List<DialogueScene>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryImpl implements _Story {
  const _$StoryImpl({
    @JsonKey(fromJson: _idFromJson) required this.id,
    required this.title,
    required this.subtitle,
    this.description = '',
    this.estimatedTime = '',
    this.cefrFocus = 'A1',
    required final List<DialogueScene> scenes,
  }) : _scenes = scenes;

  factory _$StoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryImplFromJson(json);

  @override
  @JsonKey(fromJson: _idFromJson)
  final String id;
  @override
  final String title;
  @override
  final String subtitle;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String estimatedTime;
  @override
  @JsonKey()
  final String cefrFocus;
  final List<DialogueScene> _scenes;
  @override
  List<DialogueScene> get scenes {
    if (_scenes is EqualUnmodifiableListView) return _scenes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scenes);
  }

  @override
  String toString() {
    return 'Story(id: $id, title: $title, subtitle: $subtitle, description: $description, estimatedTime: $estimatedTime, cefrFocus: $cefrFocus, scenes: $scenes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime) &&
            (identical(other.cefrFocus, cefrFocus) ||
                other.cefrFocus == cefrFocus) &&
            const DeepCollectionEquality().equals(other._scenes, _scenes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    subtitle,
    description,
    estimatedTime,
    cefrFocus,
    const DeepCollectionEquality().hash(_scenes),
  );

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      __$$StoryImplCopyWithImpl<_$StoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryImplToJson(this);
  }
}

abstract class _Story implements Story {
  const factory _Story({
    @JsonKey(fromJson: _idFromJson) required final String id,
    required final String title,
    required final String subtitle,
    final String description,
    final String estimatedTime,
    final String cefrFocus,
    required final List<DialogueScene> scenes,
  }) = _$StoryImpl;

  factory _Story.fromJson(Map<String, dynamic> json) = _$StoryImpl.fromJson;

  @override
  @JsonKey(fromJson: _idFromJson)
  String get id;
  @override
  String get title;
  @override
  String get subtitle;
  @override
  String get description;
  @override
  String get estimatedTime;
  @override
  String get cefrFocus;
  @override
  List<DialogueScene> get scenes;

  /// Create a copy of Story
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryImplCopyWith<_$StoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
