// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocab_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VocabWord _$VocabWordFromJson(Map<String, dynamic> json) {
  return _VocabWord.fromJson(json);
}

/// @nodoc
mixin _$VocabWord {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get level => throw _privateConstructorUsedError;
  String get cefrLevel => throw _privateConstructorUsedError;
  String get partOfSpeech => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;
  String get translation => throw _privateConstructorUsedError;
  String get example => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Per-language translations of [word], keyed by language code
  /// (ru, zh, ko, jp, de, fr, pt, es, ar, ...).
  Map<String, String> get tr => throw _privateConstructorUsedError;

  /// Serializes this VocabWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VocabWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VocabWordCopyWith<VocabWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VocabWordCopyWith<$Res> {
  factory $VocabWordCopyWith(VocabWord value, $Res Function(VocabWord) then) =
      _$VocabWordCopyWithImpl<$Res, VocabWord>;
  @useResult
  $Res call({
    String id,
    String word,
    String level,
    String cefrLevel,
    String partOfSpeech,
    String definition,
    String translation,
    String example,
    String category,
    List<String> tags,
    Map<String, String> tr,
  });
}

/// @nodoc
class _$VocabWordCopyWithImpl<$Res, $Val extends VocabWord>
    implements $VocabWordCopyWith<$Res> {
  _$VocabWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VocabWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? level = null,
    Object? cefrLevel = null,
    Object? partOfSpeech = null,
    Object? definition = null,
    Object? translation = null,
    Object? example = null,
    Object? category = null,
    Object? tags = null,
    Object? tr = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            word: null == word
                ? _value.word
                : word // ignore: cast_nullable_to_non_nullable
                      as String,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String,
            cefrLevel: null == cefrLevel
                ? _value.cefrLevel
                : cefrLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            partOfSpeech: null == partOfSpeech
                ? _value.partOfSpeech
                : partOfSpeech // ignore: cast_nullable_to_non_nullable
                      as String,
            definition: null == definition
                ? _value.definition
                : definition // ignore: cast_nullable_to_non_nullable
                      as String,
            translation: null == translation
                ? _value.translation
                : translation // ignore: cast_nullable_to_non_nullable
                      as String,
            example: null == example
                ? _value.example
                : example // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tr: null == tr
                ? _value.tr
                : tr // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VocabWordImplCopyWith<$Res>
    implements $VocabWordCopyWith<$Res> {
  factory _$$VocabWordImplCopyWith(
    _$VocabWordImpl value,
    $Res Function(_$VocabWordImpl) then,
  ) = __$$VocabWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String word,
    String level,
    String cefrLevel,
    String partOfSpeech,
    String definition,
    String translation,
    String example,
    String category,
    List<String> tags,
    Map<String, String> tr,
  });
}

/// @nodoc
class __$$VocabWordImplCopyWithImpl<$Res>
    extends _$VocabWordCopyWithImpl<$Res, _$VocabWordImpl>
    implements _$$VocabWordImplCopyWith<$Res> {
  __$$VocabWordImplCopyWithImpl(
    _$VocabWordImpl _value,
    $Res Function(_$VocabWordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VocabWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? level = null,
    Object? cefrLevel = null,
    Object? partOfSpeech = null,
    Object? definition = null,
    Object? translation = null,
    Object? example = null,
    Object? category = null,
    Object? tags = null,
    Object? tr = null,
  }) {
    return _then(
      _$VocabWordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        word: null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String,
        cefrLevel: null == cefrLevel
            ? _value.cefrLevel
            : cefrLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        partOfSpeech: null == partOfSpeech
            ? _value.partOfSpeech
            : partOfSpeech // ignore: cast_nullable_to_non_nullable
                  as String,
        definition: null == definition
            ? _value.definition
            : definition // ignore: cast_nullable_to_non_nullable
                  as String,
        translation: null == translation
            ? _value.translation
            : translation // ignore: cast_nullable_to_non_nullable
                  as String,
        example: null == example
            ? _value.example
            : example // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tr: null == tr
            ? _value._tr
            : tr // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VocabWordImpl implements _VocabWord {
  const _$VocabWordImpl({
    required this.id,
    required this.word,
    required this.level,
    required this.cefrLevel,
    required this.partOfSpeech,
    required this.definition,
    required this.translation,
    required this.example,
    required this.category,
    final List<String> tags = const <String>[],
    final Map<String, String> tr = const <String, String>{},
  }) : _tags = tags,
       _tr = tr;

  factory _$VocabWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$VocabWordImplFromJson(json);

  @override
  final String id;
  @override
  final String word;
  @override
  final String level;
  @override
  final String cefrLevel;
  @override
  final String partOfSpeech;
  @override
  final String definition;
  @override
  final String translation;
  @override
  final String example;
  @override
  final String category;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Per-language translations of [word], keyed by language code
  /// (ru, zh, ko, jp, de, fr, pt, es, ar, ...).
  final Map<String, String> _tr;

  /// Per-language translations of [word], keyed by language code
  /// (ru, zh, ko, jp, de, fr, pt, es, ar, ...).
  @override
  @JsonKey()
  Map<String, String> get tr {
    if (_tr is EqualUnmodifiableMapView) return _tr;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tr);
  }

  @override
  String toString() {
    return 'VocabWord(id: $id, word: $word, level: $level, cefrLevel: $cefrLevel, partOfSpeech: $partOfSpeech, definition: $definition, translation: $translation, example: $example, category: $category, tags: $tags, tr: $tr)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VocabWordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.cefrLevel, cefrLevel) ||
                other.cefrLevel == cefrLevel) &&
            (identical(other.partOfSpeech, partOfSpeech) ||
                other.partOfSpeech == partOfSpeech) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.example, example) || other.example == example) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._tr, _tr));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    word,
    level,
    cefrLevel,
    partOfSpeech,
    definition,
    translation,
    example,
    category,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_tr),
  );

  /// Create a copy of VocabWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VocabWordImplCopyWith<_$VocabWordImpl> get copyWith =>
      __$$VocabWordImplCopyWithImpl<_$VocabWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VocabWordImplToJson(this);
  }
}

abstract class _VocabWord implements VocabWord {
  const factory _VocabWord({
    required final String id,
    required final String word,
    required final String level,
    required final String cefrLevel,
    required final String partOfSpeech,
    required final String definition,
    required final String translation,
    required final String example,
    required final String category,
    final List<String> tags,
    final Map<String, String> tr,
  }) = _$VocabWordImpl;

  factory _VocabWord.fromJson(Map<String, dynamic> json) =
      _$VocabWordImpl.fromJson;

  @override
  String get id;
  @override
  String get word;
  @override
  String get level;
  @override
  String get cefrLevel;
  @override
  String get partOfSpeech;
  @override
  String get definition;
  @override
  String get translation;
  @override
  String get example;
  @override
  String get category;
  @override
  List<String> get tags;

  /// Per-language translations of [word], keyed by language code
  /// (ru, zh, ko, jp, de, fr, pt, es, ar, ...).
  @override
  Map<String, String> get tr;

  /// Create a copy of VocabWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VocabWordImplCopyWith<_$VocabWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
