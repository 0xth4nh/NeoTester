import 'package:flutter/material.dart';

import '../../back_end/Test.dart';
import '../../main.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/record_card.dart';

/// Tests that have been started but not finished.
class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Test> tests =
        (testProgressList as List<dynamic>?)?.whereType<Test>().toList() ??
            <Test>[];

    if (tests.isEmpty) {
      return const AppEmptyState(
        icon: Icons.play_circle_outline_rounded,
        title: 'Nothing in progress',
        message: 'Start a unit and it will show up here until you finish it.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      itemCount: tests.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm + 2),
      itemBuilder: (BuildContext context, int index) =>
          RecordCard(test: tests[index], completed: false),
    );
  }
}
