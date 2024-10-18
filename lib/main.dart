import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';

const markdownChunks = [
  '''I need ''',
  '''I need every new word ''',
  '''I need every new word being added to ''',
  '''I need every new word being added to the text to animate in''',
  ''' '''
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Markdown Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  String _previousMarkdown = '';
  String _newChunk = '';
  int _markdownIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getNewText(String previous, String current) {
    if (current.startsWith(previous)) {
      String newPart = current.substring(previous.length);
      // Preserve leading space if it exists
      return newPart;
    }
    return current; // Return full string if not found (edge case)
  }

  void _addMarkdown() {
    if (_markdownIndex < markdownChunks.length) {
      setState(() {
        // Update the previous markdown
        if (_newChunk.isNotEmpty) {
          _previousMarkdown += _newChunk;
        }

        // Get the new chunk of text
        _newChunk = markdownChunks[_markdownIndex];

        // Extract only the new part to animate
        _newChunk = _getNewText(_previousMarkdown, _newChunk);

        _markdownIndex++;
      });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Markdown Animation'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Static previous text in markdown format
              MarkdownBody(
                data: _previousMarkdown.trim(),
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 18),
                ),
              ),
              // Animated new chunk with fade transition
              FadeTransition(
                opacity: _animation,
                child: MarkdownBody(
                  data: _newChunk.trim(), // Only animate the new part
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarkdown,
        tooltip: 'Add Markdown',
        child: const Icon(Icons.add),
      ),
    );
  }
}
