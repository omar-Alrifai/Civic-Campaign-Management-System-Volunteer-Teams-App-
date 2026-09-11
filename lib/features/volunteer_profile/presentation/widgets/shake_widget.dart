// Widget لاهتزاز العناصر عند الخطأ
import 'dart:math';

import 'package:flutter/material.dart';

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double shakeOffset;
  final int shakeCount;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shakeOffset = 10,
    this.shakeCount = 3,
  });

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void shake() {
    _shakeController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeController,
      child: widget.child,
      builder: (context, child) {
        final sineValue = sin(
          widget.shakeCount * 2 * pi * _shakeController.value,
        );
        return Transform.translate(
          offset: Offset(sineValue * widget.shakeOffset, 0),
          child: child,
        );
      },
    );
  }
}
