import 'dart:async';

import 'package:flutter/material.dart';
import 'package:markdown_fade/widget/fade_streaming_text.dart';

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
  '''
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
  int _markdownIndex = 0;

  final StreamController<String> _markdownStream = StreamController<String>();

  String _completeText = '';

  void _addMarkdown() async {
    if (_markdownIndex < markdownCunks.length) {
      _completeText += markdownCunks[_markdownIndex];
      _markdownStream.add(_completeText);
      _markdownIndex++;
    } else {
      _markdownStream.close();
    }
  }

  @override
  void initState() {
    // Uncomment to add markdown in intervals to mimic real-time data

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _addMarkdown();
    });
    super.initState();
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
          child: FadeStreamingText(
            textStream: _markdownStream.stream,
            delay: const Duration(milliseconds: 800),
            fadeInDuration: const Duration(milliseconds: 400),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addMarkdown();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

List<String> markdownContent = [
  "# Markdown Example",
  "\n",
  "Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.",
  "\n",
  "## Titles",
  "\n",
  "Setext-style",
  "\n",
  "```\nThis is an H1\n=============\n\nThis is an H2\n-------------\n```",
  "\n",
  "Atx-style",
  "\n",
  "```\n# This is an H1\n\n## This is an H2\n\n###### This is an H6\n```",
  "\n",
  "## Links",
  "\n",
  "[Google's Homepage][Google]",
  "\n",
  "```\n[inline-style](https://www.google.com)\n\n[reference-style][Google]\n```",
  "\n",
  "## Images",
  "\n",
  "![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)",
  "\n",
  "## Tables",
  "\n",
  "\n| Syntax                                 | Result                               |",
  "\n|---------------------------------------|-------------------------------------|",
  "\n| `*italic 1*`                           | *italic 1*                           |",
  "\n| `_italic 2_`                           | _italic 2_                          |",
  "\n| `**bold 1**`                           | **bold 1**                           |",
  "\n| `__bold 2__`                           | __bold 2__                           |",
  "\n| `This is a ~~strikethrough~~`         | This is a ~~strikethrough~~         |",
  "\n| `***italic bold 1***`                  | ***italic bold 1***                 |",
  "\n| `___italic bold 2___`                  | ___italic bold 2___                 |",
  "\n| `***~~italic bold strikethrough 1~~***`| ***~~italic bold strikethrough 1~~***|",
  "\n| `~~***italic bold strikethrough 2***~~`| ~~***italic bold strikethrough 2***~~|",
  "\n",
  "\n## Styling",
  "\n",
  "\nStyle text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.",
  "\n",
  "\n- Use bulleted lists",
  "\n- To better clarify",
  "\n- Your points",
  "\n",
  "\n## Code blocks",
  "\n",
  "\nFormatted Dart code looks really pretty too:",
  "\n",
  "\n```\nvoid main() {\n  runApp(MaterialApp(\n    home: Scaffold(\n      body: Markdown(data: markdownData),\n    ),\n  ));\n}\n```",
  "\n",
  "\n## Center Title",
  "\n",
  "###### ※ ※ ※",
  "\n",
  "_* How to implement it see main.dart#L129 in example._",
  "\n",
  "## Custom Syntax",
  "\n",
  "\nNaOH + Al_2O_3 = NaAlO_2 + H_2O",
  "\n",
  "\nC_4H_10 = C_2H_6 + C_2H_4",
  "\n",
  "\n## Markdown widget",
  "\n",
  "\nThis is an example of how to create your own Markdown widget:",
  "\n",
  "\n    Markdown(data: 'Hello _world_!');",
  "\n",
  "\nEnjoy!",
  "\n",
  "\n[Google]: https://www.google.com/",
  "\n",
  "\n## Line Breaks",
  "\n",
  "\nThis is an example of how to create line breaks (tab or two whitespaces):",
  "\n",
  "\nline 1",
  "\n",
  "\nline 2",
  "\n",
  "\nline 3"
];
