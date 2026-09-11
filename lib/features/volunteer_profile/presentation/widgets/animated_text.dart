// Widget للنص المتحرك
import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration duration;

  const AnimatedText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      builder: (context, value, child) {
        final endIndex = (text.length * value).round();
        return Text(
          text.substring(0, endIndex),
          style: style,
          textAlign: textAlign,
        );
      },
    );
  }
}
