import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trying/back_end/Test.dart' as backend;
import 'package:trying/theme/app_theme.dart';
import 'package:trying/widgets/record_card.dart';

Widget _host(Widget child) => MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    );

backend.Test _test({
  String name = 'AP Statistics:01 - Organizing Data',
  int remaining = 45,
  int total = 59,
  int attempts = 21,
  DateTime? start,
  DateTime? end,
}) {
  final Queue<int> order = Queue<int>.of(
    List<int>.generate(remaining, (int i) => i),
  );
  return backend.Test(
    name,
    order,
    start ?? DateTime(2026, 9, 2, 18, 4),
    end ?? DateTime(2026, 9, 5, 9, 30),
    total,
    attempts,
  );
}

void main() {
  group('RecordCard', () {
    testWidgets('in-progress card shows the unit, start date and count left', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _host(RecordCard(test: _test(), completed: false)),
      );

      // getUnit() strips the course prefix before the colon.
      expect(find.text('01 - Organizing Data'), findsOneWidget);
      expect(find.text('Started 2 Sep 2026'), findsOneWidget);
      expect(find.text('45 left'), findsOneWidget);
    });

    testWidgets('completed card shows the finish date', (
      WidgetTester t,
    ) async {
      // getTimeEnd() only returns a date once no questions remain.
      await t.pumpWidget(
        _host(RecordCard(test: _test(remaining: 0), completed: true)),
      );

      expect(find.text('Finished 5 Sep 2026'), findsOneWidget);
      expect(find.text('59 done'), findsOneWidget);
    });

    testWidgets('accuracy is rendered as a whole percentage', (
      WidgetTester t,
    ) async {
      // 59 - 45 = 14 correct out of 21 attempts = 66.67% -> 67%.
      await t.pumpWidget(
        _host(RecordCard(test: _test(), completed: false)),
      );
      expect(find.text('67%'), findsOneWidget);
    });

    testWidgets('zero attempts does not divide by zero', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _host(RecordCard(test: _test(attempts: 0), completed: false)),
      );
      expect(t.takeException(), isNull);
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('a unit with no questions does not divide by zero', (
      WidgetTester t,
    ) async {
      await t.pumpWidget(
        _host(RecordCard(
          test: _test(remaining: 0, total: 0, attempts: 0),
          completed: false,
        )),
      );
      expect(t.takeException(), isNull);
    });

    testWidgets('a name with no colon still renders', (WidgetTester t) async {
      await t.pumpWidget(
        _host(RecordCard(test: _test(name: 'Loose Unit'), completed: false)),
      );
      expect(t.takeException(), isNull);
      expect(find.textContaining('Loose Unit'), findsOneWidget);
    });
  });
}
