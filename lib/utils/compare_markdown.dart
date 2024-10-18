import 'package:diff_match_patch/diff_match_patch.dart';

String compareMarkdown(String oldMarkdown, String newMarkdown) {
  final dmp = DiffMatchPatch();
  final diffs = dmp.diff(oldMarkdown, newMarkdown);

  StringBuffer result = StringBuffer();

  for (final diff in diffs) {
    if (diff.operation == DIFF_INSERT) {
      result.writeln(diff.text);
    } else if (diff.operation == DIFF_DELETE) {
      result.writeln('- ${diff.text}');
    }
  }

  return result.toString().trim();
}
