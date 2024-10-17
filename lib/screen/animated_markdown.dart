import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:markdown_fade/utils/colors.dart';
import 'package:markdown_fade/utils/styles.dart';

/// [AnimatedFadeText] Widget
class AnimatedFadeText extends StatefulWidget {
  final List<String> markdownTexts;
  final Duration animationDuration;

  const AnimatedFadeText({
    super.key,
    required this.markdownTexts,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  AnimatedFadeTextState createState() => AnimatedFadeTextState();
}

class AnimatedFadeTextState extends State<AnimatedFadeText>
    with TickerProviderStateMixin {
  final List<String> _displayedLines = [];
  int _currentLineIndex = 0;
  bool _isAnimating = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> playAnimation() async {
    if (_currentLineIndex < widget.markdownTexts.length && !_isAnimating) {
      setState(() {
        _isAnimating = true;

        /// Add the new line before starting the animation
        _displayedLines.add(widget.markdownTexts[_currentLineIndex]);
        _currentLineIndex++;
      });

      /// Start the fade-in animation for the new text
      await _fadeInNewText();
      setState(() {
        _isAnimating = false;
      });
    }
  }

  Future<void> _fadeInNewText() async {
    await _controller.forward();

    /// Run the fade-in animation for the new chunk
    _controller.reset();

    /// Reset the controller for the next addition
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

                      /// Now we are applying AnimatedOpacity only to the latest added text
                      return index == _displayedLines.length - 1 && _isAnimating
                          ? AnimatedOpacity(
                              opacity: _animation.value,
                              duration: widget.animationDuration,
                              child: MarkdownBody(
                                data: line,
                                styleSheet: markDownStyle,
                              ),
                            )
                          : MarkdownBody(
                              data: line, // Already visible text (no animation)
                              styleSheet: markDownStyle,
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
          playAnimation(); // Trigger animation for new chunk on FAB tap
        },
        tooltip: 'Add Text',
        child: const Icon(Icons.add),
      ),
    );
  }
}
