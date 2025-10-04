import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/placement_test_data_source.dart';
import '../data/models/test_question_model.dart';
import '../core/services/settings_service.dart';
import '../core/utils/app_logger.dart';

/// State for the placement test
class PlacementTestState {
  final List<TestQuestion> questions;
  final int currentQuestionIndex;
  final Map<int, int> userAnswers; // questionId -> selectedAnswerIndex
  final bool isTestComplete;
  final bool isLoading;
  final TestResult? result;
  final bool showHint;

  const PlacementTestState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.userAnswers = const {},
    this.isTestComplete = false,
    this.isLoading = false,
    this.result,
    this.showHint = false,
  });

  PlacementTestState copyWith({
    List<TestQuestion>? questions,
    int? currentQuestionIndex,
    Map<int, int>? userAnswers,
    bool? isTestComplete,
    bool? isLoading,
    TestResult? result,
    bool? showHint,
  }) {
    return PlacementTestState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      isTestComplete: isTestComplete ?? this.isTestComplete,
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      showHint: showHint ?? this.showHint,
    );
  }

  TestQuestion? get currentQuestion {
    if (currentQuestionIndex < questions.length) {
      return questions[currentQuestionIndex];
    }
    return null;
  }

  int get totalQuestions => questions.length;
  int get answeredQuestions => userAnswers.length;
  double get progress => totalQuestions > 0 ? answeredQuestions / totalQuestions : 0.0;
}

/// Controller for placement test
class PlacementTestController extends StateNotifier<PlacementTestState> {
  final PlacementTestDataSource _dataSource;
  final Ref ref;

  PlacementTestController(this._dataSource, this.ref) : super(const PlacementTestState());

  /// Initialize the test
  Future<void> initializeTest() async {
    state = state.copyWith(isLoading: true);

    try {
      final questions = await _dataSource.getAdaptiveTestQuestions();

      state = state.copyWith(
        questions: questions,
        isLoading: false,
        currentQuestionIndex: 0,
        userAnswers: {},
        isTestComplete: false,
        result: null,
      );

      AppLogger.info('Placement test initialized with ${questions.length} questions');
    } catch (e, stack) {
      AppLogger.error('Failed to initialize placement test', error: e, stackTrace: stack);
      state = state.copyWith(isLoading: false);
    }
  }

  /// Answer the current question
  void answerQuestion(int answerIndex) {
    final currentQuestion = state.currentQuestion;
    if (currentQuestion == null) return;

    final newAnswers = Map<int, int>.from(state.userAnswers);
    newAnswers[currentQuestion.id] = answerIndex;

    state = state.copyWith(
      userAnswers: newAnswers,
      showHint: false,
    );

    AppLogger.info('Question ${currentQuestion.id} answered with index $answerIndex');
  }

  /// Move to next question
  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        showHint: false,
      );
    } else {
      _completeTest();
    }
  }

  /// Move to previous question
  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
        showHint: false,
      );
    }
  }

  /// Toggle hint visibility
  void toggleHint() {
    state = state.copyWith(showHint: !state.showHint);
  }

  /// Complete the test and calculate results
  Future<void> _completeTest() async {
    final result = _calculateResults();

    state = state.copyWith(
      isTestComplete: true,
      result: result,
    );

    // Save the determined level to settings
    await SettingsService.setGameplaySetting('languageLevel', result.determinedLevel);

    AppLogger.info('Placement test completed. Level: ${result.jlptLevel}');
  }

  /// Calculate test results
  TestResult _calculateResults() {
    int correctCount = 0;
    final categoryScores = <String, int>{};
    final incorrectQuestionIds = <int>[];

    // Calculate scores
    for (var question in state.questions) {
      final userAnswer = state.userAnswers[question.id];

      if (userAnswer == question.correctAnswerIndex) {
        correctCount++;

        // Track category scores
        categoryScores[question.category] = (categoryScores[question.category] ?? 0) + 1;
      } else {
        incorrectQuestionIds.add(question.id);
      }
    }

    final totalQuestions = state.questions.length;
    final accuracyPercentage = (correctCount / totalQuestions) * 100;

    // Determine JLPT level based on performance
    final level = _determineLevelFromPerformance(
      correctCount,
      totalQuestions,
      accuracyPercentage,
    );

    return TestResult(
      totalQuestions: totalQuestions,
      correctAnswers: correctCount,
      determinedLevel: level,
      categoryScores: categoryScores,
      accuracyPercentage: accuracyPercentage,
      incorrectQuestionIds: incorrectQuestionIds,
    );
  }

  /// Determine JLPT level from performance
  int _determineLevelFromPerformance(
    int correctCount,
    int totalQuestions,
    double accuracy,
  ) {
    // Calculate weighted score based on question difficulty
    double weightedScore = 0;
    double totalWeight = 0;

    for (var question in state.questions) {
      final userAnswer = state.userAnswers[question.id];
      final isCorrect = userAnswer == question.correctAnswerIndex;

      if (isCorrect) {
        // Weight: N5=1, N4=2, N3=3, N2=4, N1=5
        final weight = 6 - question.jlptLevel;
        weightedScore += weight;
      }

      totalWeight += (6 - question.jlptLevel);
    }

    final weightedAccuracy = (weightedScore / totalWeight) * 100;

    // Determine level based on weighted accuracy
    if (weightedAccuracy >= 80) {
      return 1; // N1 - Advanced
    } else if (weightedAccuracy >= 65) {
      return 2; // N2 - Upper Intermediate
    } else if (weightedAccuracy >= 50) {
      return 3; // N3 - Intermediate
    } else if (weightedAccuracy >= 35) {
      return 4; // N4 - Elementary
    } else {
      return 5; // N5 - Beginner
    }
  }

  /// Retry the test
  Future<void> retryTest() async {
    await initializeTest();
  }

  /// Skip the test and set default level
  Future<void> skipTest() async {
    // Set default to N4 level
    await SettingsService.setGameplaySetting('languageLevel', 5);

    state = state.copyWith(
      isTestComplete: true,
      result: TestResult(
        totalQuestions: 0,
        correctAnswers: 0,
        determinedLevel: 5,
        categoryScores: {},
        accuracyPercentage: 0,
        incorrectQuestionIds: [],
      ),
    );
  }
}

/// Provider for placement test data source
final placementTestDataSourceProvider = Provider<PlacementTestDataSource>((ref) {
  return PlacementTestDataSource();
});

/// Provider for placement test controller
final placementTestProvider = StateNotifierProvider<PlacementTestController, PlacementTestState>((ref) {
  final dataSource = ref.watch(placementTestDataSourceProvider);
  return PlacementTestController(dataSource, ref);
});
