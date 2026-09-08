import 'package:flutter/material.dart';

import '../back_end/Test.dart';
import '../back_end/utils.dart';
import '../main.dart';
import '../theme/app_typography.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_widgets.dart';
import 'test_screens/QuestionPage.dart';

class SelectUnitPage extends StatefulWidget {
  final dynamic unitList;
  final dynamic course;
  const SelectUnitPage({Key? key, this.unitList, this.course})
      : super(key: key);

  @override
  _SelectUnitPageState createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  /// Unit names look like "01 - Organizing Data": the leading token becomes the
  /// badge and the remainder the title. Names without one keep their full text.
  static final RegExp _leadingNumber = RegExp(r'^\s*(\d+)\s*-\s*(.+)$');

  /// The saved progress for [unit] in this course, or null if not started.
  Test? _progressFor(String unit) {
    final List<dynamic>? saved = testProgressList as List<dynamic>?;
    if (saved == null) return null;
    final String name = '${widget.course}:$unit';
    for (final dynamic test in saved) {
      if (test is Test && test.getName() == name) return test;
    }
    return null;
  }

  Future<void> _openUnit(String unit) async {
    await startTest(widget.course as String, unit);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const QuestionPage()),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> units =
        (widget.unitList as Iterable<dynamic>?)?.cast<String>().toList() ??
            <String>[];

    return Scaffold(
      appBar: AppTopBar(
        title: 'Select unit',
        subtitle: widget.course?.toString(),
      ),
      body: SafeArea(
        child: units.isEmpty
            ? const AppEmptyState(
                icon: Icons.inbox_outlined,
                title: 'No units in this course',
                message: 'This course has no downloaded units yet.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                itemCount: units.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm + 2),
                itemBuilder: (BuildContext context, int index) {
                  final String unit = units[index];
                  final RegExpMatch? match = _leadingNumber.firstMatch(unit);
                  final String badge =
                      match?.group(1) ?? '${index + 1}'.padLeft(2, '0');
                  final String title = match?.group(2) ?? unit;

                  final Test? progress = _progressFor(unit);
                  final int total = progress?.getNumQuestion() ?? 0;
                  final int done = progress?.getTotalCorrect() ?? 0;
                  final bool started = progress != null && total > 0;

                  return AppListRow(
                    badge: AppBadge.text(badge),
                    title: title,
                    progress: started ? done / total : null,
                    progressLabel: started ? '$done/$total' : null,
                    onTap: () => _openUnit(unit),
                  );
                },
              ),
      ),
    );
  }
}
