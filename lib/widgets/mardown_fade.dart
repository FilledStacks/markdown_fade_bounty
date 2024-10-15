import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class AnimatedMarkdown extends StatefulWidget {
  // This widget takes markdown text chunks and animates them into the UI.
  final List<String> markdownChunks; // List of markdown chunks to display.
  final Duration
      chunkFadeDuration; // Duration for how long each chunk will fade in.
  final Duration chunkFadeDelay; // Delay between each chunk fading in.

  const AnimatedMarkdown({
    super.key,
    required this.markdownChunks,
    this.chunkFadeDuration =
        const Duration(milliseconds: 500), // Default fade duration.
    this.chunkFadeDelay = const Duration(
        milliseconds: 100), // Default delay between chunk animations.
  });

  @override
  State<AnimatedMarkdown> createState() => _AnimatedMarkdownState();
}

class _AnimatedMarkdownState extends State<AnimatedMarkdown> {
  List<String> displayedChunks = [];
  bool isAnimating = false; // Flag to check if animation is running.

  // Method to start the animation of the markdown chunks.
  void startAnimation() {
    if (isAnimating)
      return; // Prevents restarting if the animation is already running.
    setState(() {
      isAnimating = true;
      displayedChunks = []; // Reset displayed chunks at the start.
    });

    animateChunks(0); // Start animating chunks from the first one.
  }

  // Recursive method to animate each chunk in the list.
  void animateChunks(int index) {
    if (index >= widget.markdownChunks.length) {
      // Stop animation when all chunks are displayed.
      setState(() {
        isAnimating = false;
      });
      return;
    }

    // Delay the addition of the next chunk for smooth animation.
    Future.delayed(widget.chunkFadeDelay, () {
      if (mounted) {
        // Check if the widget is still in the tree.
        setState(() {
          displayedChunks
              .add(widget.markdownChunks[index]); // Add chunk one by one.
        });
        animateChunks(index + 1); // Move to the next chunk.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          // Button to trigger the animation.
          onPressed: startAnimation,
          child: Text(isAnimating ? 'Animating...' : 'Start Animation'),
        ),
        SizedBox(height: 20), // Adds some spacing.
        Expanded(
          child: SingleChildScrollView(
            // Scrollable area for the animated markdown content.
            child: AnimatedMarkdownBody(
              data: displayedChunks
                  .join('\n'), // Combine displayed chunks with proper spacing.
              chunkFadeDuration:
                  widget.chunkFadeDuration, // Pass animation duration.
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedMarkdownBody extends StatelessWidget {
  // This widget handles the actual rendering of markdown text with animations.
  final String data; // The markdown data to render.
  final Duration chunkFadeDuration; // Duration of the chunk fade-in animations.

  const AnimatedMarkdownBody({
    super.key,
    required this.data,
    required this.chunkFadeDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context); // Use the current theme for consistent styling.

    // Define a style sheet for the markdown elements.
    final styleSheet = MarkdownStyleSheet(
      h1: theme.textTheme.headlineLarge,
      h2: theme.textTheme.headlineMedium,
      h3: theme.textTheme.headlineSmall,
      h4: theme.textTheme.titleLarge,
      h5: theme.textTheme.titleMedium,
      h6: theme.textTheme.titleSmall,
      p: theme.textTheme.bodySmall, // Styling for paragraph text.
      strong:
          TextStyle(fontWeight: FontWeight.bold), // Ensure bold text is bold.
      em: TextStyle(
          fontStyle: FontStyle.italic), // Italics for emphasized text.
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.grey.shade700, // Dark gray color for blockquotes.
        fontStyle: FontStyle.italic, // Italic styling for blockquotes.
      ),
      code: TextStyle(
        fontFamily: 'Courier', // Monospace font for code.
        backgroundColor:
            Colors.grey.shade200, // Light gray background for code blocks.
      ),
    );

    // Return the actual MarkdownBody widget, which renders the markdown text with custom builders for animated elements.
    return MarkdownBody(
      data: data, // The markdown content to display.
      builders: {
        'p': AnimatedParagraphBuilder(
            fadeDuration:
                chunkFadeDuration), // Use animated paragraph builder for paragraphs.
        'h1': AnimatedParagraphBuilder(
          fadeDuration: chunkFadeDuration, // Same for headers.
        ),
        'h3': AnimatedHeaderBuilder(
          fadeDuration: chunkFadeDuration,
          textStyle: styleSheet.h3, // Custom style for h3 headers.
        ),
      },
    );
  }
}

class AnimatedHeaderBuilder extends MarkdownElementBuilder {
  final Duration fadeDuration;
  final TextStyle? textStyle;

  AnimatedHeaderBuilder({
    required this.fadeDuration,
    this.textStyle,
  });

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return AnimatedChunk(
      text: text.text,
      style:
          textStyle ?? preferredStyle, // Apply the header style if available.
      duration: fadeDuration,
    );
  }
}

class AnimatedStrongTextBuilder extends MarkdownElementBuilder {
  final Duration fadeDuration;

  AnimatedStrongTextBuilder({required this.fadeDuration});

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return AnimatedChunk(
      text: text.text,
      style: preferredStyle?.copyWith(fontWeight: FontWeight.bold),
      duration: fadeDuration,
    );
  }
}

class AnimatedParagraphBuilder extends MarkdownElementBuilder {
  final Duration fadeDuration;

  AnimatedParagraphBuilder({required this.fadeDuration});

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return AnimatedChunk(
      text: text.text,
      style: preferredStyle,
      duration: fadeDuration,
    );
  }
}

class AnimatedChunk extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const AnimatedChunk({
    super.key,
    required this.text,
    this.style,
    required this.duration,
  });

  @override
  State<AnimatedChunk> createState() => _AnimatedChunkState();
}

class _AnimatedChunkState extends State<AnimatedChunk>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls the animation.
  late Animation<double>
      _opacityAnimation; // Animation for opacity (fading effect).

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration, // Set the duration for the fade animation.
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        _controller); // Opacity goes from transparent to fully visible.
    _controller.forward(); // Start the animation.
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller when the widget is removed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FadeTransition widget animates the opacity of its child.
    return FadeTransition(
      opacity: _opacityAnimation, // Apply the opacity animation to the text.
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}
