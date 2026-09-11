import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CampaignCardShimmer extends StatelessWidget {
  const CampaignCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const SweepGradient(
          colors: [Colors.grey, Colors.white],
          stops: [0.0, 0.5],
        ),
      ),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            children: [
              // صورة
              _buildShimmerContainer(
                height: 180,
                radius: 12,
                margin: const EdgeInsets.all(8),
              ),

              // المحتوى
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان والفئة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildShimmerContainer(
                            height: 20,
                            width: 150,
                            radius: 4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildShimmerContainer(
                          height: 20,
                          width: 80,
                          radius: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // الوصف
                    _buildShimmerContainer(
                      height: 14,
                      width: double.infinity,
                      radius: 4,
                    ),
                    const SizedBox(height: 6),
                    _buildShimmerContainer(
                      height: 14,
                      width: double.infinity,
                      radius: 4,
                    ),
                    const SizedBox(height: 6),
                    _buildShimmerContainer(height: 14, width: 200, radius: 4),

                    const SizedBox(height: 12),
                    // النص مع التقدم
                    _buildShimmerContainer(height: 14, width: 180, radius: 4),
                    const SizedBox(height: 4),
                    _buildShimmerContainer(
                      height: 8,
                      width: double.infinity,
                      radius: 4,
                    ),

                    const SizedBox(height: 12),
                    // سطر 1
                    Row(
                      children: [
                        Expanded(
                          child: _buildShimmerContainer(height: 14, radius: 4),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildShimmerContainer(height: 14, radius: 4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // سطر 2
                    Row(
                      children: [
                        Expanded(
                          child: _buildShimmerContainer(height: 14, radius: 4),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildShimmerContainer(height: 14, radius: 4),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContainer({
    double? height,
    double? width,
    double radius = 0,
    EdgeInsetsGeometry? margin,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
