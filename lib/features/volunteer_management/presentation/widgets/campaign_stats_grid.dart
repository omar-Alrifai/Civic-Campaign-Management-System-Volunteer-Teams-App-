import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/shake_card.dart';

class CampaignStatsGrid extends StatelessWidget {
  final double requiredAmount;
  final double donationTotal;
  final int? numberOfParticipants;
  final int? joinedParticipants;
  final bool isSmallScreen;
  final bool isLargeScreen;

  const CampaignStatsGrid({
    Key? key,
    required this.requiredAmount,
    required this.donationTotal,
    this.numberOfParticipants,
    this.joinedParticipants,
    required this.isSmallScreen,
    required this.isLargeScreen,
  }) : super(key: key);

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    int index,
  ) {
    return ShakeCard(
      title: title,
      value: value,
      icon: icon,
      color: color,
      index: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
      child:
          GridView.count(
                crossAxisCount: isSmallScreen ? 2 : (isLargeScreen ? 4 : 2),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: isSmallScreen ? 10 : 12,
                crossAxisSpacing: isSmallScreen ? 10 : 12,
                childAspectRatio: isSmallScreen ? 1.1 : 1,
                children: [
                  _buildStatCard(
                    'المبلغ المطلوب',
                    '${requiredAmount.toStringAsFixed(0)} \$',
                    Icons.attach_money,
                    Colors.green,
                    0,
                  ),
                  _buildStatCard(
                    'المبلغ المجموع',
                    '${donationTotal.toStringAsFixed(0)} \$',
                    Icons.account_balance_wallet,
                    Colors.blue,
                    1,
                  ),
                  _buildStatCard(
                    'عدد المتطوعين المطلوب',
                    '${numberOfParticipants ?? 0}',
                    Icons.people,
                    Colors.orange,
                    2,
                  ),
                  _buildStatCard(
                    'المتطوعين المنضمين',
                    '${joinedParticipants ?? 0}',
                    Icons.group_add,
                    Colors.purple,
                    3,
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideY(begin: 20, duration: 600.ms, curve: Curves.easeOut),
    );
  }
}
