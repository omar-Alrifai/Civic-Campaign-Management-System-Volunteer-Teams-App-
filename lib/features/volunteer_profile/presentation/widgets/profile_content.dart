import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/map_display_page.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/animated_text.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/detail_card.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/map_card.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/profile_avatar.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/widgets/shake_widget.dart';
import 'package:latlong2/latlong.dart';

class ProfileContent extends StatelessWidget {
  final dynamic profile;
  final GlobalKey<ShakeWidgetState> shakeKey;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final Animation<Color?> colorAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onLogoutPressed;
  final Future<void> Function() onRefresh;

  const ProfileContent({
    super.key,
    required this.profile,
    required this.shakeKey,
    required this.animationController,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.colorAnimation,
    required this.slideAnimation,
    required this.onLogoutPressed,
    required this.onRefresh,
  });

  void _openFullScreenMap(BuildContext context, LatLng location, String title) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MapDisplayPage(location: location, title: title),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final scale = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
          );
          final fade = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
          return ScaleTransition(
            scale: scale,
            child: FadeTransition(opacity: fade, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;

    return ShakeWidget(
      key: shakeKey,
      shakeCount: 3,
      shakeOffset: 10,
      child: RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.OceanBlue,
        notificationPredicate: (notification) => notification.depth == 0,
        displacement: 40,
        edgeOffset: 20,
        strokeWidth: 2.5,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                imageUrl: profile.imageUrl,
                isLargeScreen: isLargeScreen,
                scaleAnimation: scaleAnimation,
                fadeAnimation: fadeAnimation,
                colorAnimation: colorAnimation,
                onTap: () {
                  animationController.reset();
                  animationController.forward();
                },
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: slideAnimation,
                child: AnimatedText(
                  text: profile.name ?? 'اسم الفريق غير متوفر',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  duration: const Duration(milliseconds: 1000),
                ),
              ),
              const SizedBox(height: 8),
              if (profile.email != null && profile.email!.isNotEmpty)
                FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.5, 2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: const Interval(
                              0.5,
                              0.8,
                              curve: Curves.easeOut,
                            ),
                          ),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              profile.email!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(-0.5, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: const Interval(
                            0.1,
                            0.7,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      profile.bio ?? 'لا يوجد وصف شخصي.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 16 : 15,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animationController,
                        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                child: GridView.count(
                  crossAxisCount: isLargeScreen ? 3 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: isLargeScreen ? 0.9 : 0.95,
                  children: [
                    if (profile.phone != null && profile.phone!.isNotEmpty)
                      DetailCard(
                        label: 'الهاتف',
                        value: profile.phone!,
                        icon: Icons.phone,
                        index: 0,
                        animationController: animationController,
                      ),
                    if (profile.experienceYears != null)
                      DetailCard(
                        label: 'سنوات الخبرة',
                        value: '${profile.experienceYears} سنة',
                        icon: Icons.timelapse,
                        index: 1,
                        animationController: animationController,
                      ),
                    if (profile.email != null && profile.email!.isNotEmpty)
                      DetailCard(
                        label: 'البريد الإلكتروني',
                        value: profile.email!,
                        icon: Icons.email,
                        index: 2,
                        animationController: animationController,
                      ),
                    if (profile.location?.name != null)
                      DetailCard(
                        label: 'الموقع',
                        value: profile.location!.name!,
                        icon: Icons.location_city,
                        index: 3,
                        animationController: animationController,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MapCard(
                location: profile.location,
                isLargeScreen: isLargeScreen,
                fadeAnimation: fadeAnimation,
                animationController: animationController,
                onTap: () {
                  _openFullScreenMap(
                    context,
                    LatLng(
                      double.parse(profile.location!.latitude!),
                      double.parse(profile.location!.longitude!),
                    ),
                    profile.location!.name ?? 'موقع الفريق',
                  );
                },
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: const Interval(
                            0.9,
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        ),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton.icon(
                      onPressed: onLogoutPressed,
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.OceanBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
