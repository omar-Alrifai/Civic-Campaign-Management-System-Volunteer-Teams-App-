import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class UserProfileChips extends StatelessWidget {
  final List<String> items;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  const UserProfileChips({
    super.key,
    required this.items,
    required this.animationController,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: items.map((item) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeOut,
                ),
              ),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Chip(
              label: Text(item),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.OceanBlue,
                fontWeight: FontWeight.bold,
              ),
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        );
      }).toList(),
    );
  }
}
