import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/test_question_model.dart';
import '../../core/utils/app_logger.dart';

/// Data source for placement test questions
class PlacementTestDataSource {
  static const String _assetPath = 'assets/data/placement_test.json';

  List<TestQuestion>? _cachedQuestions;

  /// Get all test questions
  Future<List<TestQuestion>> getAllQuestions() async {
    if (_cachedQuestions != null) {
      return _cachedQuestions!;
    }

    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      print('$jsonString');
      final jsonList = json.decode(jsonString) as List<dynamic>;

      _cachedQuestions = jsonList.map((item) => TestQuestion.fromJson(item as Map<String, dynamic>)).toList();

      return _cachedQuestions!;
    } catch (e, stack) {
      AppLogger.error('Failed to load placement test questions', error: e, stackTrace: stack);

      // Return default questions if loading fails
      return _getDefaultQuestions();
    }
  }

  /// Get questions for adaptive test (starts at middle difficulty)
  Future<List<TestQuestion>> getAdaptiveTestQuestions() async {
    final allQuestions = await getAllQuestions();

    // Group questions by level
    final questionsByLevel = <int, List<TestQuestion>>{};
    for (var question in allQuestions) {
      questionsByLevel.putIfAbsent(question.jlptLevel, () => []).add(question);
    }

    // Select questions adaptively (mix of levels)
    final selectedQuestions = <TestQuestion>[];

    // Start with N4 level (2 questions)
    if (questionsByLevel[4]?.isNotEmpty ?? false) {
      selectedQuestions.addAll(questionsByLevel[4]!.take(2));
    }

    // Add N3 level (3 questions)
    if (questionsByLevel[3]?.isNotEmpty ?? false) {
      selectedQuestions.addAll(questionsByLevel[3]!.take(3));
    }

    // Add N5 level (2 questions)
    if (questionsByLevel[5]?.isNotEmpty ?? false) {
      selectedQuestions.addAll(questionsByLevel[5]!.take(2));
    }

    // Add N2 level (2 questions)
    if (questionsByLevel[2]?.isNotEmpty ?? false) {
      selectedQuestions.addAll(questionsByLevel[2]!.take(2));
    }

    // Add N1 level (1 question)
    if (questionsByLevel[1]?.isNotEmpty ?? false) {
      selectedQuestions.addAll(questionsByLevel[1]!.take(1));
    }

    return selectedQuestions;
  }

  /// Default questions if file loading fails
  List<TestQuestion> _getDefaultQuestions() {
    return [
      // N5 - Beginner
      TestQuestion(
        id: 1,
        questionJp: '___は学生です。',
        questionEn: 'I ___ a student.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'わたし', textEn: 'watashi (I)', furigana: 'わたし'),
          TestAnswer(textJp: 'あなた', textEn: 'anata (you)', furigana: 'あなた'),
          TestAnswer(textJp: 'かれ', textEn: 'kare (he)', furigana: 'かれ'),
          TestAnswer(textJp: 'かのじょ', textEn: 'kanojo (she)', furigana: 'かのじょ'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 5,
        category: 'vocabulary',
        hint: 'Think about the first person pronoun',
        explanation: 'わたし (watashi) means "I" in Japanese.',
      ),

      TestQuestion(
        id: 2,
        questionJp: 'これ___ペンです。',
        questionEn: 'This ___ a pen.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'は', textEn: 'wa (topic marker)', furigana: 'は'),
          TestAnswer(textJp: 'が', textEn: 'ga (subject marker)', furigana: 'が'),
          TestAnswer(textJp: 'を', textEn: 'wo (object marker)', furigana: 'を'),
          TestAnswer(textJp: 'に', textEn: 'ni (location/time)', furigana: 'に'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 5,
        category: 'grammar',
        explanation: 'は (wa) is the topic marker particle.',
      ),

      // N4 - Elementary
      TestQuestion(
        id: 3,
        questionJp: '昨日、映画___見ました。',
        questionEn: 'Yesterday, I watched a movie.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'を', textEn: 'wo', furigana: 'を'),
          TestAnswer(textJp: 'に', textEn: 'ni', furigana: 'に'),
          TestAnswer(textJp: 'で', textEn: 'de', furigana: 'で'),
          TestAnswer(textJp: 'と', textEn: 'to', furigana: 'と'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 4,
        category: 'grammar',
        explanation: 'を marks the direct object of an action.',
      ),

      TestQuestion(
        id: 4,
        questionJp: '日本語が___なりました。',
        questionEn: 'I became able to speak Japanese.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: '話せるよう', textEn: 'hanaseru you', furigana: 'はなせるよう'),
          TestAnswer(textJp: '話すよう', textEn: 'hanasu you', furigana: 'はなすよう'),
          TestAnswer(textJp: '話したよう', textEn: 'hanashita you', furigana: 'はなしたよう'),
          TestAnswer(textJp: '話してよう', textEn: 'hanashite you', furigana: 'はなしてよう'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 4,
        category: 'grammar',
        explanation: '～ようになる expresses acquiring an ability.',
      ),

      // N3 - Intermediate
      TestQuestion(
        id: 5,
        questionJp: '雨が降り___、試合は中止になった。',
        questionEn: 'Because it rained, the match was cancelled.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'そうで', textEn: 'sou de', furigana: 'そうで'),
          TestAnswer(textJp: 'ながら', textEn: 'nagara', furigana: 'ながら'),
          TestAnswer(textJp: 'そうなので', textEn: 'sou na node', furigana: 'そうなので'),
          TestAnswer(textJp: 'そうだったので', textEn: 'sou datta node', furigana: 'そうだったので'),
        ],
        correctAnswerIndex: 3,
        jlptLevel: 3,
        category: 'grammar',
        explanation: '～そうだったので indicates past hearsay with reason.',
      ),

      TestQuestion(
        id: 6,
        questionJp: '彼は忙しい___、毎日運動している。',
        questionEn: 'Despite being busy, he exercises every day.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'のに', textEn: 'noni', furigana: 'のに'),
          TestAnswer(textJp: 'ので', textEn: 'node', furigana: 'ので'),
          TestAnswer(textJp: 'から', textEn: 'kara', furigana: 'から'),
          TestAnswer(textJp: 'けど', textEn: 'kedo', furigana: 'けど'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 3,
        category: 'grammar',
        explanation: 'のに expresses contrast or unexpectedness.',
      ),

      // N2 - Upper Intermediate
      TestQuestion(
        id: 7,
        questionJp: 'この仕事は簡単___、意外と時間がかかる。',
        questionEn: 'This work seems simple, but unexpectedly takes time.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'そうで', textEn: 'sou de', furigana: 'そうで'),
          TestAnswer(textJp: 'そうに', textEn: 'sou ni', furigana: 'そうに'),
          TestAnswer(textJp: 'そうだが', textEn: 'sou da ga', furigana: 'そうだが'),
          TestAnswer(textJp: 'ように', textEn: 'you ni', furigana: 'ように'),
        ],
        correctAnswerIndex: 2,
        jlptLevel: 2,
        category: 'grammar',
        explanation: '～そうだが expresses appearance/seeming with contrast.',
      ),

      TestQuestion(
        id: 8,
        questionJp: '彼女は優秀___、誰からも信頼されている。',
        questionEn: 'She is excellent, and is trusted by everyone.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'なうえに', textEn: 'na ue ni', furigana: 'なうえに'),
          TestAnswer(textJp: 'であり', textEn: 'de ari', furigana: 'であり'),
          TestAnswer(textJp: 'なので', textEn: 'na node', furigana: 'なので'),
          TestAnswer(textJp: 'だから', textEn: 'da kara', furigana: 'だから'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 2,
        category: 'grammar',
        explanation: '～うえに adds additional positive/negative information.',
      ),

      // N1 - Advanced
      TestQuestion(
        id: 9,
        questionJp: '彼は努力を___、ついに目標を達成した。',
        questionEn: 'Having made continuous efforts, he finally achieved his goal.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: '重ねるにつれて', textEn: 'kasaneru ni tsurete', furigana: 'かさねるにつれて'),
          TestAnswer(textJp: '重ねた末に', textEn: 'kasaneta sue ni', furigana: 'かさねたすえに'),
          TestAnswer(textJp: '重ねるばかりで', textEn: 'kasaneru bakari de', furigana: 'かさねるばかりで'),
          TestAnswer(textJp: '重ねようとして', textEn: 'kasaneyou to shite', furigana: 'かさねようとして'),
        ],
        correctAnswerIndex: 1,
        jlptLevel: 1,
        category: 'grammar',
        explanation: '～た末に means "after doing... finally".',
      ),

      TestQuestion(
        id: 10,
        questionJp: '環境問題は解決___、悪化の一途をたどっている。',
        questionEn: 'Far from being solved, environmental problems continue to worsen.',
        type: TestQuestionType.multipleChoice,
        answers: [
          TestAnswer(textJp: 'するどころか', textEn: 'suru dokoro ka', furigana: 'するどころか'),
          TestAnswer(textJp: 'したにもかかわらず', textEn: 'shita ni mo kakawarazu', furigana: 'したにもかかわらず'),
          TestAnswer(textJp: 'するわけがなく', textEn: 'suru wake ga naku', furigana: 'するわけがなく'),
          TestAnswer(textJp: 'するものの', textEn: 'suru mono no', furigana: 'するものの'),
        ],
        correctAnswerIndex: 0,
        jlptLevel: 1,
        category: 'grammar',
        explanation: 'どころか emphasizes the opposite of expectation.',
      ),
    ];
  }
}
