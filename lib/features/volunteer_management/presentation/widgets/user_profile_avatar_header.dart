import 'package:flutter/material.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/user_profile_entity.dart';

class UserProfileAvatarHeader extends StatelessWidget {
  final UserProfileEntity profile;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const UserProfileAvatarHeader({
    super.key,
    required this.profile,
    required this.animationController,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: profile.imageUrl.isEmpty
                  ? Colors.grey.shade300
                  : Theme.of(context).primaryColor.withOpacity(0.1),
              child: profile.imageUrl.isEmpty
                  ? Icon(Icons.person, size: 70, color: Colors.grey.shade600)
                  : (profile.imageUrl.startsWith('http')
                        ? ClipOval(
                            child: Image.network(
                              profile.imageUrl,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.grey.shade600,
                                  ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey.shade600,
                          )),
            ),
            const SizedBox(height: 16),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeOut,
                    ),
                  ),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeOut,
                    ),
                  ),
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  profile.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
