import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';

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
  List<Widget> textWidgets = [];
  String previousText = "";

  // Simulated API response with new text updates.
  List<String> apiResponses = [
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. 
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us.
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. 
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how 
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate i
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an example of this can be seen when using Gemini chat.”
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an example of this can be seen when using Gemini chat.”**How it’s returned**

"I need
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an example of this can be seen when using Gemini chat.”**How it’s returned**

"I need every new word
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an example of this can be seen when using Gemini chat.”**How it’s returned**

"I need every new word being added to
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an example of this can be seen when using Gemini chat.”**How it’s returned**

"I need every new word being added to the text
''',
    '''
### Problem

We’re building an LLM based tool for one of our FilledStacks clients. As with ChatGPT, the response from the LLM is streamed back to us. The text comes back as it is being completed. Here’s an example of how paragraph would be returned:**The full paragraph**

“I need every new word being added to the text to animate in using a fade functionality. This an example of this can be seen when using Gemini chat.”**How it’s returned**

"I need every new word being added to the text to animate in”
''',
  ];

  ScrollController _scrollController = ScrollController();

  String findNewTextPart(String newText, String previousText) {
    int startIndex = 0;

    while (startIndex < newText.length &&
        startIndex < previousText.length &&
        newText[startIndex] == previousText[startIndex]) {
      startIndex++;
    }

    return newText.substring(startIndex);
  }

  Future<void> _simulateApiCall() async {
    // Reset the previousText to start tracking new parts, but don't clear textWidgets
    previousText = "";

    for (String newText in apiResponses) {
      String newPart = findNewTextPart(newText, previousText);
      previousText = newText;
      _processReceivedText(newPart);
      await Future.delayed(const Duration(milliseconds: 400));
      _scrollToEnd();
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _processReceivedText(String newPart) {
    if (newPart.isEmpty) return;

    setState(() {
      List<String> parts = newPart.split('\n\n');
      for (int i = 0; i < parts.length; i++) {
        String part = parts[i];
        if (part.isNotEmpty) {
          textWidgets.add(
            MarkdownBody(
              data: part,
            ).animate().fade(duration: const Duration(milliseconds: 800)),
          );
        }
        if (i < parts.length - 1) {
          textWidgets.add(SizedBox(
            height: 20,
            width: double.infinity,
          ));
        }
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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Wrap(
              spacing: 3.0,
              runSpacing: 4.0,
              children: textWidgets,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simulateApiCall,
        tooltip: 'Start',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
