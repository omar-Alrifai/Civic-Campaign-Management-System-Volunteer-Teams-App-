import 'package:flutter/material.dart';

class UserProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  const UserProfileInfoRow({
    super.key,
    required this.icon,
    required this.text,
    required this.animationController,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
          ),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
