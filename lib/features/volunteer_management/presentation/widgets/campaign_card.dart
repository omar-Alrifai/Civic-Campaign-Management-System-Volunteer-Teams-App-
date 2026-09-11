import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/campaign_details_page.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class CampaignCard extends StatefulWidget {
  final CampaignEntity campaign;
  final Color color1;
  final Color color2;

  const CampaignCard({
    Key? key,
    required this.campaign,
    required this.color1,
    required this.color2,
  }) : super(key: key);

  @override
  State<CampaignCard> createState() => _CampaignCardState();
}

class _CampaignCardState extends State<CampaignCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Map<String, Map<String, dynamic>> _categoryIcons = {
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
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;
    double requiredAmountValue =
        double.tryParse(campaign.requiredAmount ?? '0') ?? 0.0;
    double donationTotalValue =
        double.tryParse(campaign.donationTotal ?? '0') ?? 0.0;
    double progress = requiredAmountValue > 0
        ? donationTotalValue / requiredAmountValue
        : 0.0;
    if (progress > 1.0) progress = 1.0;

    final categoryData =
        _categoryIcons[campaign.category] ?? _categoryIcons['غير محدد']!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: SweepGradient(
              startAngle: 0.0,
              endAngle: 6.28,
              colors: [widget.color1, widget.color2],
              stops: [0.0, 0.5],
              transform: GradientRotation(2 * pi * _controller.value),
            ),
          ),
          child: Container(
            // margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: child!,
          ),
        );
      },
      child: Card(
        color: Colors.white,
        // elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    CampaignDetailsPage(campaignId: campaign.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              children: [
                // صورة أو Placeholder
                _buildImage(),
                // المحتوى الداخلي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: _buildCampaignDetails(
                    campaign,
                    requiredAmountValue,
                    progress,
                    categoryData,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.campaign.imageUrl != null &&
        widget.campaign.imageUrl!.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.all(8),
        height: 180,
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Image.network(
          widget.campaign.imageUrl!,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.white,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            height: 180,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 40,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(8),
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('لا توجد صورة')),
      );
    }
  }

  Widget _buildCampaignDetails(
    CampaignEntity campaign,
    double requiredAmountValue,
    double progress,
    Map<String, dynamic> categoryData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                campaign.title ?? 'لا يوجد عنوان',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: categoryData['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: categoryData['color'], width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    categoryData['icon'],
                    size: 16,
                    color: categoryData['color'],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    campaign.category ?? 'فئة غير معروفة',
                    style: TextStyle(
                      fontSize: 12,
                      color: categoryData['color'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          campaign.description ?? 'لا يوجد وصف',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        if (requiredAmountValue > 0) ...[
          Text(
            "${campaign.donationTotal ?? '0'} \$ تم جمعها من ${requiredAmountValue.toStringAsFixed(0)} \$",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: Colors.green,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        const SizedBox(height: 12),

        // ✅ سطر 1
        Row(
          children: [
            Expanded(
              child: _buildIconText(
                Icons.info_outline,
                'الحالة: ${campaign.status ?? 'غير معروف'}',
                _getStatusColor(campaign.status),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildIconText(
                Icons.people_alt,
                'متطوعين: ${campaign.joinedParticipants ?? 0}/${campaign.numberOfParticipants ?? 'غير محدد'}',
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // ✅ سطر 2
        Row(
          children: [
            if (campaign.location?.name != null)
              Expanded(
                child: _buildIconText(
                  Icons.location_on,
                  'المنطقة: ${campaign.location!.name}',
                  Colors.grey.shade700,
                ),
              ),
            if (campaign.executionDate != null)
              Expanded(
                child: _buildIconText(
                  Icons.calendar_today,
                  'تاريخ البدء: ${DateFormat('yyyy-MM-dd').format(campaign.executionDate!)}',
                  Colors.grey.shade700,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconText(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'قيد التنفيذ':
        return Colors.orange;
      case 'منجزة':
        return Colors.green;
      case 'مقبول':
        return Colors.blue;
      case 'مرفوض':
        return Colors.red;
      case 'نشطة':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }
}
