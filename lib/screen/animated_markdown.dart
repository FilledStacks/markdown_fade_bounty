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
  final List<String> _displayedLines = [];
  int _currentLineIndex = 0;
  double _opacity = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 250), // You can adjust duration as needed
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 1.0,
      ),
    ]).animate(_controller);
    _animation.addStatusListener((status) {});
  }

  Future<void> playAnimation() async {
    while (_currentLineIndex < widget.markdownTexts.length) {
      setState(() {
        _displayedLines.add(widget.markdownTexts[_currentLineIndex]);
        _currentLineIndex++;
      });

      await _fadeInNewline();
    }
  }

  Future<void> _fadeInNewline() async {
    _animation.addListener(() {
      setState(() {
        _opacity = _animation.value;
      });
    });

    await _controller.forward();
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: SelectionArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _displayedLines.asMap().entries.map((entry) {
                      int index = entry.key;
                      String line = entry.value;
                      return ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black,
                              Colors.black,
                              index == _displayedLines.length - 1
                                  ? Colors.black.withOpacity(_opacity)
                                  : Colors.black,
                            ],
                            stops: const [
                              0.2,
                              0.1,
                              0.9,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: MarkdownBody(
                          data: line,
                          styleSheet: markDownStyle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
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
