import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_question_model.freezed.dart';
part 'test_question_model.g.dart';

/// Model for a test question
@freezed
abstract class TestQuestion with _$TestQuestion {
  const factory TestQuestion({
    required int id,
    required String questionJp,
    required String questionEn,
    required TestQuestionType type,
    required List<TestAnswer> answers,
    required int correctAnswerIndex,
    required int jlptLevel, // 5 = N5 (easiest), 1 = N1 (hardest)
    required String category, // vocabulary, grammar, reading, etc.
    String? hint,
    String? explanation,
  }) = _TestQuestion;

  factory TestQuestion.fromJson(Map<String, dynamic> json) => _$TestQuestionFromJson(json);
}

/// Answer option for a test question
@freezed
abstract class TestAnswer with _$TestAnswer {
  const factory TestAnswer({
    required String textJp,
    required String textEn,
    String? furigana,
  }) = _TestAnswer;

  factory TestAnswer.fromJson(Map<String, dynamic> json) => _$TestAnswerFromJson(json);
}

/// Type of test question
enum TestQuestionType {
  multipleChoice,
  fillInBlank,
  readingComprehension,
}

/// Result of the placement test
@freezed
abstract class TestResult with _$TestResult {
  const factory TestResult({
    required int totalQuestions,
    required int correctAnswers,
    required int determinedLevel, // 1-5 (N1-N5)
    required Map<String, int> categoryScores,
    required double accuracyPercentage,
    required List<int> incorrectQuestionIds,
  }) = _TestResult;

  const TestResult._();

  String get jlptLevel {
    switch (determinedLevel) {
      case 1:
        return 'N1';
      case 2:
        return 'N2';
      case 3:
        return 'N3';
      case 4:
        return 'N4';
      case 5:
      default:
        return 'N5';
    }
  }

  String get levelDescription {
    switch (determinedLevel) {
      case 1:
        return 'Advanced - You have mastered complex Japanese!';
      case 2:
        return 'Upper Intermediate - You can handle most daily situations!';
      case 3:
        return 'Intermediate - You have a solid foundation!';
      case 4:
        return 'Elementary - You know the basics!';
      case 5:
      default:
        return 'Beginner - Let\'s start your journey!';
    }
  }
}

/// Player's answer to a question
@freezed
abstract class PlayerAnswer with _$PlayerAnswer {
  const factory PlayerAnswer({
    required int questionId,
    required int selectedAnswerIndex,
    required bool isCorrect,
    required DateTime answeredAt,
  }) = _PlayerAnswer;
}
