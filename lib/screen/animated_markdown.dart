import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:markdown_fade/utils/colors.dart';
import 'package:markdown_fade/utils/styles.dart';

class AnimatedFadeText extends StatefulWidget {
  final List<String> markdownTexts;
  final Duration animationDuration;

  const AnimatedFadeText({
    super.key,
    required this.markdownTexts,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  AnimatedFadeTextState createState() => AnimatedFadeTextState();
}

class AnimatedFadeTextState extends State<AnimatedFadeText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _staggerController;
  String _currentMarkdownContent = '';
  int _wordIndex = 0;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration * widget.markdownTexts.length,
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
  }

  Future<void> playAnimation() async {
    while (_wordIndex < widget.markdownTexts.length) {
      setState(() {
        _currentMarkdownContent += '${widget.markdownTexts[_wordIndex]} ';
        _wordIndex++;
      });

      await Future.delayed(const Duration(milliseconds: 50));

      setState(() {
        _opacity += 0.05;
        if (_opacity > 1.0) _opacity = 1.0;
      });

      _staggerController.forward();
      await _staggerController.reverse();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacity,
              child: SelectionArea(
                child: AnimatedBuilder(
                  animation: _staggerController,
                  builder: (context, child) {
                    return MarkdownBody(
                      data: _currentMarkdownContent,
                      styleSheet: markDownStyle,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          playAnimation();
        },
        tooltip: 'Ask',
        child: const Icon(Icons.send),
      ),
    );
  }
}
