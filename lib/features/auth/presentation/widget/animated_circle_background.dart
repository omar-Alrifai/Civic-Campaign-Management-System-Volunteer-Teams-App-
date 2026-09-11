import 'dart:math';

import 'package:flutter/material.dart';

class WaveBackground extends StatefulWidget {
  const WaveBackground({super.key});

  @override
  State<WaveBackground> createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: WavePainter(_controller.value),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    // رسم موجات متعددة
    for (int i = 0; i < 4; i++) {
      final path = Path();
      final waveHeight = 20.0 + i * 10;
      final waveLength = size.width / (2 + i);

      path.moveTo(0, size.height * 0.4);

      for (double x = 0; x < size.width; x++) {
        final y =
            waveHeight * sin((x / waveLength) + animationValue * 2 * pi) +
            size.height * 0.4;
        path.lineTo(x, y);
      }

      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      canvas.drawPath(
        path,
        paint..color = Colors.white.withOpacity(0.1 * (i + 1)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => true;
}
