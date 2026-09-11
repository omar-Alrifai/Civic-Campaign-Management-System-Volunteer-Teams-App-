import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CampaignStatusActionButton extends StatelessWidget {
  final bool isSmallScreen;
  final VoidCallback onPressed;

  const CampaignStatusActionButton({
    Key? key,
    required this.isSmallScreen,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.check_circle_outline),
          label: Text(
            'تغيير الحالة إلى "منجزة"',
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5),
      ),
    );
  }
}
