import 'dart:io';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_scaffold.dart';
import '../HomePage.dart';

class NameSetPage extends StatefulWidget {
  const NameSetPage({Key? key}) : super(key: key);

  @override
  NameSetPageState createState() => NameSetPageState();
}

class NameSetPageState extends State<NameSetPage> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  bool get _ready =>
      _firstName.text.trim().isNotEmpty && _lastName.text.trim().isNotEmpty;

  Future<void> _submit() async {
    studentName = '${_firstName.text.trim()} ${_lastName.text.trim()}';

    File('$appDocPath/name.txt').writeAsStringSync(studentName);
    File('$appDocPath/progress.txt').writeAsStringSync('[]');
    File('$appDocPath/complete.txt').writeAsStringSync('[]');
    testProgressList = <dynamic>[];
    completeTestList = <dynamic>[];

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'WardTester', showBack: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.xxxl,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/LaunchImageHR.png',
                  width: 132,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Set up your name',
                textAlign: TextAlign.center,
                style: AppText.display.copyWith(fontSize: 28, height: 34 / 28),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your progress is saved against this name on this device.',
                textAlign: TextAlign.center,
                style: AppText.bodyText.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _Field(
                label: 'FIRST NAME',
                controller: _firstName,
                hint: 'First name',
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 14),
              _Field(
                label: 'LAST NAME',
                controller: _lastName,
                hint: 'Last name',
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningSurface,
                  borderRadius: BorderRadius.circular(AppRadius.choice),
                  border: Border.all(color: AppColors.warningBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Changing your name later clears all saved progress.',
                        style: AppText.captionStrong.copyWith(
                          color: AppColors.warningText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: _ready ? _submit : null,
                child: Text(_ready ? 'Continue' : 'Enter your name'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: AppText.label.copyWith(letterSpacing: 0.72)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          style: AppText.bodyLarge.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(hintText: hint),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
