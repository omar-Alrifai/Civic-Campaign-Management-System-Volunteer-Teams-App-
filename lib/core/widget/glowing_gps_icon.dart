import 'package:flutter/material.dart';

class GlowingGPSIcon extends StatefulWidget {
  const GlowingGPSIcon({Key? key}) : super(key: key);

  @override
  State<GlowingGPSIcon> createState() => _GlowingGPSIconState();
}

class _GlowingGPSIconState extends State<GlowingGPSIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      // ScaleTransition لتكبير وتصغير الأيقونة
      scale: _animation,
      child: const Icon(
        Icons.gps_fixed,
        size: 20,
        color: Colors.blueAccent, // لون الأيقونة
      ),
    );
  }
}
