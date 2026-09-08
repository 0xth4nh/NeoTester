import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trying/theme/app_colors.dart';
import 'package:trying/theme/app_theme.dart';
import 'package:trying/theme/app_typography.dart';

/// Every Dart file under lib/, so the guards below cannot be sidestepped by
/// adding a new screen.
List<File> _libSources() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .where((File f) => f.path.endsWith('.dart'))
    .toList();

/// Relative luminance per WCAG 2.1. Color channels are 0..1.
double _luminance(Color c) {
  double channel(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * channel(c.r) +
      0.7152 * channel(c.g) +
      0.0722 * channel(c.b);
}

double contrastRatio(Color a, Color b) {
  final double la = _luminance(a);
  final double lb = _luminance(b);
  final double lighter = math.max(la, lb);
  final double darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('contrastRatio', () {
    test('matches known reference values', () {
      expect(
        contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
        closeTo(21.0, 0.01),
      );
      expect(
        contrastRatio(const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)),
        closeTo(1.0, 0.01),
      );
      expect(
        contrastRatio(const Color(0xFF767676), const Color(0xFFFFFFFF)),
        closeTo(4.54, 0.05),
      );
    });
  });

  group('no legacy style literals', () {
    test('screens and widgets do not hard-code the old palette', () {
      // These were repeated across every screen before the theme existed.
      const List<String> banned = <String>[
        '0xFF2979FF', // brand blue
        '0xFFF5F5F5', // old scaffold background
        '0xFFFAFAFA', // old button label
      ];

      final List<String> offenders = <String>[];
      for (final File f in _libSources()) {
        // The palette itself is allowed to name its own values.
        if (f.path.endsWith('app_colors.dart')) continue;
        // Comments may quote the old values to explain what replaced them.
        final String src = f
            .readAsLinesSync()
            .where((String l) => !l.trimLeft().startsWith('//'))
            .join('\n');
        for (final String literal in banned) {
          if (src.contains(literal)) {
            offenders.add('${f.path}: $literal');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: 'Use AppColors / Theme instead of raw colour literals:\n'
            '${offenders.join('\n')}',
      );
    });

    test('no font size drops below 12', () {
      final RegExp sizes = RegExp(r'fontSize:\s*([0-9]+(?:\.[0-9]+)?)');
      final List<String> offenders = <String>[];

      for (final File f in _libSources()) {
        final String src = f.readAsStringSync();
        for (final RegExpMatch m in sizes.allMatches(src)) {
          final double size = double.parse(m.group(1)!);
          if (size < 12) {
            offenders.add('${f.path}: fontSize $size');
          }
        }
      }

      expect(
        offenders,
        isEmpty,
        reason: 'The records table used to set fontSize: 9:\n'
            '${offenders.join('\n')}',
      );
    });
  });

  group('theme', () {
    test('exposes the brand colour as the primary', () {
      expect(AppTheme.light.colorScheme.primary, AppColors.brand500);
    });

    test('buttons are at least the minimum control height', () {
      final ButtonStyle? style = AppTheme.light.elevatedButtonTheme.style;
      final Size? min = style?.minimumSize?.resolve(<WidgetState>{});
      expect(min?.height, greaterThanOrEqualTo(AppSizes.control));
      expect(AppSizes.control, greaterThanOrEqualTo(AppSizes.tapTarget));
    });

    test('disabled button text is readable on the disabled surface', () {
      final ButtonStyle? style = AppTheme.light.elevatedButtonTheme.style;
      final Color? fg =
          style?.foregroundColor?.resolve(<WidgetState>{WidgetState.disabled});
      final Color? bg =
          style?.backgroundColor?.resolve(<WidgetState>{WidgetState.disabled});

      // These labels carry the instruction ("Select an answer"), so they have
      // to clear AA rather than reading as decoration.
      expect(contrastRatio(fg!, bg!), greaterThanOrEqualTo(4.5));
    });

    test('body and muted text clear AA on their backgrounds', () {
      expect(
        contrastRatio(AppColors.textPrimary, AppColors.background),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(AppColors.textMuted, AppColors.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(AppColors.textMuted, AppColors.background),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(AppColors.textSecondary, AppColors.surface),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('feedback text clears AA on its own surface', () {
      expect(
        contrastRatio(AppColors.successText, AppColors.successSurface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(AppColors.errorText, AppColors.errorSurface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(AppColors.warningText, AppColors.warningSurface),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('brand surfaces carry enough contrast for their text', () {
      // White on brand is a large-text/UI pairing, so 3:1 is the bar.
      expect(
        contrastRatio(const Color(0xFFFFFFFF), AppColors.brand500),
        greaterThanOrEqualTo(3.0),
      );
      expect(
        contrastRatio(AppColors.brand600, AppColors.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(AppColors.brand700, AppColors.brand50),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('type scale', () {
    test('every declared style is at least 12px', () {
      final List<TextStyle> styles = <TextStyle>[
        AppText.display,
        AppText.title,
        AppText.appBarTitle,
        AppText.appBarTitleCompact,
        AppText.appBarSubtitle,
        AppText.question,
        AppText.bodyLarge,
        AppText.bodyText,
        AppText.rowTitle,
        AppText.button,
        AppText.label,
        AppText.caption,
        AppText.captionStrong,
        AppText.answer,
        AppText.answerLarge,
        AppText.statValue,
        AppText.ringValue,
      ];

      for (final TextStyle s in styles) {
        expect(s.fontSize, isNotNull);
        expect(s.fontSize!, greaterThanOrEqualTo(12));
      }
    });

    test('uses the three bundled families and nothing else', () {
      const Set<String> allowed = <String>{
        AppFonts.display,
        AppFonts.body,
        AppFonts.mono,
      };

      for (final TextStyle s in <TextStyle>[
        AppText.display,
        AppText.bodyText,
        AppText.answer,
      ]) {
        expect(allowed, contains(s.fontFamily));
      }
    });

    test('every bundled font file declared in pubspec exists', () {
      final String pubspec = File('pubspec.yaml').readAsStringSync();
      final RegExp assets = RegExp(r'asset:\s*(assets/fonts/[^\s]+)');
      final List<String> declared = assets
          .allMatches(pubspec)
          .map((RegExpMatch m) => m.group(1)!)
          .toList();

      expect(declared, isNotEmpty);
      for (final String path in declared) {
        expect(File(path).existsSync(), isTrue, reason: 'missing $path');
      }
    });
  });
}
