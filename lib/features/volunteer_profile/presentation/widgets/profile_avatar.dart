import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isLargeScreen;
  final Animation<double> scaleAnimation;
  final Animation<double> fadeAnimation;
  final Animation<Color?> colorAnimation;
  final VoidCallback onTap;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    required this.isLargeScreen,
    required this.scaleAnimation,
    required this.fadeAnimation,
    required this.colorAnimation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    colorAnimation.value ??
                    AppColors.OceanBlue.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.OceanBlue.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: isLargeScreen ? 70 : 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
              child:
                  !hasImage
                      ? Icon(
                        Icons.person,
                        size: isLargeScreen ? 70 : 60,
                        color: Colors.grey[600],
                      )
                      : null,
            ),
          ),
        ),
      ),
    );
  }
}
