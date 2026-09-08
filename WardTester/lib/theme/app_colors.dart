import 'package:flutter/material.dart';

/// The WardTester palette.
///
/// [brand500] is the original app colour and the colour of the logo mark; the
/// rest of the ramp exists so screens can use tints and shades of it instead of
/// repeating the one saturated blue on every surface.
class AppColors {
  const AppColors._();

  // Brand ramp, anchored on the existing #2979FF.
  static const Color brand50 = Color(0xFFEFF5FF);
  static const Color brand100 = Color(0xFFDCE8FF);
  static const Color brand200 = Color(0xFFBBD1FF);
  static const Color brand400 = Color(0xFF5B93FF);
  static const Color brand500 = Color(0xFF2979FF);
  static const Color brand600 = Color(0xFF1A5FD6);
  static const Color brand700 = Color(0xFF1547A3);

  // Neutrals.
  static const Color background = Color(0xFFF6F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E8EE);
  static const Color borderStrong = Color(0xFFCFD6E0);
  static const Color disabledSurface = Color(0xFFE9EDF3);
  static const Color hoverSurface = Color(0xFFF1F4F9);

  // Text. [textSecondary] and [textMuted] both clear WCAG AA at the sizes the
  // type scale uses them; do not lighten them without rechecking contrast.
  static const Color textPrimary = Color(0xFF0F1520);
  static const Color textSecondary = Color(0xFF586273);
  static const Color textMuted = Color(0xFF667080);
  static const Color textDisabled = Color(0xFF5F6A79);
  static const Color textPlaceholder = Color(0xFF7A8394);

  // Semantic.
  static const Color success = Color(0xFF0E7A54);
  static const Color successSurface = Color(0xFFE6F5EE);
  static const Color successBorder = Color(0xFF9FD8BF);
  static const Color successText = Color(0xFF0B5C40);

  static const Color error = Color(0xFFC33C31);
  static const Color errorSurface = Color(0xFFFCECEA);
  static const Color errorBorder = Color(0xFFF0BAB4);
  static const Color errorText = Color(0xFF92281F);

  static const Color warningSurface = Color(0xFFFFF8EC);
  static const Color warningBorder = Color(0xFFF2D9A8);
  static const Color warning = Color(0xFFA96B08);
  static const Color warningText = Color(0xFF7A4E06);

  /// Fill behind a selected answer or a focused field.
  static const Color selectedSurface = Color(0xFFF5F9FF);
}
