import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// The single source of truth for the app's look.
///
/// Before this existed, every screen set its own `Color(0xFF2979FF)` — 27 of
/// them across the widget tree. Screens should read from [Theme] or from
/// [AppColors]/[AppText] rather than reintroducing literals.
class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand500,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.brand500,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFonts.body,
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: AppSizes.appBar,
        titleTextStyle: AppText.appBarTitle,
        iconTheme: IconThemeData(color: AppColors.textPrimary, size: 22),
        actionsIconTheme: IconThemeData(color: AppColors.textSecondary, size: 22),
      ),

      textTheme: const TextTheme(
        displaySmall: AppText.display,
        titleLarge: AppText.title,
        titleMedium: AppText.rowTitle,
        bodyLarge: AppText.bodyLarge,
        bodyMedium: AppText.bodyText,
        labelLarge: AppText.button,
        labelMedium: AppText.label,
        labelSmall: AppText.caption,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size.fromHeight(AppSizes.control),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabledSurface;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.brand600;
            }
            return AppColors.brand500;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.textDisabled;
            }
            return Colors.white;
          }),
          elevation: const WidgetStatePropertyAll<double>(0),
          textStyle: const WidgetStatePropertyAll<TextStyle>(AppText.button),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.control)),
            ),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll<Size>(
            Size.fromHeight(AppSizes.control),
          ),
          backgroundColor: const WidgetStatePropertyAll<Color>(AppColors.surface),
          foregroundColor: const WidgetStatePropertyAll<Color>(AppColors.brand600),
          textStyle: const WidgetStatePropertyAll<TextStyle>(AppText.button),
          side: const WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: AppColors.borderStrong),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.control)),
            ),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: AppText.bodyText.copyWith(color: AppColors.textPlaceholder),
        border: _fieldBorder(AppColors.border),
        enabledBorder: _fieldBorder(AppColors.border),
        focusedBorder: _fieldBorder(AppColors.brand500),
        errorBorder: _fieldBorder(AppColors.error),
        focusedErrorBorder: _fieldBorder(AppColors.error),
      ),

      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.brand600,
        unselectedLabelColor: AppColors.textMuted,
        indicatorColor: AppColors.brand500,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFonts.body,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.panel)),
        ),
        titleTextStyle: AppText.title.copyWith(fontSize: 20),
        contentTextStyle: AppText.bodyText.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color) => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.control)),
        borderSide: BorderSide(color: color, width: 2),
      );
}
