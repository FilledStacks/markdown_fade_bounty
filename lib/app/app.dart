import 'package:flutter/material.dart';
import 'package:markdown_fade/screen/animated_markdown.dart';
import 'package:markdown_fade/utils/markdown_text.dart';

class MarkDownApp extends StatefulWidget {
  const MarkDownApp({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MarkDownApp> createState() => _MarkDownAppState();
}

class _MarkDownAppState extends State<MarkDownApp> {
  late AnimatedFadeText _animatedFadeText;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimatedFadeText instance
    _animatedFadeText = const AnimatedFadeText(
      markdownTexts: markdownWords,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: _animatedFadeText,
      ),
    );
  }
}
