import 'package:flutter/material.dart';

import '../../../back_end/utils.dart';
import '../../../main.dart';
import 'answer_field.dart';
import 'question_shell.dart';

class RFRQ_Widget extends StatefulWidget {
  const RFRQ_Widget({Key? key}) : super(key: key);

  @override
  State<RFRQ_Widget> createState() => _RFRQ_WidgetState();
}

class _RFRQ_WidgetState extends State<RFRQ_Widget> {
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false;
  bool _correct = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final bool isCorrect = currentQ.isCorrect(_controller) as bool;
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
      canSubmit: _controller.text.trim().isNotEmpty,
      incompleteLabel: 'Enter an answer',
      onSubmit: _submit,
      onNext: () => advanceAfterAnswer(context),
      answerArea: AnswerField(
        label: 'NUMERIC ANSWER',
        controller: _controller,
        hintText: '0.000',
        large: true,
        enabled: !_submitted,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        helperText: 'Use at least 3 decimal places if the answer is not exact.',
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
