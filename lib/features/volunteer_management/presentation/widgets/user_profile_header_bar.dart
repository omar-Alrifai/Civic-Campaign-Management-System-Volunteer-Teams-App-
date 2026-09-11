import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class UserProfileHeaderBar extends StatelessWidget {
  final String userName;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const UserProfileHeaderBar({
    super.key,
    required this.userName,
    required this.animationController,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
          ),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.WhisperWhite,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.OceanBlue.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      tooltip: 'العودة',
                    ),
                  ),
                ),
              ),
              ScaleTransition(
                scale: scaleAnimation,
                child: Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
