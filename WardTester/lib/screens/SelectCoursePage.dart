import 'dart:io';

import 'package:flutter/material.dart';

import '../main.dart';
import '../theme/app_typography.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_widgets.dart';
import 'SelectUnitPage.dart';
import 'course_badge.dart';

class SelectCoursePage extends StatefulWidget {
  final Set<String>? courseList;
  const SelectCoursePage({Key? key, this.courseList}) : super(key: key);

  @override
  _SelectCoursePageState createState() => _SelectCoursePageState();
}

class _SelectCoursePageState extends State<SelectCoursePage> {
  /// Reads the unit list for [course] and navigates on.
  Future<void> _openCourse(String course) async {
    if (!File('$appDocPath$testDirectory/$course/unit.txt').existsSync()) {
      testDirectory = '';
    }
    final File unitFile = File('$appDocPath$testDirectory/$course/unit.txt');
    final String contents = await unitFile.readAsString();
    final Set<String> units = contents
        .split(',')
        .map((String u) => u.trim())
        .where((String u) => u.isNotEmpty)
        .toSet();

    unitList = units;
    currentCourse = course;
    currentUnitList = units;

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SelectUnitPage(unitList: units, course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> courses = widget.courseList?.toList() ?? <String>[];

    return Scaffold(
      appBar: const AppTopBar(title: 'Select course'),
      body: SafeArea(
        child: courses.isEmpty
            ? const AppEmptyState(
                icon: Icons.menu_book_outlined,
                title: 'No courses downloaded',
                message:
                    'Connect to the internet and reopen the app to download '
                    'your course list.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.gutter),
                itemCount: courses.length + 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm + 2),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 2),
                      child: Text(
                        '${courses.length} '
                        '${courses.length == 1 ? "COURSE" : "COURSES"}',
                        style: AppText.label,
                      ),
                    );
                  }
                  final String course = courses[index - 1];
                  return AppListRow(
                    badge: courseBadge(course),
                    title: course,
                    onTap: () => _openCourse(course),
                  );
                },
              ),
      ),
    );
  }
}
