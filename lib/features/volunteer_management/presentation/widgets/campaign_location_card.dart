import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/glowing_gps_icon.dart';
import 'package:graduationregistration/core/widget/location_preview.dart';
import 'package:latlong2/latlong.dart';

class CampaignLocationCard extends StatelessWidget {
  final dynamic location;
  final bool isSmallScreen;
  final Function(LatLng location, String title) onMapTap;

  const CampaignLocationCard({
    Key? key,
    required this.location,
    required this.isSmallScreen,
    required this.onMapTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child:
          Card(
                shadowColor: AppColors.OceanBlue,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    if (location != null &&
                        location.latitude != null &&
                        location.longitude != null) {
                      onMapTap(
                        LatLng(
                          double.parse(location.latitude!),
                          double.parse(location.longitude!),
                        ),
                        location.name ?? 'موقع الحملة',
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'لا يمكن عرض الموقع: الإحداثيات غير متوفرة.',
                          ).animate().shake(hz: 3, duration: 800.ms),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'الموقع',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const GlowingGPSIcon(),
                            const SizedBox(width: 4),
                            if (location?.name != null)
                              Expanded(
                                child: Text(
                                  location.name!,
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.grey[700],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              '(اضغط لعرض الموقع على الخريطة)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: isSmallScreen ? 12 : 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (location?.latitude != null &&
                            location?.longitude != null)
                          LocationPreview(
                                latitude: double.parse(location.latitude!),
                                longitude: double.parse(location.longitude!),
                                height: isSmallScreen ? 150 : 160,
                              )
                              .animate()
                              .fadeIn(delay: 900.ms)
                              .scale(begin: const Offset(0, 0.9)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 900.ms)
              .scale(
                duration: const Duration(milliseconds: 1200),
                curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
              ),
    );
  }
}
