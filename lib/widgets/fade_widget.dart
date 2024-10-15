import 'package:flutter/material.dart';

class FadeWordWidget extends StatefulWidget {
  const FadeWordWidget({
    super.key,
    required this.word,
    required this.delay,
    required this.style,
  });
  final String word;
  final Duration delay;
  final TextStyle style;
  @override
  State<FadeWordWidget> createState() => _FadeWordWidgetState();
}

class _FadeWordWidgetState extends State<FadeWordWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(widget.delay, () {
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Text(widget.word, style: widget.style),
        );
      },
    );
  }
}
