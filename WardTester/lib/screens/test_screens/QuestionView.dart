import 'package:flutter/material.dart';

import '../../main.dart';
import 'question_screens/FRQ_Widget.dart';
import 'question_screens/MCQ_Widget.dart';
import 'question_screens/RFRQ_Widget.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Keyed by question type so switching between questions of different types
    // rebuilds the answer state instead of reusing the previous one.
    switch (currentQ.getType() as int) {
      case 0:
        return const MCQ_Widget(key: ValueKey<String>('mcq'));
      case 1:
        return const FRQ_Widget(key: ValueKey<String>('frq'));
      default:
        return const RFRQ_Widget(key: ValueKey<String>('rfrq'));
    }
  }
}
