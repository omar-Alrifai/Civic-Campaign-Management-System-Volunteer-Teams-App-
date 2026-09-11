import 'package:flutter/material.dart';

class ShakeCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final int index;

  const ShakeCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.index,
  }) : super(key: key);

  @override
  _ShakeCardState createState() => _ShakeCardState();
}

class _ShakeCardState extends State<ShakeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    Future.delayed(Duration(milliseconds: widget.index * 800), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  void _triggerSlide() {
    _slideController.reset();
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Card(
      shadowColor: widget.color.withOpacity(0.4),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.7),
                    widget.color,
                    widget.color.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: Icon(widget.icon, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: _triggerSlide,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(opacity: _slideController, child: cardContent),
      ),
    );
  }
}
