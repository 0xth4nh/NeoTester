import 'package:flutter/material.dart';

import '../../back_end/utils.dart';
import '../../main.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/app_widgets.dart';
import 'ProgressGraph.dart';
import 'QuestionView.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final String unitName = currentTest.getUnit();

  Future<void> _restartUnit() async {
    final bool confirmed = await showDestructiveConfirm(
      context,
      title: 'Restart unit?',
      message: 'All progress in this unit will be lost.',
      confirmLabel: 'Restart',
    );
    if (!confirmed || !mounted) return;

    await restartUnit();
    if (!mounted) return;
    // Replace rather than push: restarting should not stack another copy of
    // this screen behind the fresh one.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const QuestionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppTopBar(
          title: unitName,
          subtitle: currentCourse?.toString(),
          actions: <Widget>[
            AppIconAction(
              icon: Icons.refresh_rounded,
              tooltip: 'Restart unit',
              onPressed: _restartUnit,
            ),
          ],
          bottom: const AppTabBar(tabs: <String>['Question', 'Progress']),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: <Widget>[
              QuestionView(),
              ProgressGraph(),
            ],
          ),
        ),
      ),
    );
  }
}
