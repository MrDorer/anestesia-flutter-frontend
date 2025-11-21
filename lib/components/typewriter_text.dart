import 'dart:async';

import 'package:flutter/material.dart';

/// A simple, dependency-free typewriter text widget.
///
/// Usage: provide [text] and an optional [textStyle] and [durationPerChar].
/// The widget will reveal characters progressively when mounted and when
/// [text] changes. An optional [cursor] shows while animating.
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration durationPerChar;
  final String cursor;
  final VoidCallback? onComplete;
  final Duration startDelay;

  const TypewriterText({
    Key? key,
    required this.text,
    this.textStyle,
    this.durationPerChar = const Duration(milliseconds: 28),
    this.cursor = '|',
    this.onComplete,
    this.startDelay = Duration.zero,
  }) : super(key: key);

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  Timer? _timer;
  int _current = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    // Start after the first frame so layout is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _restart();
    }
  }

  void _start() {
    _timer?.cancel();
    _current = 0;
    _done = false;

    if (widget.text.isEmpty) {
      setState(() {
        _done = true;
      });
      widget.onComplete?.call();
      return;
    }

    Future.delayed(widget.startDelay, () {
      if (!mounted) return;
      _timer = Timer.periodic(widget.durationPerChar, (t) {
        if (!mounted) return;
        setState(() {
          _current++;
          if (_current >= widget.text.length) {
            _current = widget.text.length;
            _done = true;
            t.cancel();
            widget.onComplete?.call();
          }
        });
      });
    });
  }

  void _restart() {
    _timer?.cancel();
    setState(() {
      _current = 0;
      _done = false;
    });
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final display = widget.text.substring(0, _current.clamp(0, widget.text.length));
    final showCursor = !_done;

    return RichText(
      text: TextSpan(
        style: widget.textStyle ?? DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: display),
          if (showCursor) TextSpan(text: widget.cursor, style: widget.textStyle?.copyWith(color: widget.textStyle?.color?.withOpacity(0.9)) ?? const TextStyle()),
        ],
      ),
    );
  }
}
