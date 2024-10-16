import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';

import 'animated_text.dart';

class GeminiLikeTextEditor extends StatefulWidget {
  const GeminiLikeTextEditor({super.key});

  @override
  State<GeminiLikeTextEditor> createState() => _HomeUIState();
}

class _HomeUIState extends State<GeminiLikeTextEditor> {
  List<AnimatedText> animatedTextList = [];
  int dataIndex = 0;
  double opacity = 0.0;

  void _addNextData() {
    if (dataIndex < dataList.length) {
      animatedTextList.add(AnimatedText(
        text: dataList[dataIndex],
        opacity: 0.0,
      ));
      dataIndex++;

      setState(() {
        Timer(const Duration(milliseconds: 100), () {
          setState(() {
            animatedTextList.last.opacity = 1.0;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Gemini Like Text Editor"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "TAPPED ON ITEM INDEX: $dataIndex",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              if (dataIndex == dataList.length) ...[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "COMPLETED",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
              const SizedBox(
                height: 50,
              ),
              if (animatedTextList.isNotEmpty)
                Wrap(
                  spacing: 1.2,
                  children: animatedTextList.map((animatedText) {
                    return AnimatedOpacity(
                      opacity: animatedText.opacity,
                      duration: const Duration(seconds: 1),
                      child: MarkdownBody(
                        data: animatedText.text,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNextData,
        tooltip: 'Add Next Markdown',
        child: const Icon(Icons.add),
      ),
    );
  }
}

const dataList = [
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
