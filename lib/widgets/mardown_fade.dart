import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class AnimatedMarkdown extends StatefulWidget {
  final List<String> markdownChunks;
  final Duration wordFadeDuration;
  final Duration wordFadeDelay;
  final String defaultMessage;

  const AnimatedMarkdown({
    Key? key,
    required this.markdownChunks,
    this.wordFadeDuration = const Duration(milliseconds: 500),
    this.wordFadeDelay = const Duration(milliseconds: 100),
    this.defaultMessage =
        "### Problem\n\nWe're building an LLM based tool for one of our FilledStacks clients.",
  }) : super(key: key);

  @override
  State<AnimatedMarkdown> createState() => _AnimatedMarkdownState();
}

class _AnimatedMarkdownState extends State<AnimatedMarkdown> {
  List<String> displayedChunks = [];
  int currentChunkIndex = 0;
  bool isDefaultMessageDisplayed = true;
  void addNextChunk() {
    if (currentChunkIndex < widget.markdownChunks.length) {
      setState(() {
        if (isDefaultMessageDisplayed) {
          displayedChunks.clear();
          isDefaultMessageDisplayed = false;
        }

        // Create a RegExp to check if the last chunk ends with punctuation
        final punctuationRegExp = RegExp(r'[.:”]$');

        // Check if the last chunk exists and does not end with punctuation
        if (displayedChunks.isNotEmpty &&
            !punctuationRegExp.hasMatch(displayedChunks.last.trim())) {
          // Merge current chunk with the last one
          displayedChunks[displayedChunks.length - 1] +=
              widget.markdownChunks[currentChunkIndex];
        } else {
          // Add the next chunk as a separate entry
          displayedChunks.add(widget.markdownChunks[currentChunkIndex]);
        }

        // Increment the current chunk index after updating the state
        currentChunkIndex++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    displayedChunks.add(widget.defaultMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              child: AnimatedMarkdownBody(
                data: displayedChunks.join('\n'),
                wordFadeDuration: widget.wordFadeDuration,
                wordFadeDelay: widget.wordFadeDelay,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNextChunk,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AnimatedMarkdownBody extends StatelessWidget {
  final String data;
  final Duration wordFadeDuration;
  final Duration wordFadeDelay;

  const AnimatedMarkdownBody({
    Key? key,
    required this.data,
    required this.wordFadeDuration,
    required this.wordFadeDelay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styleSheet = MarkdownStyleSheet(
      h1: theme.textTheme.headlineLarge,
      h2: theme.textTheme.headlineMedium,
      h3: theme.textTheme.headlineSmall,
      h4: theme.textTheme.titleLarge,
      h5: theme.textTheme.titleMedium,
      h6: theme.textTheme.titleSmall,
      p: theme.textTheme.bodyMedium,
      strong: TextStyle(fontWeight: FontWeight.bold),
      em: TextStyle(fontStyle: FontStyle.italic),
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: Colors.grey.shade700,
        fontStyle: FontStyle.italic,
      ),
      code: TextStyle(
        fontFamily: 'Courier',
        backgroundColor: Colors.grey.shade200,
      ),
    );

    return MarkdownBody(
      data: data,
      styleSheet: styleSheet,
      builders: {
        'p': AnimatedParagraphBuilder(
          fadeDuration: wordFadeDuration,
          fadeDelay: wordFadeDelay,
        ),
        'h1': AnimatedHeaderBuilder(
          fadeDuration: wordFadeDuration,
          fadeDelay: wordFadeDelay,
          textStyle: styleSheet.h1,
        ),
        'h2': AnimatedHeaderBuilder(
          fadeDuration: wordFadeDuration,
          fadeDelay: wordFadeDelay,
          textStyle: styleSheet.h2,
        ),
        'h3': AnimatedHeaderBuilder(
          fadeDuration: wordFadeDuration,
          fadeDelay: wordFadeDelay,
          textStyle: styleSheet.h3,
        ),
        'strong': AnimatedStrongTextBuilder(
          fadeDuration: wordFadeDuration,
          fadeDelay: wordFadeDelay,
        ),
      },
    );
  }
}

class AnimatedHeaderBuilder extends MarkdownElementBuilder {
  final Duration fadeDuration;
  final Duration fadeDelay;
  final TextStyle? textStyle;

  AnimatedHeaderBuilder({
    required this.fadeDuration,
    required this.fadeDelay,
    this.textStyle,
  });

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return AnimatedWords(
      text: text.text,
      style: textStyle ?? preferredStyle,
      fadeDuration: fadeDuration,
      fadeDelay: fadeDelay,
    );
  }
}

class AnimatedStrongTextBuilder extends MarkdownElementBuilder {
  final Duration fadeDuration;
  final Duration fadeDelay;

  AnimatedStrongTextBuilder({
    required this.fadeDuration,
    required this.fadeDelay,
  });

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return AnimatedWords(
      text: text.text,
      style: preferredStyle?.copyWith(fontWeight: FontWeight.bold),
      fadeDuration: fadeDuration,
      fadeDelay: fadeDelay,
    );
  }
}

class AnimatedParagraphBuilder extends MarkdownElementBuilder {
  final Duration fadeDuration;
  final Duration fadeDelay;

  AnimatedParagraphBuilder({
    required this.fadeDuration,
    required this.fadeDelay,
  });

  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    return AnimatedWords(
      text: text.text,
      style: preferredStyle,
      fadeDuration: fadeDuration,
      fadeDelay: fadeDelay,
    );
  }
}

class AnimatedWords extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration fadeDuration;
  final Duration fadeDelay;

  const AnimatedWords({
    Key? key,
    required this.text,
    this.style,
    required this.fadeDuration,
    required this.fadeDelay,
  }) : super(key: key);

  @override
  _AnimatedWordsState createState() => _AnimatedWordsState();
}

class _AnimatedWordsState extends State<AnimatedWords>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Animation<double>> _fadeAnimations = [];
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    _controller = AnimationController(
      vsync: this,
      duration: widget.fadeDuration + (widget.fadeDelay * _words.length),
    );

    for (int i = 0; i < _words.length; i++) {
      final start = i *
          widget.fadeDelay.inMilliseconds /
          _controller.duration!.inMilliseconds;
      final end = start +
          widget.fadeDuration.inMilliseconds /
              _controller.duration!.inMilliseconds;
      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, end, curve: Curves.easeInOut),
          ),
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _words.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        return FadeTransition(
          opacity: _fadeAnimations[index],
          child: Text(
            '$word ',
            style: widget.style,
          ),
        );
      }).toList(),
    );
  }
}
