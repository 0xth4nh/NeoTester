import 'package:flutter/material.dart';

import '../../../back_end/utils.dart';
import '../../../main.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_widgets.dart';
import 'question_shell.dart';

class MCQ_Widget extends StatefulWidget {
  const MCQ_Widget({Key? key}) : super(key: key);

  @override
  State<MCQ_Widget> createState() => _MCQ_WidgetState();
}

class _MCQ_WidgetState extends State<MCQ_Widget> {
  static const String _letters = 'ABCDEFGHIJ';

  int? _picked;
  bool _submitted = false;
  bool _correct = false;

  void _submit() {
    final int? picked = _picked;
    if (picked == null) return;
    final bool isCorrect = currentQ.isCorrect(picked) as bool;
    setState(() {
      _correct = isCorrect;
      _submitted = true;
      submitPressed(isCorrect);
    });
  }

  /// How the tile at [index] should render given the current state.
  ChoiceState _stateFor(int index) {
    if (!_submitted) {
      return _picked == index ? ChoiceState.selected : ChoiceState.idle;
    }
    if (_correct) {
      return _picked == index ? ChoiceState.correct : ChoiceState.idle;
    }
    // Wrong answer: mark only what the student picked. The backend does not
    // expose the correct index, so nothing else can be highlighted here.
    return _picked == index ? ChoiceState.incorrect : ChoiceState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> choices = currentQ.getChoices() as List<dynamic>;

    return QuestionShell(
      hasSubmitted: _submitted,
      wasCorrect: _correct,
      canSubmit: _picked != null,
      incompleteLabel: 'Select an answer',
      onSubmit: _submit,
      onNext: () => advanceAfterAnswer(context),
      answerArea: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < choices.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: AppSpacing.sm + 2),
            AppChoiceTile(
              letter: i < _letters.length ? _letters[i] : '${i + 1}',
              text: choices[i].toString(),
              state: _stateFor(i),
              onTap: _submitted ? null : () => setState(() => _picked = i),
            ),
          ],
        ],
      ),
    );
  }
}
