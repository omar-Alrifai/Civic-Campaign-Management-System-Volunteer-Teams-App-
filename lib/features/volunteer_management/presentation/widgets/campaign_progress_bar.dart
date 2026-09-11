import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CampaignProgressBar extends StatelessWidget {
  final double donationTotal;
  final double requiredAmount;
  final Animation<double> progressAnimation;
  final bool isSmallScreen;

  const CampaignProgressBar({
    Key? key,
    required this.donationTotal,
    required this.requiredAmount,
    required this.progressAnimation,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${donationTotal.toStringAsFixed(0)} \$ تم جمعها من ${requiredAmount.toStringAsFixed(0)} \$",
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: progressAnimation.value,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
                minHeight: isSmallScreen ? 8 : 10,
                borderRadius: BorderRadius.circular(5),
              );
            },
          ).animate().scale(duration: 1000.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }
}
