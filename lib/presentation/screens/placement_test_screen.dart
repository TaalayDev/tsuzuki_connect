import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/custom_colors.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/extensions.dart';
import '../../providers/placement_test_provider.dart';
import '../../providers/sound_controller.dart';
import '../../data/models/test_question_model.dart';

class PlacementTestScreen extends ConsumerStatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  ConsumerState<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends ConsumerState<PlacementTestScreen> with SingleTickerProviderStateMixin {
  late AnimationController _teacherAnimController;
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();

    _teacherAnimController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showWelcome = false);
        ref.read(placementTestProvider.notifier).initializeTest();
      }
    });
  }

  @override
  void dispose() {
    _teacherAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(placementTestProvider);
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 900;

    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/classroom.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, testState, isSmallScreen),
                Expanded(
                  child: _showWelcome
                      ? _buildWelcomeScreen(context, customColors, isSmallScreen)
                      : testState.isTestComplete
                          ? _buildResultsScreen(context, testState, customColors, isSmallScreen)
                          : _buildTestContent(context, testState, customColors, isSmallScreen),
                ),
              ],
            ),
          ),

          // Teacher character (responsive positioning)
          if (!isSmallScreen) _buildTeacherCharacter(context, isMediumScreen),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PlacementTestState testState, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.theme.colorScheme.surface.withOpacity(0.95),
            context.theme.colorScheme.surface.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              ref.read(soundControllerProvider.notifier).playClick();
              _showExitConfirmation(context);
            },
            icon: const Icon(Icons.close),
            iconSize: isSmallScreen ? 20 : 24,
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Placement Test',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 16 : 20,
                  ),
                ),
                if (!_showWelcome && !testState.isTestComplete)
                  Text(
                    'Question ${testState.currentQuestionIndex + 1} of ${testState.totalQuestions}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                      fontSize: isSmallScreen ? 11 : 13,
                    ),
                  ),
              ],
            ),
          ),
          if (!_showWelcome && !testState.isTestComplete)
            SizedBox(
              width: isSmallScreen ? 32 : 40,
              height: isSmallScreen ? 32 : 40,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: testState.progress,
                    backgroundColor: context.theme.colorScheme.surfaceVariant,
                    strokeWidth: isSmallScreen ? 3 : 4,
                  ),
                  Center(
                    child: Text(
                      '${(testState.progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 8 : 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context, CustomColors customColors, bool isSmallScreen) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple.shade400,
                          Colors.deepPurple.shade600,
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school,
                      size: isSmallScreen ? 48 : 64,
                      color: Colors.white,
                    ),
                  ).animate().scale(
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      ),
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  Text(
                    'ようこそï¼',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 24 : 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to the Placement Test',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  Text(
                    'I\'m Tanaka-sensei, and I\'ll help determine your Japanese language level. This test will take about 5-10 minutes.',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isSmallScreen ? 28 : 32),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Preparing your test...',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTestContent(
    BuildContext context,
    PlacementTestState testState,
    CustomColors customColors,
    bool isSmallScreen,
  ) {
    final question = testState.currentQuestion;

    if (testState.isLoading || question == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasAnswered = testState.userAnswers.containsKey(question.id);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Teacher's dialogue
              _buildTeacherDialogue(context, question, customColors, isSmallScreen),

              SizedBox(height: isSmallScreen ? 16 : 24),

              // Question card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge and hint
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 10 : 12,
                              vertical: isSmallScreen ? 4 : 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getCategoryColor(question.category),
                                  _getCategoryColor(question.category).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _getCategoryColor(question.category).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              question.category.toUpperCase(),
                              style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 10 : 11,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (question.hint != null)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  ref.read(soundControllerProvider.notifier).playClick();
                                  ref.read(placementTestProvider.notifier).toggleHint();
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: testState.showHint ? Colors.amber.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    testState.showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                                    color: Colors.amber.shade700,
                                    size: isSmallScreen ? 20 : 24,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // Question text
                      Text(
                        question.questionJp,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 18 : 22,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        question.questionEn,
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),

                      // Hint
                      if (testState.showHint && question.hint != null)
                        Container(
                          margin: EdgeInsets.only(top: isSmallScreen ? 14 : 16),
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade50,
                                Colors.amber.shade100.withOpacity(0.5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Colors.amber.shade700,
                                size: isSmallScreen ? 18 : 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.hint!,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.amber.shade900,
                                    fontSize: isSmallScreen ? 13 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1, end: 0),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

              SizedBox(height: isSmallScreen ? 14 : 16),

              // Answer options
              ...List.generate(
                question.answers.length,
                (index) => Padding(
                  padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                  child: _buildAnswerOption(
                    context,
                    question,
                    index,
                    testState,
                    customColors,
                    isSmallScreen,
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 20 : 24),

              // Navigation buttons
              _buildNavigationButtons(context, testState, hasAnswered, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherDialogue(
    BuildContext context,
    TestQuestion question,
    CustomColors customColors,
    bool isSmallScreen,
  ) {
    String dialogueText;

    switch (question.jlptLevel) {
      case 5:
        dialogueText = "Let's start with the basics! Take your time.";
        break;
      case 4:
        dialogueText = "Good! Now let's try something a bit more challenging.";
        break;
      case 3:
        dialogueText = "Excellent progress! This one requires some thought.";
        break;
      case 2:
        dialogueText = "Impressive! Let's see how you handle this.";
        break;
      default:
        dialogueText = "Outstanding! Here's an advanced question.";
    }

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            customColors.dialogBox,
            customColors.dialogBox.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: customColors.dialogBoxBorder.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  customColors.nameTag,
                  customColors.nameTag.withOpacity(0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: customColors.nameTag.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanaka-sensei',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: customColors.nameTag,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dialogueText,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: customColors.dialogBoxText,
                    fontSize: isSmallScreen ? 13 : 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildAnswerOption(
    BuildContext context,
    TestQuestion question,
    int index,
    PlacementTestState testState,
    CustomColors customColors,
    bool isSmallScreen,
  ) {
    final answer = question.answers[index];
    final isSelected = testState.userAnswers[question.id] == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(soundControllerProvider.notifier).playClick();
          ref.read(placementTestProvider.notifier).answerQuestion(index);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      customColors.choiceButtonHover,
                      customColors.choiceButtonHover.withOpacity(0.9),
                    ],
                  )
                : null,
            color: isSelected ? null : customColors.choiceButton,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? customColors.choiceButtonBorder : customColors.choiceButtonBorder.withOpacity(0.3),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? customColors.choiceButtonBorder.withOpacity(0.2) : Colors.black.withOpacity(0.08),
                blurRadius: isSelected ? 12 : 6,
                offset: Offset(0, isSelected ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isSmallScreen ? 36 : 40,
                height: isSmallScreen ? 36 : 40,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            customColors.choiceButtonBorder,
                            customColors.choiceButtonBorder.withOpacity(0.8),
                          ],
                        )
                      : null,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: customColors.choiceButtonBorder,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : customColors.choiceButtonBorder,
                      fontSize: isSmallScreen ? 16 : 18,
                    ),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer.textJp,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 15 : 17,
                      ),
                    ),
                    if (answer.furigana != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          answer.furigana!,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: isSmallScreen ? 10 : 11,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      answer.textEn,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.onSurface.withOpacity(0.8),
                        fontSize: isSmallScreen ? 13 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: customColors.choiceButtonBorder,
                  size: isSmallScreen ? 20 : 24,
                ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 80 * index),
          duration: 300.ms,
        )
        .slideX(
          begin: 0.1,
          end: 0,
          delay: Duration(milliseconds: 80 * index),
          duration: 300.ms,
        );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    PlacementTestState testState,
    bool hasAnswered,
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        if (testState.currentQuestionIndex > 0)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(soundControllerProvider.notifier).playClick();
                ref.read(placementTestProvider.notifier).previousQuestion();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.arrow_back, size: isSmallScreen ? 18 : 20),
              label: Text(
                'Previous',
                style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
              ),
            ),
          ),
        if (testState.currentQuestionIndex > 0) SizedBox(width: isSmallScreen ? 10 : 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasAnswered
                ? () {
                    ref.read(soundControllerProvider.notifier).playClick();
                    ref.read(placementTestProvider.notifier).nextQuestion();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(
              testState.currentQuestionIndex < testState.totalQuestions - 1 ? Icons.arrow_forward : Icons.check,
              size: isSmallScreen ? 18 : 20,
            ),
            label: Text(
              testState.currentQuestionIndex < testState.totalQuestions - 1 ? 'Next' : 'Finish',
              style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen(
    BuildContext context,
    PlacementTestState testState,
    CustomColors customColors,
    bool isSmallScreen,
  ) {
    final result = testState.result!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // Congratulations message
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.theme.colorScheme.primary,
                              context.theme.colorScheme.primary.withOpacity(0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.celebration,
                          size: isSmallScreen ? 48 : 64,
                          color: Colors.white,
                        ),
                      ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
                      SizedBox(height: isSmallScreen ? 20 : 24),
                      Text(
                        'Test Complete!',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 24 : 28,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 14 : 16),
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              customColors.dialogBox,
                              customColors.dialogBox.withOpacity(0.95),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: customColors.dialogBoxBorder.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Tanaka-sensei says:',
                              style: context.textTheme.titleSmall?.copyWith(
                                color: customColors.nameTagText,
                                fontSize: isSmallScreen ? 13 : 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '"Excellent work! Based on your performance, I\'ve determined your Japanese level."',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: customColors.dialogBoxText,
                                fontSize: isSmallScreen ? 14 : 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms),

              SizedBox(height: isSmallScreen ? 18 : 24),

              // Results card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                  child: Column(
                    children: [
                      // Level badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 28 : 32,
                          vertical: isSmallScreen ? 14 : 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getLevelColor(result.determinedLevel),
                              _getLevelColor(result.determinedLevel).withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _getLevelColor(result.determinedLevel).withOpacity(0.3),
                              blurRadius: 16,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your Level',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 14 : 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'JLPT ${result.jlptLevel}',
                              style: context.textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 32 : 40,
                              ),
                            ),
                          ],
                        ),
                      ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),

                      SizedBox(height: isSmallScreen ? 20 : 24),

                      Text(
                        result.levelDescription,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontSize: isSmallScreen ? 15 : 17,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),

                      // Statistics
                      _buildStatRow(
                        context,
                        'Questions Answered',
                        '${result.correctAnswers}/${result.totalQuestions}',
                        isSmallScreen,
                      ),
                      _buildStatRow(
                        context,
                        'Accuracy',
                        '${result.accuracyPercentage.toStringAsFixed(1)}%',
                        isSmallScreen,
                      ),

                      SizedBox(height: isSmallScreen ? 20 : 24),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ref.read(soundControllerProvider.notifier).playClick();
                                ref.read(placementTestProvider.notifier).retryTest();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 14 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(Icons.refresh, size: isSmallScreen ? 18 : 20),
                              label: Text(
                                'Retake',
                                style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ref.read(soundControllerProvider.notifier).playClick();
                                context.go(AppConstants.routeHome);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 14 : 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(Icons.check, size: isSmallScreen ? 18 : 20),
                              label: Text(
                                'Continue',
                                style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyLarge?.copyWith(
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.theme.colorScheme.primary,
              fontSize: isSmallScreen ? 15 : 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCharacter(BuildContext context, bool isMediumScreen) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _teacherAnimController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _teacherAnimController.value * 10),
            child: child,
          );
        },
        child: Image.asset(
          'assets/images/characters/tanaka/avatar.webp',
          height: MediaQuery.of(context).size.height * (isMediumScreen ? 0.3 : 0.35),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                size: 80,
                color: Colors.white54,
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'vocabulary':
        return Colors.blue.shade700;
      case 'grammar':
        return Colors.purple.shade700;
      case 'reading':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.red.shade700;
      case 2:
        return Colors.orange.shade700;
      case 3:
        return Colors.amber.shade700;
      case 4:
        return Colors.green.shade700;
      case 5:
      default:
        return Colors.blue.shade700;
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Exit Test?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppConstants.routeHome);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
