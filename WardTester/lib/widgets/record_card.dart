import 'package:flutter/material.dart';

import '../back_end/Test.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'app_widgets.dart';

/// One saved test, as a card.
///
/// The records screens previously packed four columns of 9px text into a
/// ListTile Row, which was effectively unreadable on a phone.
class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.test, required this.completed});

  final Test test;

  /// Completed records show a finish date; in-progress ones show a bar.
  final bool completed;

  /// "2026-09-02 18:04:11.123" -> "2 Sep 2026". Falls back to the raw text.
  static String _formatDate(String raw) {
    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return raw.length >= 10 ? raw.substring(0, 10) : raw;
    }
    const List<String> months = <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
  }

  @override
  Widget build(BuildContext context) {
    final int total = test.getNumQuestion();
    final int left = test.getQuestionLeft();
    final int done = (total - left).clamp(0, total);
    final int accuracy = (test.getAccuracy() * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      test.getUnit(),
                      style: AppText.rowTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      completed
                          ? 'Finished ${_formatDate(test.getTimeEnd())}'
                          : 'Started ${_formatDate(test.getTimeStart())}',
                      style: AppText.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _AccuracyPill(accuracy: accuracy),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: AppProgressBar(value: total > 0 ? done / total : 0),
              ),
              const SizedBox(width: 10),
              Text(
                completed ? '$total done' : '$left left',
                style: AppText.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccuracyPill extends StatelessWidget {
  const _AccuracyPill({required this.accuracy});

  final int accuracy;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;
    if (accuracy >= 80) {
      background = AppColors.successSurface;
      foreground = AppColors.successText;
    } else if (accuracy >= 60) {
      background = AppColors.brand50;
      foreground = AppColors.brand700;
    } else {
      background = AppColors.errorSurface;
      foreground = AppColors.errorText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '$accuracy%',
        style: TextStyle(
          fontFamily: AppFonts.display,
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: foreground,
        ),
      ),
    );
  }
}
