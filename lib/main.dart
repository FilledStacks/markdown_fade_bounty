import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'dart:async';
import 'package:typewritertext/typewritertext.dart';

const markdownChunks = [
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
word being added to the text to animate in
  ''',
  '''
using a fade functionality. This an
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

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _markdownTexts = [];
  int _markdownIndex = 0;
  Timer? _timer;

  void _startAddingMarkdown() {
    _timer?.cancel(); // Cancel any existing timer
    _markdownIndex = 0; // Reset index to start from the beginning
    _addNextChunk(); // Start adding markdown chunks
  }

  void _addNextChunk() {
    if (_markdownIndex < markdownChunks.length) {
      _typewriteMarkdown(markdownChunks[_markdownIndex]).then((_) {
        _markdownIndex++;
        _addNextChunk(); // Recursively add the next chunk after the current one finishes
      });
    }
  }

  Future<void> _typewriteMarkdown(String markdownChunk) async {
    final controller = TypeWriterController(
      text: markdownChunk,
      duration: const Duration(milliseconds: 50),
    );

    setState(() {
      _markdownTexts
          .add(markdownChunk); // Add the full chunk initially for display
    });

    // Simulate typing by waiting for the entire text to be typed
    await Future.delayed(Duration(
        milliseconds:
            50 * markdownChunk.length)); // Adjust based on text length
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
              return TypeWriter(
                controller: TypeWriterController(
                  text: _markdownTexts[index],
                  duration: const Duration(milliseconds: 50),
                ),
                builder: (context, value) {
                  return MarkdownBody(
                    data: value.text,
                  );
                },
              );
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
