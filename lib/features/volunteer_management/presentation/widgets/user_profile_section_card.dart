import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class UserProfileSectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  const UserProfileSectionCard({
    super.key,
    required this.title,
    required this.children,
    required this.animationController,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
          ),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.OceanBlue,
                  ),
                ),
                const Divider(height: 24, thickness: 1, color: Colors.black12),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
