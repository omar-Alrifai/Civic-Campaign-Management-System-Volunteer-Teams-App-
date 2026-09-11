import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class CampaignRatingsSection extends StatelessWidget {
  final double? avgRating;
  final List<dynamic>? ratings;
  final bool isSmallScreen;

  const CampaignRatingsSection({
    Key? key,
    this.avgRating,
    this.ratings,
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
            'التقييمات (${avgRating?.toStringAsFixed(1) ?? 'لا يوجد'}):',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 1100.ms),
          const SizedBox(height: 8.0),
          if (ratings != null && ratings!.isNotEmpty)
            ...ratings!.map(
              (rating) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child:
                    Card(
                          elevation: 2,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
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
                                    SizedBox(width: isSmallScreen ? 3 : 4),
                                    Text(
                                      rating.user ?? 'مستخدم غير معروف',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      rating.date != null
                                          ? DateFormat(
                                              'yyyy-MM-dd',
                                            ).format(rating.date!)
                                          : '',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: isSmallScreen ? 12 : 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    rating.rating ?? 0,
                                    (index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: isSmallScreen ? 16 : 18,
                                    ),
                                  ),
                                ),
                                if (rating.comment != null &&
                                    rating.comment!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    rating.comment!,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 13 : 14,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 1200.ms)
                        .scale(begin: const Offset(0, 0.95)),
              ),
            )
          else
            const Text(
              'لا توجد تقييمات لهذه الحملة حتى الآن.',
            ).animate().fadeIn(delay: 1200.ms),
        ],
      ),
    );
  }
}
