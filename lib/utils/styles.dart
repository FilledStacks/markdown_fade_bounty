import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:markdown_fade/utils/colors.dart';

final markDownStyle = MarkdownStyleSheet(
  h1: const TextStyle(
    fontSize: 32,
    color: textColor,
    fontWeight: FontWeight.bold,
    wordSpacing: 2.0,
  ),
  p: const TextStyle(
    fontSize: 18,
    color: textColor,
    wordSpacing: 2.0,
  ),
  strong: const TextStyle(fontWeight: FontWeight.bold),
  em: const TextStyle(fontStyle: FontStyle.italic),
  code: TextStyle(
    backgroundColor: Colors.teal.shade100,
  ),
);
