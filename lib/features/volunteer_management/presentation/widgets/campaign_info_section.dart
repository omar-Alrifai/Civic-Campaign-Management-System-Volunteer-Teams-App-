import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class CampaignInfoSection extends StatelessWidget {
  final String? createdBy;
  final DateTime? executionDate;
  final String? description;
  final bool isSmallScreen;

  const CampaignInfoSection({
    Key? key,
    this.createdBy,
    this.executionDate,
    this.description,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: isSmallScreen ? 18 : 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    "بواسطة: ${createdBy ?? 'غير معروف'}",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: isSmallScreen ? 18 : 20,
                    color: Colors.grey,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'تاريخ الإنشاء: ${executionDate != null ? DateFormat('yyyy-MM-dd').format(executionDate!) : 'غير محدد'}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),
              const SizedBox(height: 10),
              if (executionDate != null)
                Row(
                  children: [
                    Icon(
                      Icons.play_arrow,
                      size: isSmallScreen ? 18 : 20,
                      color: Colors.grey,
                    ),
                    SizedBox(width: isSmallScreen ? 6 : 8),
                    Text(
                      'تاريخ البدء: ${DateFormat('yyyy-MM-dd').format(executionDate!)}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
          child: Text(
            description ?? 'لا يوجد وصف',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3),
        ),
      ],
    );
  }
}
