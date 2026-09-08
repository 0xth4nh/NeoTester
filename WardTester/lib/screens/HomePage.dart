import 'package:flutter/material.dart';
import 'package:trying/screens/helper_screens/NameSetPage.dart';
import '../main.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/app_widgets.dart';
import 'SelectCoursePage.dart';
import 'progress_screens/RecordPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<void> _changeName() async {
    final bool confirmed = await showDestructiveConfirm(
      context,
      title: 'Change name?',
      message: 'Changing your name deletes all saved progress on this device.',
      confirmLabel: 'Change name',
    );
    if (!confirmed || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NameSetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = studentName.trim();

    return Scaffold(
      appBar: AppTopBar(
        title: 'WardTester',
        showBack: false,
        actions: <Widget>[
          AppIconAction(
            icon: Icons.settings_outlined,
            tooltip: 'Change name',
            onPressed: _changeName,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            28,
            AppSpacing.gutter,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                name.isEmpty ? 'WELCOME' : 'WELCOME BACK',
                style: AppText.label,
              ),
              const SizedBox(height: 6),
              Text(
                name.isEmpty ? 'WardTester' : name,
                style: AppText.display,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppShadows.card,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.xxxl),
                  child: Center(
                    // Capped so the mark stays a logo rather than stretching to
                    // fill a tall card on large screens.
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Image.asset(
                        'assets/LaunchImageHR.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => SelectCoursePage(courseList: courseList),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('Start Test'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const RecordPage()),
                  );
                },
                child: const Text('Progress'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
