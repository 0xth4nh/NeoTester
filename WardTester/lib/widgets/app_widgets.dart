import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A tappable card row: a badge, a title, an optional subtitle or progress bar,
/// and a chevron. Replaces the full-width blue ElevatedButtons the lists used.
class AppListRow extends StatelessWidget {
  const AppListRow({
    super.key,
    required this.badge,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.progress,
    this.progressLabel,
  });

  /// The leading tile — an [AppBadge], either an icon or short text.
  final Widget badge;
  final String title;
  final VoidCallback onTap;

  /// Shown when there is no [progress].
  final String? subtitle;

  /// 0..1. When set, a progress bar replaces the subtitle.
  final double? progress;
  final String? progressLabel;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.card,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.row),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Row(
                children: <Widget>[
                  badge,
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          title,
                          style: AppText.rowTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (progress != null) ...<Widget>[
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              Expanded(child: AppProgressBar(value: progress!)),
                              if (progressLabel != null) ...<Widget>[
                                const SizedBox(width: 8),
                                Text(
                                  progressLabel!,
                                  style: AppText.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ] else if (subtitle != null) ...<Widget>[
                          const SizedBox(height: 3),
                          Text(
                            subtitle!,
                            style: AppText.captionStrong.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The leading tile on a list row: a subject icon, or short text when there is
/// no icon for it.
class AppBadge extends StatelessWidget {
  const AppBadge.text(String this.label, {super.key}) : icon = null;

  const AppBadge.icon(IconData this.icon, {super.key}) : label = null;

  final String? label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.brand50,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: icon != null
          ? Icon(icon, size: 21, color: AppColors.brand600)
          // Text badges run from one to four characters ("01", "APCS"); shrink
          // to fit rather than clipping the longer ones.
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label!,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: AppFonts.display,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: -0.15,
                    color: AppColors.brand600,
                  ),
                ),
              ),
            ),
    );
  }
}

/// A rounded progress track.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value, this.height = 6});

  /// 0..1; values outside are clamped.
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final double v = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: LinearProgressIndicator(
        value: v,
        minHeight: height,
        backgroundColor: AppColors.border,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brand500),
      ),
    );
  }
}

/// The state a single multiple-choice option is in.
enum ChoiceState { idle, selected, correct, incorrect }

/// One selectable answer. The previous screen gave a picked answer no visual
/// state at all — it only appended "Selected Answer: ..." as a line of text.
class AppChoiceTile extends StatelessWidget {
  const AppChoiceTile({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String letter;
  final String text;
  final ChoiceState state;

  /// Null disables the tile, which is how it reads after submitting.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (Color border, Color fill, Color badgeFill, Color badgeText) =
        switch (state) {
      ChoiceState.idle => (
          AppColors.border,
          AppColors.surface,
          AppColors.hoverSurface,
          AppColors.textSecondary,
        ),
      ChoiceState.selected => (
          AppColors.brand500,
          AppColors.selectedSurface,
          AppColors.brand500,
          Colors.white,
        ),
      ChoiceState.correct => (
          AppColors.success,
          AppColors.successSurface,
          AppColors.success,
          Colors.white,
        ),
      ChoiceState.incorrect => (
          AppColors.error,
          AppColors.errorSurface,
          AppColors.error,
          Colors.white,
        ),
    };

    return Semantics(
      button: true,
      selected: state != ChoiceState.idle,
      label: '$letter. $text',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.choice),
          child: Ink(
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(AppRadius.choice),
              border: Border.all(color: border, width: 2),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 56),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: badgeFill,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontFamily: AppFonts.display,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: badgeText,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: AppText.bodyText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (state == ChoiceState.correct ||
                        state == ChoiceState.incorrect) ...<Widget>[
                      const SizedBox(width: 10),
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: state == ChoiceState.correct
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          state == ChoiceState.correct
                              ? Icons.check_rounded
                              : Icons.close_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The banner shown after submitting an answer.
class AppFeedbackBanner extends StatelessWidget {
  const AppFeedbackBanner({
    super.key,
    required this.correct,
    required this.message,
  });

  final bool correct;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: correct ? AppColors.successSurface : AppColors.errorSurface,
        borderRadius: BorderRadius.circular(AppRadius.choice),
        border: Border.all(
          color: correct ? AppColors.successBorder : AppColors.errorBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            correct ? 'Correct' : 'Not quite',
            style: AppText.bodyText.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: correct ? AppColors.successText : AppColors.errorText,
            ),
          ),
          if (message.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              message,
              style: AppText.bodyText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: correct ? AppColors.successText : AppColors.errorText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A real progress ring.
///
/// The screen this replaces used a CircularProgressIndicator with
/// `strokeWidth: 120`, which paints as a solid grey disc with no readable value.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.value,
    required this.label,
    this.caption = 'Correct',
    this.diameter = 200,
    this.strokeWidth = 16,
  });

  /// 0..1; values outside are clamped.
  final double value;
  final String label;
  final String caption;
  final double diameter;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final double v = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size.square(diameter),
            painter: _RingPainter(value: v, strokeWidth: strokeWidth),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(label, style: AppText.ringValue),
              const SizedBox(height: 2),
              Text(caption.toUpperCase(), style: AppText.label),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.value, required this.strokeWidth});

  final double value;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.shortestSide - strokeWidth) / 2;

    final Paint track = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, track);

    if (value <= 0) return;

    final Paint fill = Paint()
      ..color = AppColors.brand500
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      fill,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.strokeWidth != strokeWidth;
}

/// A number with a caption, used in a row of three.
class AppStatTile extends StatelessWidget {
  const AppStatTile({
    super.key,
    required this.value,
    required this.caption,
    this.valueColor,
  });

  final String value;
  final String caption;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.choice),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: valueColor == null
                ? AppText.statValue
                : AppText.statValue.copyWith(color: valueColor),
          ),
          const SizedBox(height: 5),
          Text(caption, style: AppText.caption),
        ],
      ),
    );
  }
}

/// Centred icon, title and body — used where a list has nothing in it.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.brand50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: AppColors.brand400),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.bodyLarge.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppText.bodyText.copyWith(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The "Question N of M" header above a question, with its progress bar.
class AppQuestionProgressHeader extends StatelessWidget {
  const AppQuestionProgressHeader({
    super.key,
    required this.index,
    required this.total,
  });

  /// 1-based.
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double value = total > 0 ? index / total : 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.lg,
        AppSpacing.gutter,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Text('QUESTION $index OF $total', style: AppText.label),
              ),
              Text(
                '${(value * 100).round()}% complete',
                style: const TextStyle(
                  fontFamily: AppFonts.display,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppProgressBar(value: value),
        ],
      ),
    );
  }
}

/// A confirmation dialog for a destructive action.
Future<bool> showDestructiveConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final bool? result = await showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                    message,
                    style: AppText.bodyText.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.warningText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: <Widget>[
        OutlinedButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}
