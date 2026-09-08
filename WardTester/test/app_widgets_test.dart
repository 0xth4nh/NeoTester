import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trying/theme/app_colors.dart';
import 'package:trying/theme/app_theme.dart';
import 'package:trying/theme/app_typography.dart';
import 'package:trying/widgets/app_widgets.dart';

/// Wraps [child] in the app's theme so widgets resolve the same styles they do
/// at runtime.
Widget _host(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

/// The decoration of the [Ink]/[Container] painted by [finder]'s subtree.
BoxDecoration _decorationOf(WidgetTester tester, Finder finder) {
  final Ink ink = tester.widget<Ink>(
    find.descendant(of: finder, matching: find.byType(Ink)).first,
  );
  return ink.decoration! as BoxDecoration;
}

void main() {
  group('AppChoiceTile', () {
    testWidgets('idle tile is neutral and tappable', (WidgetTester t) async {
      int taps = 0;
      await t.pumpWidget(_host(
        AppChoiceTile(
          letter: 'A',
          text: 'Mean and standard deviation',
          state: ChoiceState.idle,
          onTap: () => taps++,
        ),
      ));

      expect(find.text('A'), findsOneWidget);
      expect(find.text('Mean and standard deviation'), findsOneWidget);

      final BoxDecoration d = _decorationOf(t, find.byType(AppChoiceTile));
      expect(d.color, AppColors.surface);
      expect((d.border! as Border).top.color, AppColors.border);

      await t.tap(find.byType(AppChoiceTile));
      expect(taps, 1);
    });

    testWidgets('selected tile is visibly distinct from idle', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(_host(
        AppChoiceTile(
          letter: 'B',
          text: 'Median and IQR',
          state: ChoiceState.selected,
          onTap: () {},
        ),
      ));

      final BoxDecoration d = _decorationOf(t, find.byType(AppChoiceTile));
      // The regression this guards: picking an answer used to change nothing.
      expect(d.color, AppColors.selectedSurface);
      expect((d.border! as Border).top.color, AppColors.brand500);
      expect(d.color, isNot(AppColors.surface));
    });

    testWidgets('correct state shows a check', (WidgetTester t) async {
      await t.pumpWidget(_host(
        AppChoiceTile(
          letter: 'B',
          text: 'Median and IQR',
          state: ChoiceState.correct,
          onTap: null,
        ),
      ));

      final BoxDecoration d = _decorationOf(t, find.byType(AppChoiceTile));
      expect(d.color, AppColors.successSurface);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('incorrect state shows a cross', (WidgetTester t) async {
      await t.pumpWidget(_host(
        AppChoiceTile(
          letter: 'C',
          text: 'Mean and range',
          state: ChoiceState.incorrect,
          onTap: null,
        ),
      ));

      final BoxDecoration d = _decorationOf(t, find.byType(AppChoiceTile));
      expect(d.color, AppColors.errorSurface);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('null onTap disables the tile', (WidgetTester t) async {
      await t.pumpWidget(_host(
        const AppChoiceTile(
          letter: 'A',
          text: 'Locked',
          state: ChoiceState.idle,
          onTap: null,
        ),
      ));

      final InkWell well = t.widget<InkWell>(find.byType(InkWell));
      expect(well.onTap, isNull);
    });

    testWidgets('meets the 44px minimum tap target', (WidgetTester t) async {
      await t.pumpWidget(_host(
        AppChoiceTile(
          letter: 'A',
          text: 'Short',
          state: ChoiceState.idle,
          onTap: () {},
        ),
      ));

      expect(
        t.getSize(find.byType(AppChoiceTile)).height,
        greaterThanOrEqualTo(44),
      );
    });
  });

  group('AppProgressRing', () {
    testWidgets('renders its label', (WidgetTester t) async {
      await t.pumpWidget(
        _host(const AppProgressRing(value: 0.42, label: '42%')),
      );
      expect(find.text('42%'), findsOneWidget);
      expect(find.text('CORRECT'), findsOneWidget);
    });

    testWidgets('clamps out-of-range and non-finite values', (
      WidgetTester t,
    ) async {
      for (final double v in <double>[-1, 2, double.nan, double.infinity]) {
        await t.pumpWidget(_host(AppProgressRing(value: v, label: 'x')));
        expect(t.takeException(), isNull, reason: 'value $v should not throw');
      }
    });

    testWidgets('is a ring, not a filled disc', (WidgetTester t) async {
      // The screen this replaced used strokeWidth: 120, which painted a solid
      // grey circle. Guard the stroke against creeping past the radius.
      await t.pumpWidget(
        _host(const AppProgressRing(value: 0.5, label: '50%')),
      );
      final AppProgressRing ring = t.widget<AppProgressRing>(
        find.byType(AppProgressRing),
      );
      expect(ring.strokeWidth, lessThan(ring.diameter / 2));
    });
  });

  group('AppProgressBar', () {
    testWidgets('clamps values into 0..1', (WidgetTester t) async {
      await t.pumpWidget(_host(const AppProgressBar(value: 5)));
      final LinearProgressIndicator bar =
          t.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(bar.value, 1.0);

      await t.pumpWidget(_host(const AppProgressBar(value: -3)));
      final LinearProgressIndicator bar2 =
          t.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator));
      expect(bar2.value, 0.0);
    });

    testWidgets('survives NaN', (WidgetTester t) async {
      await t.pumpWidget(_host(const AppProgressBar(value: double.nan)));
      expect(t.takeException(), isNull);
    });
  });

  group('AppListRow', () {
    testWidgets('shows a subtitle when there is no progress', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(_host(
        AppListRow(
          badge: const AppBadge.text('AP'),
          title: 'AP Statistics',
          subtitle: '13 units',
          onTap: () {},
        ),
      ));

      expect(find.text('AP'), findsOneWidget);
      expect(find.text('AP Statistics'), findsOneWidget);
      expect(find.text('13 units'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('shows a bar when progress is set', (WidgetTester t) async {
      await t.pumpWidget(_host(
        AppListRow(
          badge: const AppBadge.text('01'),
          title: 'Organizing Data',
          subtitle: 'ignored',
          progress: 0.25,
          progressLabel: '14/59',
          onTap: () {},
        ),
      ));

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('14/59'), findsOneWidget);
      expect(find.text('ignored'), findsNothing);
    });

    testWidgets('is at least one row tall and tappable', (
      WidgetTester t,
    ) async {
      int taps = 0;
      await t.pumpWidget(_host(
        AppListRow(badge: const AppBadge.text('01'), title: 'Unit', onTap: () => taps++),
      ));

      expect(t.getSize(find.byType(AppListRow)).height,
          greaterThanOrEqualTo(AppSizes.row));
      await t.tap(find.byType(AppListRow));
      expect(taps, 1);
    });
  });

  group('AppFeedbackBanner', () {
    testWidgets('correct banner omits an empty message', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _host(const AppFeedbackBanner(correct: true, message: '')),
      );
      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Not quite'), findsNothing);
    });

    testWidgets('incorrect banner shows the answer', (WidgetTester t) async {
      await t.pumpWidget(_host(
        const AppFeedbackBanner(
          correct: false,
          message: 'The correct answer is: 0.167',
        ),
      ));
      expect(find.text('Not quite'), findsOneWidget);
      expect(find.text('The correct answer is: 0.167'), findsOneWidget);
    });
  });

  group('AppStatTile / AppEmptyState', () {
    testWidgets('stat tile renders value and caption', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _host(const AppStatTile(value: '59', caption: 'Questions')),
      );
      expect(find.text('59'), findsOneWidget);
      expect(find.text('Questions'), findsOneWidget);
    });

    testWidgets('empty state renders icon, title and message', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(_host(
        const AppEmptyState(
          icon: Icons.task_alt_rounded,
          title: 'No completed units yet',
          message: 'Finish a unit and it lands here.',
        ),
      ));
      expect(find.byIcon(Icons.task_alt_rounded), findsOneWidget);
      expect(find.text('No completed units yet'), findsOneWidget);
    });
  });

  group('AppQuestionProgressHeader', () {
    testWidgets('reports position and percentage', (WidgetTester t) async {
      await t.pumpWidget(
        _host(const AppQuestionProgressHeader(index: 7, total: 59)),
      );
      expect(find.text('QUESTION 7 OF 59'), findsOneWidget);
      expect(find.text('12% complete'), findsOneWidget);
    });

    testWidgets('does not divide by zero on an empty unit', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _host(const AppQuestionProgressHeader(index: 1, total: 0)),
      );
      expect(t.takeException(), isNull);
      expect(find.text('0% complete'), findsOneWidget);
    });
  });

  group('showDestructiveConfirm', () {
    Future<bool?> run(WidgetTester t, String tapLabel) async {
      bool? outcome;
      await t.pumpWidget(MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) => ElevatedButton(
              onPressed: () async {
                outcome = await showDestructiveConfirm(
                  context,
                  title: 'Restart unit?',
                  message: 'All progress in this unit will be lost.',
                  confirmLabel: 'Restart',
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ));

      await t.tap(find.text('open'));
      await t.pumpAndSettle();
      expect(find.text('Restart unit?'), findsOneWidget);

      await t.tap(find.text(tapLabel));
      await t.pumpAndSettle();
      return outcome;
    }

    testWidgets('returns true when confirmed', (WidgetTester t) async {
      expect(await run(t, 'Restart'), isTrue);
    });

    testWidgets('returns false when cancelled', (WidgetTester t) async {
      expect(await run(t, 'Cancel'), isFalse);
    });
  });
}
