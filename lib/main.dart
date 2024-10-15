import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:markdown_fade/widgets/mardown_fade.dart';

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

const defaultMessage = 'Tap FAB to add markdown';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
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
  String _currentMarkdown = defaultMessage;
  int _markdownIndex = 0;

  void _addMarkdown() {
    setState(() {
      if (_currentMarkdown == defaultMessage) {
        _currentMarkdown = markdownChunks[_markdownIndex];
      } else {
        _currentMarkdown += markdownChunks[_markdownIndex];
      }

      _markdownIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedMarkdown(
            markdownChunks: markdownChunks,
            chunkFadeDuration: Duration(milliseconds: 500),
            chunkFadeDelay: Duration(milliseconds: 100),
          ),
        ),
      ),
    );
    //   Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //       title: Text(widget.title),
    //     ),
    //     body: Center(
    //         child: ConstrainedBox(
    //       constraints: const BoxConstraints(maxWidth: 700),
    //       child: MarkdownBody(
    //         data: _currentMarkdown,
    //       ),
    //     )),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: _addMarkdown,
    //       tooltip: 'Increment',
    //       child: const Icon(Icons.add),
    //     ),
    //   );
    // }
  }
}
