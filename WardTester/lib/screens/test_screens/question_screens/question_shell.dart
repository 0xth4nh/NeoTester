import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../back_end/utils.dart';
import '../../../main.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_widgets.dart';
import '../../HomePage.dart';
import '../QuestionPage.dart';

/// The layout shared by every question type: progress header, optional image,
/// the prompt, the type-specific answer area, feedback, and the action button.
///
/// The three question widgets each duplicated this before, which is why the
/// prompt had no horizontal padding on any of them — it was clipped at the
/// left edge of the device.
class QuestionShell extends StatelessWidget {
  const QuestionShell({
    super.key,
    required this.answerArea,
    required this.hasSubmitted,
    required this.wasCorrect,
    required this.canSubmit,
    required this.incompleteLabel,
    required this.onSubmit,
    required this.onNext,
  });

  /// The type-specific input.
  final Widget answerArea;

  final bool hasSubmitted;

  /// Only meaningful once [hasSubmitted] is true.
  final bool wasCorrect;

  /// False while the answer is still blank; the action button stays disabled.
  final bool canSubmit;

  /// Button label while [canSubmit] is false, e.g. "Select an answer".
  final String incompleteLabel;

  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final int total = currentTest.getNumQuestion() as int;
    final Queue<int> order = questionOrder;
    int answered = (total - order.length).clamp(0, total);

    // submitPressed() pops the queue the moment an answer is accepted, so a
    // correct answer would otherwise advance this counter while the student is
    // still looking at the question they just answered. Hold it back until
    // "Next question" actually moves on. A wrong answer rotates the queue
    // instead of shortening it, so it needs no adjustment.
    if (hasSubmitted && wasCorrect && answered > 0) answered -= 1;

    final int index = (answered + 1).clamp(1, total == 0 ? 1 : total);

    final String imagePath = currentQ.getImagePath() as String;

    return Column(
      children: <Widget>[
        AppQuestionProgressHeader(index: index, total: total),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (imagePath.isNotEmpty) ...<Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.choice),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Text(
                  currentQ.getQuestion() as String,
                  style: AppText.question,
                ),
                const SizedBox(height: 18),
                answerArea,
                if (hasSubmitted) ...<Widget>[
                  const SizedBox(height: 18),
                  AppFeedbackBanner(
                    correct: wasCorrect,
                    message: wasCorrect ? '' : resultDisplay.toString(),
                  ),
                ],
              ],
            ),
          ),
        ),
        _ActionBar(
          hasSubmitted: hasSubmitted,
          canSubmit: canSubmit,
          incompleteLabel: incompleteLabel,
          onSubmit: onSubmit,
          onNext: onNext,
        ),
      ],
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.hasSubmitted,
    required this.canSubmit,
    required this.incompleteLabel,
    required this.onSubmit,
    required this.onNext,
  });

  final bool hasSubmitted;
  final bool canSubmit;
  final String incompleteLabel;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final String label = hasSubmitted
        ? 'Next question'
        : (canSubmit ? 'Submit' : incompleteLabel);
    final VoidCallback? action = hasSubmitted
        ? onNext
        : (canSubmit ? onSubmit : null);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.md,
            AppSpacing.gutter,
            AppSpacing.lg,
          ),
          child: ElevatedButton(onPressed: action, child: Text(label)),
        ),
      ),
    );
  }
}

/// Advances to the next question, or leaves the unit when it is finished.
///
/// Uses pushReplacement so finishing a run of questions does not leave a stack
/// of dead QuestionPages behind the one on screen.
void advanceAfterAnswer(BuildContext context) {
  if (nextPressedIsMoreQuestions()) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const QuestionPage()),
    );
  } else {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
