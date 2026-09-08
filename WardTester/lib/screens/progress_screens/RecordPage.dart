import 'package:flutter/material.dart';

import '../../back_end/Test.dart';
import '../../back_end/utils.dart';
import '../../main.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_widgets.dart';
import 'CompleteRecordPage.dart';
import 'ProgressPage.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  Future<void> _clearProgress() async {
    final bool confirmed = await showDestructiveConfirm(
      context,
      title: 'Delete current progress?',
      message: 'This deletes every started but unfinished unit. Completed '
          'records are kept.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;

    await removeAllProgress();
    if (!mounted) return;
    setState(() {
      testProgressList = List<Test>.empty(growable: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String name = studentName.toString().trim();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Progress',
          subtitle: name.isEmpty ? null : name,
          actions: <Widget>[
            AppIconAction(
              icon: Icons.delete_outline_rounded,
              tooltip: 'Delete current progress',
              onPressed: _clearProgress,
            ),
          ],
          bottom: const AppTabBar(tabs: <String>['In progress', 'Completed']),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: <Widget>[
              ProgressPage(),
              CompleteRecordPage(),
            ],
          ),
        ),
      ),
    );
  }
}
