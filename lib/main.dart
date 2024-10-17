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
  List<String> _words = [];

  final List<String> markdownChunks = [
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

  void _startAddingMarkdown() {
    _markdownIndex = 0; // Reset index
    _currentMarkdown = ''; // Reset current markdown
    _words = _splitMarkdownIntoWords(markdownChunks); // Split into words
    _addNextWord(); // Start adding words
  }

  List<String> _splitMarkdownIntoWords(List<String> chunks) {
    return chunks.join(' ').split(' ');
  }

  void _addNextWord() {
    if (_markdownIndex < _words.length) {
      setState(() {
        // Append the next word
        if (_currentMarkdown.isNotEmpty) {
          _currentMarkdown += ' '; // Add space before next word
        }
        _currentMarkdown += _words[_markdownIndex];
      });

      // Move to the next word after a delay
      _markdownIndex++;
      Future.delayed(const Duration(milliseconds: 1000), _addNextWord);
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
