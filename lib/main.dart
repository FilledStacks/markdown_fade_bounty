import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'dart:async'; // Import this

const markdownCunks = [
  '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. 
  ''',
  '''
As with ChatGPT, the response from the LLM is streamed back to us.
  ''',
  '''
The text comes back as it 
  ''',
  '''
is being completed. 
  ''',
  '''
Here’s an example of how
  ''',
  '''
paragraph would be returned:
  ''',
  '''
**The full paragraph**

“I need every new
  ''',
  '''
word being added to the text to animate i
  ''',
  '''
n using a fade functionality. This an
  ''',
  '''
example of this can be seen when using Gemini chat.” 
  ''',
  '''
**How it’s returned**

“I need”
  ''',
  '''
“I need every new word”
  ''',
  '''
“I need every new word
  ''',
  '''
being added to”
  ''',
  '''
“I need every new word being
  ''',
  '''
added to the text”
  ''',
  '''
“I need every new word being added to the text to animate in”
  ''',
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class FadingText extends StatefulWidget {
  final String text;

  const FadingText({super.key, required this.text});

  @override
  State<FadingText> createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeIn();
  }

  void _fadeIn() {
    Future.delayed(const Duration(microseconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 1),
      child: MarkdownBody(data: widget.text),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _markdownTexts = [];
  int _markdownIndex = 0;
  Timer? _timer;

  void _startAddingMarkdown() {
    _timer?.cancel(); // Cancel any existing timer

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_markdownIndex < markdownCunks.length) {
        setState(() {
          _markdownTexts.add(markdownCunks[_markdownIndex]);
          _markdownIndex++;
        });
      } else {
        _timer?.cancel(); // Stop the timer when all chunks are added
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView.builder(
            itemCount: _markdownTexts.length,
            itemBuilder: (context, index) {
              return FadingText(text: _markdownTexts[index]);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startAddingMarkdown,
        tooltip: 'Start Adding Markdown',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
