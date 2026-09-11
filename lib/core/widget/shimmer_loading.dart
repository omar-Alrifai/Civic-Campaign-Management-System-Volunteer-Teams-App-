import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child; // المحتوى الذي سيظهر بعد التحميل
  final Color baseColor; // لون قاعدة الشيمر
  final Color highlightColor; // لون اللمعان

  const ShimmerLoading({
    Key? key,
    required this.child,
    this.baseColor = AppColors.LightGrey, // لون رمادي فاتح
    this.highlightColor = AppColors.WhisperWhite, // لون أبيض ساطع
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }

  // دالة مساعدة لإنشاء بطاقة Shimmer تشبه CampaignCard
  static Widget buildCampaignShimmer() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // مساحة للصورة
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.white, // لون وهمي للخلفية
            ),
            const SizedBox(height: 12.0),
            // مساحة للعنوان
            Container(height: 20, width: double.infinity, color: Colors.white),
            const SizedBox(height: 8.0),
            // مساحة للوصف
            Container(height: 16, width: double.infinity, color: Colors.white),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // مساحة لـ chips
                Container(height: 24, width: 80, color: Colors.white),
                Container(height: 24, width: 100, color: Colors.white),
              ],
            ),
            const SizedBox(height: 4.0),
            Container(height: 24, width: 120, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء قائمة من بطاقات Shimmer
  static Widget buildShimmerList({int itemCount = 3}) {
    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // لمنع التمرير أثناء التحميل
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return buildCampaignShimmer();
      },
    );
  }
}
