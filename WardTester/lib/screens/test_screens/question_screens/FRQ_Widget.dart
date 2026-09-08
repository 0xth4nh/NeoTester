import 'package:flutter/material.dart';

import '../../../back_end/utils.dart';
import '../../../main.dart';
import '../../../theme/app_typography.dart';
import 'answer_field.dart';
import 'question_shell.dart';

class FRQ_Widget extends StatefulWidget {
  const FRQ_Widget({Key? key}) : super(key: key);

  @override
  State<FRQ_Widget> createState() => _FRQ_WidgetState();
}

class _FRQ_WidgetState extends State<FRQ_Widget> {
  late final List<TextEditingController> _controllers;
  bool _submitted = false;
  bool _correct = false;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      (currentQ.getAnswer() as List<dynamic>).length,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _allFilled =>
      _controllers.every((TextEditingController c) => c.text.trim().isNotEmpty);

  void _submit() {
    final bool isCorrect = currentQ.isCorrect(_controllers) as bool;
    setState(() {
      _correct = isCorrect;
      _submitted = true;
      submitPressed(isCorrect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return QuestionShell(
      hasSubmitted: _submitted,
      wasCorrect: _correct,
      canSubmit: _allFilled,
      incompleteLabel: _controllers.length > 1
          ? 'Fill in every answer'
          : 'Enter an answer',
      onSubmit: _submit,
      onNext: () => advanceAfterAnswer(context),
      answerArea: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < _controllers.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: AppSpacing.lg - 2),
            AnswerField(
              label: _controllers.length > 1 ? 'ANSWER ${i + 1}' : 'ANSWER',
              controller: _controllers[i],
              hintText: 'Type your answer',
              enabled: !_submitted,
              // Rebuild so the action button enables once every box has text.
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }
}
