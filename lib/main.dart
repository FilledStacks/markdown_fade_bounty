import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markdown Streaming Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Markdown Streaming Home Page'),
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
  String _currentMarkdown = '';
  int _markdownIndex = 0;

  final List<String> markdownChunks = [
    '## Problem\n\nThis is',
    '## Problem\n\nThis is the main issue with what',
    '## Problem\n\nThis is the main issue with what we\'re trying to solve.',
    // Add more chunks if necessary
  ];

  void _startAddingMarkdown() {
    _markdownIndex = 0; // Reset index
    _currentMarkdown = ''; // Reset current markdown
    _addNextChunk(); // Start adding markdown chunks
  }

  void _addNextChunk() {
    if (_markdownIndex < markdownChunks.length) {
      setState(() {
        _currentMarkdown =
            markdownChunks[_markdownIndex]; // Update the single string
      });

      // Move to the next chunk after a delay
      _markdownIndex++;
      Future.delayed(const Duration(milliseconds: 1000), _addNextChunk);
    }
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
          child: AnimatedOpacity(
            opacity: _currentMarkdown.isEmpty ? 0 : 1,
            duration: const Duration(milliseconds: 500),
            child: MarkdownBody(
              data: _currentMarkdown,
            ),
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
