import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_card.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/shimmer_widget.dart';

class CampaignsSliverList extends StatelessWidget {
  final TextEditingController searchController;
  final int selectedStatusIndex;
  final List<CampaignEntity> Function(List<CampaignEntity>, String)
  filterBySearchQuery;
  final List<CampaignEntity> Function(List<CampaignEntity>, String)
  filterByStatus;

  const CampaignsSliverList({
    Key? key,
    required this.searchController,
    required this.selectedStatusIndex,
    required this.filterBySearchQuery,
    required this.filterByStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CampaignBloc, CampaignState>(
      listener: (ctx, st) {
        if (st is CampaignError && (st.oldCampaigns?.isEmpty ?? true)) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(st.message)));
        }
      },
      builder: (ctx, st) {
        if (st is CampaignLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => const CampaignCardShimmer(),
              childCount: 5,
            ),
          );
        }

        List<CampaignEntity> displayCampaigns = [];

        if (st is CampaignsLoaded) {
          displayCampaigns = st.campaigns;
        } else if (st is CampaignLoading &&
            (st.oldCampaigns?.isNotEmpty ?? false)) {
          displayCampaigns = st.oldCampaigns ?? [];
        } else if (st is CampaignError &&
            (st.oldCampaigns?.isNotEmpty ?? false)) {
          displayCampaigns = st.oldCampaigns ?? [];
        }

        displayCampaigns = filterBySearchQuery(
          displayCampaigns,
          searchController.text,
        );

        final status = selectedStatusIndex == 0
            ? 'جميع الحملات'
            : selectedStatusIndex == 1
            ? 'نشطة'
            : 'منجزة';

        displayCampaigns = filterByStatus(displayCampaigns, status);

        if (displayCampaigns.isEmpty) {
          final msg = searchController.text.isNotEmpty
              ? 'لا توجد نتائج مطابقة'
              : 'لا توجد حملات';
          return SliverFillRemaining(child: Center(child: Text(msg)));
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CampaignCard(
                campaign: displayCampaigns[i],
                color1: AppColors.WhisperWhite,
                color2: AppColors.OceanBlue.withOpacity(0.5),
              ),
            ),
            childCount: displayCampaigns.length,
          ),
        );
      },
    );
  }
}
