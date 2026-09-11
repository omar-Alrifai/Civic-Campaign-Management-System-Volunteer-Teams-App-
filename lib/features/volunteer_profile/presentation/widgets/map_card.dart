import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/glowing_gps_icon.dart';
import 'package:graduationregistration/core/widget/location_preview.dart';

class MapCard extends StatelessWidget {
  final dynamic location;
  final bool isLargeScreen;
  final Animation<double> fadeAnimation;
  final AnimationController animationController;
  final VoidCallback onTap;

  const MapCard({
    Key? key,
    required this.location,
    required this.isLargeScreen,
    required this.fadeAnimation,
    required this.animationController,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (location?.latitude == null || location?.longitude == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Card(
          color: Colors.white,
          elevation: 5,
          shadowColor: AppColors.OceanBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            highlightColor: AppColors.OceanBlue.withOpacity(0.1),
            splashColor: AppColors.OceanBlue.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الموقع',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const GlowingGPSIcon(),
                      const SizedBox(width: 8),
                      if (location?.name != null)
                        Expanded(
                          child: Text(
                            location!.name!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.open_in_full,
                        size: 18,
                        color: Colors.grey[500],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: isLargeScreen ? 200 : 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LocationPreview(
                        latitude: double.parse(location!.latitude!),
                        longitude: double.parse(location!.longitude!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'اضغط لعرض الموقع على الخريطة',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
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
