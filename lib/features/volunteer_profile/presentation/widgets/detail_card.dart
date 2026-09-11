import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/shimmer_icon.dart';

class DetailCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final int index;
  final AnimationController animationController;

  const DetailCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.index,
    required this.animationController,
  }) : super(key: key);

  void _animateCard(bool isHovered) {
    // يمكن إضافة تأثير التقديم/التحليق هنا
  }

  void _bounceCard() {
    // يمكن إضافة تأثير النقر هنا
  }

  @override
  Widget build(BuildContext context) {
    final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3 + (index * 0.15), 1.0, curve: Curves.easeInOutCirc),
      ),
    );

    return AnimatedBuilder(
      animation: delayedAnimation,
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.identity()
                ..scale(delayedAnimation.value)
                ..rotateZ(0.01 * (1 - delayedAnimation.value)),
          alignment: Alignment.center,
          child: Opacity(opacity: 1, child: child),
        );
      },
      child: MouseRegion(
        onEnter: (_) => _animateCard(true),
        onExit: (_) => _animateCard(false),
        child: GestureDetector(
          onTap: _bounceCard,
          child: Card(
            color: Colors.white,
            shadowColor: AppColors.OceanBlue,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerIcon(
                    icon: icon,
                    size: 30,
                    color: AppColors.OceanBlue,
                    animation: animationController,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
