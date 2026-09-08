/// Formatting for the course row badge.
///
/// Kept free of imports so it can be unit-tested: anything reaching into
/// main.dart pulls in path_provider, whose pinned win32 5.0.6 no longer
/// compiles under Dart 3.13.
library;

/// Short label for the row badge.
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
