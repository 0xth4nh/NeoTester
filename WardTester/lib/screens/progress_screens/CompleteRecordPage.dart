import 'package:flutter/material.dart';

import '../../back_end/Test.dart';
import '../../main.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_widgets.dart';
import '../../widgets/record_card.dart';

/// Tests that have been finished.
class CompleteRecordPage extends StatelessWidget {
  const CompleteRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Test> tests =
        (completeTestList as List<dynamic>?)?.whereType<Test>().toList() ??
            <Test>[];

    if (tests.isEmpty) {
      return const AppEmptyState(
        icon: Icons.task_alt_rounded,
        title: 'No completed units yet',
        message:
            'Finish every question in a unit and it will be recorded here.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      itemCount: tests.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm + 2),
      itemBuilder: (BuildContext context, int index) =>
          RecordCard(test: tests[index], completed: true),
    );
  }
}
