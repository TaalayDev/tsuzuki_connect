// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_question_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestQuestion {
  int get id;
  String get questionJp;
  String get questionEn;
  TestQuestionType get type;
  List<TestAnswer> get answers;
  int get correctAnswerIndex;
  int get jlptLevel; // 5 = N5 (easiest), 1 = N1 (hardest)
  String get category; // vocabulary, grammar, reading, etc.
  String? get hint;
  String? get explanation;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestQuestionCopyWith<TestQuestion> get copyWith =>
      _$TestQuestionCopyWithImpl<TestQuestion>(
          this as TestQuestion, _$identity);

  /// Serializes this TestQuestion to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestQuestion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionJp, questionJp) ||
                other.questionJp == questionJp) &&
            (identical(other.questionEn, questionEn) ||
                other.questionEn == questionEn) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.answers, answers) &&
            (identical(other.correctAnswerIndex, correctAnswerIndex) ||
                other.correctAnswerIndex == correctAnswerIndex) &&
            (identical(other.jlptLevel, jlptLevel) ||
                other.jlptLevel == jlptLevel) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      questionJp,
      questionEn,
      type,
      const DeepCollectionEquality().hash(answers),
      correctAnswerIndex,
      jlptLevel,
      category,
      hint,
      explanation);

  @override
  String toString() {
    return 'TestQuestion(id: $id, questionJp: $questionJp, questionEn: $questionEn, type: $type, answers: $answers, correctAnswerIndex: $correctAnswerIndex, jlptLevel: $jlptLevel, category: $category, hint: $hint, explanation: $explanation)';
  }
}

/// @nodoc
abstract mixin class $TestQuestionCopyWith<$Res> {
  factory $TestQuestionCopyWith(
          TestQuestion value, $Res Function(TestQuestion) _then) =
      _$TestQuestionCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String questionJp,
      String questionEn,
      TestQuestionType type,
      List<TestAnswer> answers,
      int correctAnswerIndex,
      int jlptLevel,
      String category,
      String? hint,
      String? explanation});
}

/// @nodoc
class _$TestQuestionCopyWithImpl<$Res> implements $TestQuestionCopyWith<$Res> {
  _$TestQuestionCopyWithImpl(this._self, this._then);

  final TestQuestion _self;
  final $Res Function(TestQuestion) _then;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionJp = null,
    Object? questionEn = null,
    Object? type = null,
    Object? answers = null,
    Object? correctAnswerIndex = null,
    Object? jlptLevel = null,
    Object? category = null,
    Object? hint = freezed,
    Object? explanation = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      questionJp: null == questionJp
          ? _self.questionJp
          : questionJp // ignore: cast_nullable_to_non_nullable
              as String,
      questionEn: null == questionEn
          ? _self.questionEn
          : questionEn // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TestQuestionType,
      answers: null == answers
          ? _self.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<TestAnswer>,
      correctAnswerIndex: null == correctAnswerIndex
          ? _self.correctAnswerIndex
          : correctAnswerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      jlptLevel: null == jlptLevel
          ? _self.jlptLevel
          : jlptLevel // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      hint: freezed == hint
          ? _self.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      explanation: freezed == explanation
          ? _self.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TestQuestion implements TestQuestion {
  const _TestQuestion(
      {required this.id,
      required this.questionJp,
      required this.questionEn,
      required this.type,
      required final List<TestAnswer> answers,
      required this.correctAnswerIndex,
      required this.jlptLevel,
      required this.category,
      this.hint,
      this.explanation})
      : _answers = answers;
  factory _TestQuestion.fromJson(Map<String, dynamic> json) =>
      _$TestQuestionFromJson(json);

  @override
  final int id;
  @override
  final String questionJp;
  @override
  final String questionEn;
  @override
  final TestQuestionType type;
  final List<TestAnswer> _answers;
  @override
  List<TestAnswer> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  final int correctAnswerIndex;
  @override
  final int jlptLevel;
// 5 = N5 (easiest), 1 = N1 (hardest)
  @override
  final String category;
// vocabulary, grammar, reading, etc.
  @override
  final String? hint;
  @override
  final String? explanation;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestQuestionCopyWith<_TestQuestion> get copyWith =>
      __$TestQuestionCopyWithImpl<_TestQuestion>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestQuestionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestQuestion &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionJp, questionJp) ||
                other.questionJp == questionJp) &&
            (identical(other.questionEn, questionEn) ||
                other.questionEn == questionEn) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.correctAnswerIndex, correctAnswerIndex) ||
                other.correctAnswerIndex == correctAnswerIndex) &&
            (identical(other.jlptLevel, jlptLevel) ||
                other.jlptLevel == jlptLevel) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      questionJp,
      questionEn,
      type,
      const DeepCollectionEquality().hash(_answers),
      correctAnswerIndex,
      jlptLevel,
      category,
      hint,
      explanation);

  @override
  String toString() {
    return 'TestQuestion(id: $id, questionJp: $questionJp, questionEn: $questionEn, type: $type, answers: $answers, correctAnswerIndex: $correctAnswerIndex, jlptLevel: $jlptLevel, category: $category, hint: $hint, explanation: $explanation)';
  }
}

/// @nodoc
abstract mixin class _$TestQuestionCopyWith<$Res>
    implements $TestQuestionCopyWith<$Res> {
  factory _$TestQuestionCopyWith(
          _TestQuestion value, $Res Function(_TestQuestion) _then) =
      __$TestQuestionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String questionJp,
      String questionEn,
      TestQuestionType type,
      List<TestAnswer> answers,
      int correctAnswerIndex,
      int jlptLevel,
      String category,
      String? hint,
      String? explanation});
}

/// @nodoc
class __$TestQuestionCopyWithImpl<$Res>
    implements _$TestQuestionCopyWith<$Res> {
  __$TestQuestionCopyWithImpl(this._self, this._then);

  final _TestQuestion _self;
  final $Res Function(_TestQuestion) _then;

  /// Create a copy of TestQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? questionJp = null,
    Object? questionEn = null,
    Object? type = null,
    Object? answers = null,
    Object? correctAnswerIndex = null,
    Object? jlptLevel = null,
    Object? category = null,
    Object? hint = freezed,
    Object? explanation = freezed,
  }) {
    return _then(_TestQuestion(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      questionJp: null == questionJp
          ? _self.questionJp
          : questionJp // ignore: cast_nullable_to_non_nullable
              as String,
      questionEn: null == questionEn
          ? _self.questionEn
          : questionEn // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TestQuestionType,
      answers: null == answers
          ? _self._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<TestAnswer>,
      correctAnswerIndex: null == correctAnswerIndex
          ? _self.correctAnswerIndex
          : correctAnswerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      jlptLevel: null == jlptLevel
          ? _self.jlptLevel
          : jlptLevel // ignore: cast_nullable_to_non_nullable
              as int,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      hint: freezed == hint
          ? _self.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
      explanation: freezed == explanation
          ? _self.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TestAnswer {
  String get textJp;
  String get textEn;
  String? get furigana;

  /// Create a copy of TestAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestAnswerCopyWith<TestAnswer> get copyWith =>
      _$TestAnswerCopyWithImpl<TestAnswer>(this as TestAnswer, _$identity);

  /// Serializes this TestAnswer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestAnswer &&
            (identical(other.textJp, textJp) || other.textJp == textJp) &&
            (identical(other.textEn, textEn) || other.textEn == textEn) &&
            (identical(other.furigana, furigana) ||
                other.furigana == furigana));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, textJp, textEn, furigana);

  @override
  String toString() {
    return 'TestAnswer(textJp: $textJp, textEn: $textEn, furigana: $furigana)';
  }
}

/// @nodoc
abstract mixin class $TestAnswerCopyWith<$Res> {
  factory $TestAnswerCopyWith(
          TestAnswer value, $Res Function(TestAnswer) _then) =
      _$TestAnswerCopyWithImpl;
  @useResult
  $Res call({String textJp, String textEn, String? furigana});
}

/// @nodoc
class _$TestAnswerCopyWithImpl<$Res> implements $TestAnswerCopyWith<$Res> {
  _$TestAnswerCopyWithImpl(this._self, this._then);

  final TestAnswer _self;
  final $Res Function(TestAnswer) _then;

  /// Create a copy of TestAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textJp = null,
    Object? textEn = null,
    Object? furigana = freezed,
  }) {
    return _then(_self.copyWith(
      textJp: null == textJp
          ? _self.textJp
          : textJp // ignore: cast_nullable_to_non_nullable
              as String,
      textEn: null == textEn
          ? _self.textEn
          : textEn // ignore: cast_nullable_to_non_nullable
              as String,
      furigana: freezed == furigana
          ? _self.furigana
          : furigana // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TestAnswer implements TestAnswer {
  const _TestAnswer(
      {required this.textJp, required this.textEn, this.furigana});
  factory _TestAnswer.fromJson(Map<String, dynamic> json) =>
      _$TestAnswerFromJson(json);

  @override
  final String textJp;
  @override
  final String textEn;
  @override
  final String? furigana;

  /// Create a copy of TestAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestAnswerCopyWith<_TestAnswer> get copyWith =>
      __$TestAnswerCopyWithImpl<_TestAnswer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestAnswerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestAnswer &&
            (identical(other.textJp, textJp) || other.textJp == textJp) &&
            (identical(other.textEn, textEn) || other.textEn == textEn) &&
            (identical(other.furigana, furigana) ||
                other.furigana == furigana));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, textJp, textEn, furigana);

  @override
  String toString() {
    return 'TestAnswer(textJp: $textJp, textEn: $textEn, furigana: $furigana)';
  }
}

/// @nodoc
abstract mixin class _$TestAnswerCopyWith<$Res>
    implements $TestAnswerCopyWith<$Res> {
  factory _$TestAnswerCopyWith(
          _TestAnswer value, $Res Function(_TestAnswer) _then) =
      __$TestAnswerCopyWithImpl;
  @override
  @useResult
  $Res call({String textJp, String textEn, String? furigana});
}

/// @nodoc
class __$TestAnswerCopyWithImpl<$Res> implements _$TestAnswerCopyWith<$Res> {
  __$TestAnswerCopyWithImpl(this._self, this._then);

  final _TestAnswer _self;
  final $Res Function(_TestAnswer) _then;

  /// Create a copy of TestAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? textJp = null,
    Object? textEn = null,
    Object? furigana = freezed,
  }) {
    return _then(_TestAnswer(
      textJp: null == textJp
          ? _self.textJp
          : textJp // ignore: cast_nullable_to_non_nullable
              as String,
      textEn: null == textEn
          ? _self.textEn
          : textEn // ignore: cast_nullable_to_non_nullable
              as String,
      furigana: freezed == furigana
          ? _self.furigana
          : furigana // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TestResult {
  int get totalQuestions;
  int get correctAnswers;
  int get determinedLevel; // 1-5 (N1-N5)
  Map<String, int> get categoryScores;
  double get accuracyPercentage;
  List<int> get incorrectQuestionIds;

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestResultCopyWith<TestResult> get copyWith =>
      _$TestResultCopyWithImpl<TestResult>(this as TestResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestResult &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.determinedLevel, determinedLevel) ||
                other.determinedLevel == determinedLevel) &&
            const DeepCollectionEquality()
                .equals(other.categoryScores, categoryScores) &&
            (identical(other.accuracyPercentage, accuracyPercentage) ||
                other.accuracyPercentage == accuracyPercentage) &&
            const DeepCollectionEquality()
                .equals(other.incorrectQuestionIds, incorrectQuestionIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalQuestions,
      correctAnswers,
      determinedLevel,
      const DeepCollectionEquality().hash(categoryScores),
      accuracyPercentage,
      const DeepCollectionEquality().hash(incorrectQuestionIds));

  @override
  String toString() {
    return 'TestResult(totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, determinedLevel: $determinedLevel, categoryScores: $categoryScores, accuracyPercentage: $accuracyPercentage, incorrectQuestionIds: $incorrectQuestionIds)';
  }
}

/// @nodoc
abstract mixin class $TestResultCopyWith<$Res> {
  factory $TestResultCopyWith(
          TestResult value, $Res Function(TestResult) _then) =
      _$TestResultCopyWithImpl;
  @useResult
  $Res call(
      {int totalQuestions,
      int correctAnswers,
      int determinedLevel,
      Map<String, int> categoryScores,
      double accuracyPercentage,
      List<int> incorrectQuestionIds});
}

/// @nodoc
class _$TestResultCopyWithImpl<$Res> implements $TestResultCopyWith<$Res> {
  _$TestResultCopyWithImpl(this._self, this._then);

  final TestResult _self;
  final $Res Function(TestResult) _then;

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? determinedLevel = null,
    Object? categoryScores = null,
    Object? accuracyPercentage = null,
    Object? incorrectQuestionIds = null,
  }) {
    return _then(_self.copyWith(
      totalQuestions: null == totalQuestions
          ? _self.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _self.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      determinedLevel: null == determinedLevel
          ? _self.determinedLevel
          : determinedLevel // ignore: cast_nullable_to_non_nullable
              as int,
      categoryScores: null == categoryScores
          ? _self.categoryScores
          : categoryScores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      accuracyPercentage: null == accuracyPercentage
          ? _self.accuracyPercentage
          : accuracyPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      incorrectQuestionIds: null == incorrectQuestionIds
          ? _self.incorrectQuestionIds
          : incorrectQuestionIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _TestResult extends TestResult {
  const _TestResult(
      {required this.totalQuestions,
      required this.correctAnswers,
      required this.determinedLevel,
      required final Map<String, int> categoryScores,
      required this.accuracyPercentage,
      required final List<int> incorrectQuestionIds})
      : _categoryScores = categoryScores,
        _incorrectQuestionIds = incorrectQuestionIds,
        super._();

  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  @override
  final int determinedLevel;
// 1-5 (N1-N5)
  final Map<String, int> _categoryScores;
// 1-5 (N1-N5)
  @override
  Map<String, int> get categoryScores {
    if (_categoryScores is EqualUnmodifiableMapView) return _categoryScores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryScores);
  }

  @override
  final double accuracyPercentage;
  final List<int> _incorrectQuestionIds;
  @override
  List<int> get incorrectQuestionIds {
    if (_incorrectQuestionIds is EqualUnmodifiableListView)
      return _incorrectQuestionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_incorrectQuestionIds);
  }

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestResultCopyWith<_TestResult> get copyWith =>
      __$TestResultCopyWithImpl<_TestResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestResult &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.determinedLevel, determinedLevel) ||
                other.determinedLevel == determinedLevel) &&
            const DeepCollectionEquality()
                .equals(other._categoryScores, _categoryScores) &&
            (identical(other.accuracyPercentage, accuracyPercentage) ||
                other.accuracyPercentage == accuracyPercentage) &&
            const DeepCollectionEquality()
                .equals(other._incorrectQuestionIds, _incorrectQuestionIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalQuestions,
      correctAnswers,
      determinedLevel,
      const DeepCollectionEquality().hash(_categoryScores),
      accuracyPercentage,
      const DeepCollectionEquality().hash(_incorrectQuestionIds));

  @override
  String toString() {
    return 'TestResult(totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, determinedLevel: $determinedLevel, categoryScores: $categoryScores, accuracyPercentage: $accuracyPercentage, incorrectQuestionIds: $incorrectQuestionIds)';
  }
}

/// @nodoc
abstract mixin class _$TestResultCopyWith<$Res>
    implements $TestResultCopyWith<$Res> {
  factory _$TestResultCopyWith(
          _TestResult value, $Res Function(_TestResult) _then) =
      __$TestResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalQuestions,
      int correctAnswers,
      int determinedLevel,
      Map<String, int> categoryScores,
      double accuracyPercentage,
      List<int> incorrectQuestionIds});
}

/// @nodoc
class __$TestResultCopyWithImpl<$Res> implements _$TestResultCopyWith<$Res> {
  __$TestResultCopyWithImpl(this._self, this._then);

  final _TestResult _self;
  final $Res Function(_TestResult) _then;

  /// Create a copy of TestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? determinedLevel = null,
    Object? categoryScores = null,
    Object? accuracyPercentage = null,
    Object? incorrectQuestionIds = null,
  }) {
    return _then(_TestResult(
      totalQuestions: null == totalQuestions
          ? _self.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _self.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      determinedLevel: null == determinedLevel
          ? _self.determinedLevel
          : determinedLevel // ignore: cast_nullable_to_non_nullable
              as int,
      categoryScores: null == categoryScores
          ? _self._categoryScores
          : categoryScores // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      accuracyPercentage: null == accuracyPercentage
          ? _self.accuracyPercentage
          : accuracyPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      incorrectQuestionIds: null == incorrectQuestionIds
          ? _self._incorrectQuestionIds
          : incorrectQuestionIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
mixin _$PlayerAnswer {
  int get questionId;
  int get selectedAnswerIndex;
  bool get isCorrect;
  DateTime get answeredAt;

  /// Create a copy of PlayerAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlayerAnswerCopyWith<PlayerAnswer> get copyWith =>
      _$PlayerAnswerCopyWithImpl<PlayerAnswer>(
          this as PlayerAnswer, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlayerAnswer &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.selectedAnswerIndex, selectedAnswerIndex) ||
                other.selectedAnswerIndex == selectedAnswerIndex) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, questionId, selectedAnswerIndex, isCorrect, answeredAt);

  @override
  String toString() {
    return 'PlayerAnswer(questionId: $questionId, selectedAnswerIndex: $selectedAnswerIndex, isCorrect: $isCorrect, answeredAt: $answeredAt)';
  }
}

/// @nodoc
abstract mixin class $PlayerAnswerCopyWith<$Res> {
  factory $PlayerAnswerCopyWith(
          PlayerAnswer value, $Res Function(PlayerAnswer) _then) =
      _$PlayerAnswerCopyWithImpl;
  @useResult
  $Res call(
      {int questionId,
      int selectedAnswerIndex,
      bool isCorrect,
      DateTime answeredAt});
}

/// @nodoc
class _$PlayerAnswerCopyWithImpl<$Res> implements $PlayerAnswerCopyWith<$Res> {
  _$PlayerAnswerCopyWithImpl(this._self, this._then);

  final PlayerAnswer _self;
  final $Res Function(PlayerAnswer) _then;

  /// Create a copy of PlayerAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedAnswerIndex = null,
    Object? isCorrect = null,
    Object? answeredAt = null,
  }) {
    return _then(_self.copyWith(
      questionId: null == questionId
          ? _self.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int,
      selectedAnswerIndex: null == selectedAnswerIndex
          ? _self.selectedAnswerIndex
          : selectedAnswerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isCorrect: null == isCorrect
          ? _self.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      answeredAt: null == answeredAt
          ? _self.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _PlayerAnswer implements PlayerAnswer {
  const _PlayerAnswer(
      {required this.questionId,
      required this.selectedAnswerIndex,
      required this.isCorrect,
      required this.answeredAt});

  @override
  final int questionId;
  @override
  final int selectedAnswerIndex;
  @override
  final bool isCorrect;
  @override
  final DateTime answeredAt;

  /// Create a copy of PlayerAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlayerAnswerCopyWith<_PlayerAnswer> get copyWith =>
      __$PlayerAnswerCopyWithImpl<_PlayerAnswer>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlayerAnswer &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.selectedAnswerIndex, selectedAnswerIndex) ||
                other.selectedAnswerIndex == selectedAnswerIndex) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, questionId, selectedAnswerIndex, isCorrect, answeredAt);

  @override
  String toString() {
    return 'PlayerAnswer(questionId: $questionId, selectedAnswerIndex: $selectedAnswerIndex, isCorrect: $isCorrect, answeredAt: $answeredAt)';
  }
}

/// @nodoc
abstract mixin class _$PlayerAnswerCopyWith<$Res>
    implements $PlayerAnswerCopyWith<$Res> {
  factory _$PlayerAnswerCopyWith(
          _PlayerAnswer value, $Res Function(_PlayerAnswer) _then) =
      __$PlayerAnswerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int questionId,
      int selectedAnswerIndex,
      bool isCorrect,
      DateTime answeredAt});
}

/// @nodoc
class __$PlayerAnswerCopyWithImpl<$Res>
    implements _$PlayerAnswerCopyWith<$Res> {
  __$PlayerAnswerCopyWithImpl(this._self, this._then);

  final _PlayerAnswer _self;
  final $Res Function(_PlayerAnswer) _then;

  /// Create a copy of PlayerAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? questionId = null,
    Object? selectedAnswerIndex = null,
    Object? isCorrect = null,
    Object? answeredAt = null,
  }) {
    return _then(_PlayerAnswer(
      questionId: null == questionId
          ? _self.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as int,
      selectedAnswerIndex: null == selectedAnswerIndex
          ? _self.selectedAnswerIndex
          : selectedAnswerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isCorrect: null == isCorrect
          ? _self.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      answeredAt: null == answeredAt
          ? _self.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
