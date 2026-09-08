import 'package:flutter/material.dart';

/// What a course is, as far as the row badge is concerned.
///
/// Courses are matched by name because that is all the backend gives us — the
/// unit files carry no subject field.
enum CourseSubject {
  /// Maths and statistics.
  math,

  /// Computer science.
  computerScience,

  /// Languages.
  language,

  /// Anything unrecognised; these fall back to [courseBadge] initials.
  other,
}

/// Word-boundary match, so "cs" does not fire on "Physics".
bool _hasWord(String haystack, String word) =>
    RegExp('(^|[^a-z])$word([^a-z]|\$)').hasMatch(haystack);

bool _hasAny(String haystack, List<String> words) =>
    words.any((String w) => _hasWord(haystack, w));

/// Classifies [course] so its row can show a subject icon.
///
/// Computer science is checked first: "APCS-A" would otherwise never be seen,
/// and a name like "CS Statistics" should read as computing.
CourseSubject courseSubject(String course) {
  final String name = course.toLowerCase();

  if (_hasAny(name, <String>['cs', 'apcs', 'comp', 'computer', 'computing']) ||
      name.contains('programming') ||
      name.contains('software')) {
    return CourseSubject.computerScience;
  }

  if (name.contains('stat') ||
      name.contains('algebra') ||
      name.contains('math') ||
      name.contains('calculus') ||
      name.contains('geometry') ||
      name.contains('trigonometry') ||
      _hasWord(name, 'calc')) {
    return CourseSubject.math;
  }

  if (_hasAny(name, <String>[
        'latin',
        'spanish',
        'french',
        'german',
        'chinese',
        'mandarin',
        'japanese',
        'italian',
        'greek',
        'english',
        'language',
      ]) ||
      name.contains('literature')) {
    return CourseSubject.language;
  }

  return CourseSubject.other;
}

/// The icon for a subject, or null when it should fall back to initials.
IconData? courseSubjectIcon(CourseSubject subject) {
  switch (subject) {
    case CourseSubject.math:
      return Icons.calculate_rounded;
    case CourseSubject.computerScience:
      return Icons.computer_rounded;
    case CourseSubject.language:
      return Icons.translate_rounded;
    case CourseSubject.other:
      return null;
  }
}

/// Short label for the row badge, used when no subject icon applies.
///
/// A course that already starts with an acronym keeps it, since initialising
/// it again reads worse ("AP Statistics" would become "AS"). Otherwise the
/// initials of each word are used.
///
///   "AP Statistics"           -> "AP"
///   "APCS-A"                  -> "APCS"
///   "Statistics with Algebra" -> "SWA"
///   "Latin-1"                 -> "L1"
String courseBadge(String course) {
  final List<String> words = course
      .split(RegExp(r'[\s\-_]+'))
      .where((String w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return '?';

  final String first = words.first;
  final bool isAcronym = first.length >= 2 &&
      first.length <= 4 &&
      first == first.toUpperCase() &&
      RegExp(r'^[A-Z]+$').hasMatch(first);
  if (isAcronym) return first;

  if (words.length == 1) {
    return first.substring(0, first.length < 3 ? first.length : 3)
        .toUpperCase();
  }
  return words
      .take(3)
      .map((String w) => w.substring(0, 1).toUpperCase())
      .join();
}
