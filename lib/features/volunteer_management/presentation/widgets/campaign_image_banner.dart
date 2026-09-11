import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CampaignImageBanner extends StatelessWidget {
  final String? imageUrl;
  final bool isSmallScreen;

  const CampaignImageBanner({
    Key? key,
    this.imageUrl,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Container(
            margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
            height: isSmallScreen ? 225 : 250,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) =>
                      const Center(child: Text("فشل تحميل الصورة")),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
          .animate()
          .scale(duration: 800.ms, curve: Curves.elasticOut)
          .fadeIn(duration: 800.ms);
    }

    return Container(
      height: isSmallScreen ? 225 : 250,
      margin: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(child: Text('لا توجد صورة')),
    ).animate().scale(duration: 800.ms).fadeIn(duration: 800.ms);
  }
}
