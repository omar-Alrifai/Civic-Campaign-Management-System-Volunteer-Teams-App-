import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CampaignTitleCategory extends StatelessWidget {
  final String? title;
  final String? category;
  final bool isSmallScreen;

  static const Map<String, Map<String, dynamic>> _categoryIcons = {
    'إنارة الشوارع بالطاقة الشمسية': {
      'icon': Icons.lightbulb_outline,
      'color': Colors.amber,
    },
    'تنظيف وتزيين الأماكن العامة': {
      'icon': Icons.cleaning_services,
      'color': Colors.blue,
    },
    'يوم خيري': {'icon': Icons.volunteer_activism, 'color': Colors.purple},
    'حملات تشجير': {'icon': Icons.forest, 'color': Colors.green},
    'ترميم أضرار (كوارث , عدوان)': {
      'icon': Icons.construction,
      'color': Colors.red,
    },
    'غير محدد': {'icon': Icons.category, 'color': Colors.grey},
  };

  const CampaignTitleCategory({
    Key? key,
    this.title,
    this.category,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryData =
        _categoryIcons[category] ?? _categoryIcons['غير محدد']!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title ?? 'لا يوجد عنوان',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.3),
          ),
          SizedBox(width: isSmallScreen ? 8 : 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: categoryData['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: categoryData['color'], width: 1),
              boxShadow: [
                BoxShadow(
                  color: categoryData['color'].withOpacity(0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  categoryData['icon'],
                  size: isSmallScreen ? 14 : 16,
                  color: categoryData['color'],
                ),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Text(
                  category ?? 'غير معروف',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    color: categoryData['color'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.3),
        ],
      ),
    );
  }
}
