import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trying/screens/course_badge.dart';

void main() {
  group('course subject', () {
    test('maths and statistics courses', () {
      // The two courses the backend actually serves.
      expect(courseSubject('AP Statistics'), CourseSubject.math);
      expect(courseSubject('Statistics with Algebra'), CourseSubject.math);
      // Plausible siblings.
      expect(courseSubject('AP Calculus BC'), CourseSubject.math);
      expect(courseSubject('Geometry'), CourseSubject.math);
    });

    test('computer science courses', () {
      expect(courseSubject('APCS-A'), CourseSubject.computerScience);
      expect(courseSubject('APCS-P'), CourseSubject.computerScience);
      expect(courseSubject('Intro to Programming'),
          CourseSubject.computerScience);
    });

    test('language courses', () {
      expect(courseSubject('Latin-1'), CourseSubject.language);
      expect(courseSubject('Spanish 3'), CourseSubject.language);
      expect(courseSubject('AP English Literature'), CourseSubject.language);
    });

    test('computer science wins when a name could read either way', () {
      // "APCS" contains no maths keyword, but a combined name should not be
      // classified as maths just because "stat" appears later.
      expect(courseSubject('CS Statistics'), CourseSubject.computerScience);
    });

    test('"cs" does not match inside an unrelated word', () {
      // The regression this guards: a naive contains('cs') classified
      // "Physics" as computer science.
      expect(courseSubject('Physics'), isNot(CourseSubject.computerScience));
      expect(courseSubject('Economics'), isNot(CourseSubject.computerScience));
    });

    test('unrecognised subjects fall back to initials', () {
      expect(courseSubject('Ceramics'), CourseSubject.other);
      expect(courseSubjectIcon(CourseSubject.other), isNull);
      expect(courseBadge('Ceramics'), 'CER');
    });

    test('every recognised subject has a distinct icon', () {
      final List<IconData?> icons = <IconData?>[
        courseSubjectIcon(CourseSubject.math),
        courseSubjectIcon(CourseSubject.computerScience),
        courseSubjectIcon(CourseSubject.language),
      ];
      expect(icons, everyElement(isNotNull));
      expect(icons.toSet().length, 3);
    });
  });

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
