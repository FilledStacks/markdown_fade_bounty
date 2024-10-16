import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'dart:async';

typedef ChunkWidgetBuilder = Widget Function(
    BuildContext context, TextChunk text);

class FadeStreamingText extends StatefulWidget {
  /// The stream of text to display. If this is provided, [staticMarkdown] must be null.
  ///
  /// The text will be displayed as it is streamed in, with each new line of text fading in.
  ///
  /// When the stream is done, the entire text will be displayed without any fading.
  ///
  /// If you want to display static markdown, use [staticMarkdown] instead.
  final Stream<String>? textStream;

  /// The static markdown to display. If this is provided, [textStream] must be null.
  ///
  /// The text will be displayed all at once, with a fade in effect.
  ///
  /// If you want to display streaming text, use [textStream] instead.
  ///
  /// If you want to display markdown with a delimiter other than '\n', use [delimiter].
  final String? staticMarkdown;

  /// The style sheet to use for the markdown.
  ///
  /// If this is null, the default markdown style sheet will be used.
  ///
  /// If you want to customize the style of the markdown, you can provide your own style sheet.
  final MarkdownStyleSheet? styleSheet;

  /// The delimiter to use for the markdown.
  ///
  /// This is used to determine how to render the markdown.
  ///
  /// If the delimiter is '\n', the markdown will be rendered as a body of text.
  ///
  final String delimiter;

  /// The delay between each chunk of text.
  ///
  /// This is used to determine how long to wait before displaying the next chunk of text.
  ///
  /// If this is null, the default delay of 20 milliseconds will be used.
  ///
  final Duration? delay;

  /// The duration of the fade in effect.
  ///
  /// This is used to determine how long to wait before displaying the next chunk of text.
  ///
  /// If this is null, the default duration of 500 milliseconds will be used.
  ///
  /// If you want to customize the duration of the fade in effect, you can provide your own duration.
  final Duration? fadeInDuration;

  /// The builder to use for each chunk of text.
  ///
  /// This is used to determine how to render each chunk of text.
  ///
  /// If this is null, the default builder will be used.
  ///
  /// If you want to customize the builder, you can provide your own builder.
  ///
  /// The builder takes a [BuildContext] and a [TextChunk] as arguments.
  ///
  /// The [BuildContext] is used to build the widget.
  ///
  /// The [TextChunk] is used to determine the text to display and the animation controller to use.
  ///
  /// The builder should return a widget that displays the text.
  ///
  /// If you want to display the text as a body of text, you can use the [MarkdownBody] widget.
  ///
  final ChunkWidgetBuilder? chunkWidgetBuilder;

  const FadeStreamingText({
    super.key,
    this.textStream,
    this.staticMarkdown,
    this.styleSheet,
    this.delimiter = '',
    this.delay = const Duration(milliseconds: 20),
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.chunkWidgetBuilder,
  }) : assert((textStream == null) ^ (staticMarkdown == null),
            'You must provide either a text stream or static markdown, but not both.');

  @override
  FadeStreamingTextState createState() => FadeStreamingTextState();
}

class FadeStreamingTextState extends State<FadeStreamingText>
    with TickerProviderStateMixin {
  final List<TextChunk> _textChunks = [];
  StreamSubscription<String>? _subscription;
  String _completeText = '';
  bool _isStreaming = false;
  late AnimationController _fadeController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: widget.fadeInDuration ?? const Duration(milliseconds: 500),
      vsync: this,
    );

    if (widget.staticMarkdown != null) {
      _completeText = "${widget.staticMarkdown!}\n";
      _fadeController.forward();
    }
    _subscribeToStream(widget.textStream != null);
  }

  void _subscribeToStream(bool listenStream) {
    if (!listenStream) return;
    _subscription = widget.textStream?.listen(
      (newText) {
        setState(() {
          _isStreaming = true;
          _completeText += widget.delimiter + newText;
          _textChunks.add(
            TextChunk(
              (newText),
              AnimationController(
                duration: widget.delay ?? const Duration(milliseconds: 50),
                vsync: this,
              )..forward(),
            ),
          );
          _scrollToBottom();
        });
      },
      onDone: () {
        setState(() {
          _isStreaming = false;
          _disposeChunks();
          _fadeController.forward();
        });
      },
    );
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _disposeChunks() {
    for (var chunk in _textChunks) {
      chunk.controller.dispose();
    }
    _textChunks.clear();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _disposeChunks();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _renderMarkDownBasedOnDelimiter(String text) {
    if (widget.delimiter != '\n') {
      return MarkdownBody(
        data: text,
        styleSheet: widget.styleSheet,
        shrinkWrap: true,
      );
    }

    return Markdown(
      data: text,
      styleSheet: widget.styleSheet,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isStreaming
        ? SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                children: _textChunks.map((chunk) {
                  if (widget.chunkWidgetBuilder != null) {
                    return widget.chunkWidgetBuilder!(context, chunk);
                  }
                  return FadeTransition(
                    opacity: chunk.controller,
                    key: UniqueKey(),
                    child: _renderMarkDownBasedOnDelimiter(chunk.text),
                  );
                }).toList(),
              ),
            ))
        : FadeTransition(
            opacity: _fadeController,
            child: SelectionArea(
              child: Markdown(
                data: _completeText,
                styleSheet: widget.styleSheet,
                controller: _scrollController,
                shrinkWrap: true,
                key: ValueKey(_completeText),
              ),
            ),
          );
  }
}

class TextChunk {
  final String text;
  final AnimationController controller;

  TextChunk(this.text, this.controller);
}
