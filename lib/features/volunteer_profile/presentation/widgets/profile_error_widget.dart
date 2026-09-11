import 'package:flutter/material.dart';
import 'package:graduationregistration/core/app_colors.dart';

class ProfileErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProfileErrorWidget({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.OceanBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: AppColors.OceanBlue.withOpacity(0.5),
            ),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
