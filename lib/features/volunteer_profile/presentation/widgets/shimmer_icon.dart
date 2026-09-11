// Widget لأيقونات لامعة
import 'package:flutter/material.dart';

class ShimmerIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final Animation<double> animation;

  const ShimmerIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.color,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [color.withOpacity(0.5), color, color.withOpacity(0.5)],
              stops: [0.0, animation.value, 1.0],
            ).createShader(bounds);
          },
          child: Icon(icon, size: size),
        );
      },
    );
  }
}
