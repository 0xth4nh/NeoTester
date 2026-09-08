import 'package:flutter/material.dart';

import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_widgets.dart';

/// The Progress tab inside a unit.
///
/// This replaces a CircularProgressIndicator with `strokeWidth: 120`, which
/// rendered as a solid grey disc showing nothing.
class ProgressGraph extends StatelessWidget {
  const ProgressGraph({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int total = currentTest.getNumQuestion() as int;
    final int correct = currentTest.getTotalCorrect() as int;
    final int attempts = currentTest.getTotalAttempt() as int;
    final double fraction = total > 0 ? correct / total : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.gutter,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.panel),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: <Widget>[
                AppProgressRing(
                  value: fraction,
                  label: '${(fraction * 100).round()}%',
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  '$correct of $total questions answered correctly',
                  textAlign: TextAlign.center,
                  style: AppText.bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: AppStatTile(value: '$total', caption: 'Questions'),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: AppStatTile(value: '$attempts', caption: 'Attempts'),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: AppStatTile(
                  value: '$correct',
                  caption: 'Correct',
                  valueColor: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.brand50,
              borderRadius: BorderRadius.circular(AppRadius.choice),
              border: Border.all(color: AppColors.brand200),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Accuracy',
                        style: AppText.bodyText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brand700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Correct answers per attempt',
                        style: AppText.captionStrong.copyWith(
                          color: AppColors.brand600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  attempts > 0
                      ? '${((currentTest.getAccuracy() as double) * 100).round()}%'
                      : '—',
                  style: AppText.statValue.copyWith(color: AppColors.brand700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
