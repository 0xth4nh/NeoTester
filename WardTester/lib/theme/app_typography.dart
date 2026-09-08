import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Font families, declared in pubspec.yaml and bundled under assets/fonts.
class AppFonts {
  const AppFonts._();

  /// Headings and every number. Chosen for its figures.
  static const String display = 'SpaceGrotesk';

  /// Body and UI.
  static const String body = 'PublicSans';

  /// Typed answers only.
  static const String mono = 'IBMPlexMono';
}

/// The type scale. Nothing here is smaller than 12px.
class AppText {
  const AppText._();

  static const TextStyle display = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: 30,
    height: 36 / 30,
    letterSpacing: -0.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 28 / 22,
    letterSpacing: -0.22,
    color: AppColors.textPrimary,
  );

  /// App-bar titles.
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: 19,
    height: 24 / 19,
    letterSpacing: -0.19,
    color: AppColors.textPrimary,
  );

  /// App-bar title when a subtitle sits under it.
  static const TextStyle appBarTitleCompact = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: 17,
    height: 22 / 17,
    letterSpacing: -0.17,
    color: AppColors.textPrimary,
  );

  static const TextStyle appBarSubtitle = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.textMuted,
  );

  /// Question prompts.
  static const TextStyle question = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 26 / 18,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: 17,
    height: 26 / 17,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 22 / 15,
    color: AppColors.textPrimary,
  );

  /// Row and card titles.
  static const TextStyle rowTitle = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 20 / 15,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 20 / 16,
  );

  /// Uppercase section labels.
  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.96,
    color: AppColors.textMuted,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
    color: AppColors.textMuted,
  );

  static const TextStyle captionStrong = TextStyle(
    fontFamily: AppFonts.body,
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 18 / 13,
    color: AppColors.textSecondary,
  );

  /// Typed answers.
  static const TextStyle answer = TextStyle(
    fontFamily: AppFonts.mono,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 22 / 15,
    color: AppColors.textPrimary,
  );

  /// The single large numeric answer field.
  static const TextStyle answerLarge = TextStyle(
    fontFamily: AppFonts.mono,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: 28 / 22,
    letterSpacing: 0.22,
    color: AppColors.textPrimary,
  );

  /// Big numbers: the progress ring, stat tiles.
  static const TextStyle statValue = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 28 / 24,
    letterSpacing: -0.48,
    color: AppColors.textPrimary,
  );

  static const TextStyle ringValue = TextStyle(
    fontFamily: AppFonts.display,
    fontWeight: FontWeight.w700,
    fontSize: 44,
    height: 48 / 44,
    letterSpacing: -1.32,
    color: AppColors.textPrimary,
  );
}

/// Spacing, radii and control sizes.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Standard screen gutter.
  static const double gutter = 20;
}

class AppRadius {
  const AppRadius._();

  static const double control = 12;
  static const double choice = 14;
  static const double card = 16;
  static const double panel = 20;
  static const double pill = 999;
}

class AppSizes {
  const AppSizes._();

  /// Minimum tap target, per the design system and platform guidance.
  static const double tapTarget = 44;
  static const double control = 52;
  static const double row = 64;
  static const double appBar = 56;
  static const double tab = 44;
}

class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(
      color: Color(0x0D0F1520),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> raised = <BoxShadow>[
    BoxShadow(
      color: Color(0x120F1520),
      offset: Offset(0, 2),
      blurRadius: 10,
    ),
  ];
}
