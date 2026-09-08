import 'package:flutter_test/flutter_test.dart';
import 'package:trying/screens/course_badge.dart';

void main() {
  group('course badge', () {
    test('keeps a leading acronym instead of re-initialising it', () {
      // The regression: initialising every word turned "AP Statistics" into
      // "AS", which reads as a different course.
      expect(courseBadge('AP Statistics'), 'AP');
      expect(courseBadge('APCS-A'), 'APCS');
      expect(courseBadge('APCS-P'), 'APCS');
    });

    test('initialises ordinary multi-word names', () {
      expect(courseBadge('Statistics with Algebra'), 'SWA');
      expect(courseBadge('Latin-1'), 'L1');
    });

    test('handles single words and odd input', () {
      expect(courseBadge('Calculus'), 'CAL');
      expect(courseBadge('Go'), 'GO');
      expect(courseBadge(''), '?');
      expect(courseBadge('   '), '?');
    });

    test('never exceeds four characters', () {
      const List<String> names = <String>[
        'AP Statistics',
        'APCS-A',
        'Statistics with Algebra',
        'Latin-1',
        'Calculus',
        'A Very Long Course Name Indeed',
      ];
      for (final String n in names) {
        expect(courseBadge(n).length, lessThanOrEqualTo(4));
      }
    });
  });
}
