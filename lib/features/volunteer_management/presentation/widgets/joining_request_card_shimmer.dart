import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class JoiningRequestCardShimmer extends StatelessWidget {
  const JoiningRequestCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(width: 150, height: 16, color: Colors.white),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(width: 80, height: 36, color: Colors.white),
                  const SizedBox(width: 8),
                  Container(width: 80, height: 36, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
