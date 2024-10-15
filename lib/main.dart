import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';

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
  List<String> fullTextSections = [];
  List<Widget> textWidgets = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() {
    for (String chunk in markdownCunks) {
      // Detect if the chunk contains a double newline (\n\n) indicating an empty line.
      if (chunk.contains('\n\n')) {
        // Split the chunk at each instance of double newline (\n\n).
        List<String> parts = chunk.split('\n\n');

        for (int i = 0; i < parts.length; i++) {
          String part = parts[i];

          // Add the text part.
          if (part.isNotEmpty) {
            fullTextSections.add(part);
          }

          // Add an empty string after each part except the last one to represent the blank line.
          if (i < parts.length - 1) {
            fullTextSections.add('');
          }
        }
      } else {
        // If no double newline is found, add the chunk as is.
        fullTextSections.add(chunk);
      }
    }

    setState(() {});
  }

  void _addMarkdown() {
    if (currentIndex == fullTextSections.length) {
      currentIndex = 0;
    }

    if (currentIndex < fullTextSections.length) {
      String txt = currentIndex == 0
          ? fullTextSections[currentIndex]
          : fullTextSections[currentIndex]
              .replaceAll(fullTextSections[currentIndex - 1], "");

      setState(() {
        List<Widget> widgets = [];
        if (txt.isEmpty) {
          print("ah");
          widgets.add(SizedBox(
            height: 2,
            width: double.infinity,
          ));
        }
        widgets.add(
          MarkdownBody(data: txt)
              .animate()
              .fade(duration: const Duration(milliseconds: 800)),
        );
        textWidgets.addAll(widgets);
        currentIndex++;
      });
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
          child: Wrap(
            spacing: 3.0,
            runSpacing: 4.0,
            children: textWidgets,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarkdown,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
