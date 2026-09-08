import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

/// A labelled answer input. Typed answers use the monospace face so digits and
/// symbols line up.
class AnswerField extends StatelessWidget {
  const AnswerField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.large = false,
    this.keyboardType,
    this.helperText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool enabled;

  /// Larger type, for a single numeric answer.
  final bool large;

  final TextInputType? keyboardType;
  final String? helperText;
  final ValueChanged<String>? onChanged;

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
          enabled: enabled,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: large ? AppText.answerLarge : AppText.answer,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppText.bodyText.copyWith(
              color: AppColors.textPlaceholder,
            ),
            fillColor: enabled ? AppColors.surface : AppColors.hoverSurface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: large ? 16 : 14,
              vertical: large ? 16 : 14,
            ),
          ),
        ),
        if (helperText != null) ...<Widget>[
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  helperText!,
                  style: AppText.captionStrong.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
