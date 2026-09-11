import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/auth/presentation/blocs/auth_core_bloc/auth_core_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/map_display_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_header_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_image_banner.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_info_section.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_location_card.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_progress_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_ratings_section.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_stats_grid.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_status_action_button.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_title_category.dart';
import 'package:latlong2/latlong.dart';

class CampaignDetailsPage extends StatefulWidget {
  final int campaignId;

  const CampaignDetailsPage({Key? key, required this.campaignId})
    : super(key: key);

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    context.read<CampaignBloc>().add(
      LoadCampaignDetailsEvent(campaignId: widget.campaignId),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _scrollController.addListener(() {
      final double scrollOffset = _scrollController.offset;
      if (_showFloatingButton != (scrollOffset > 100)) {
        setState(() {
          _showFloatingButton = scrollOffset > 100;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _changeCampaignStatus(int projectId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد'),
          content: const Text(
            'هل أنت متأكد من أنك تريد تغيير حالة الحملة إلى "منجزة"؟',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: const Text('تأكيد'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CampaignManagementBloc>().add(
                  ChangeCampaignStatusEvent(projectId: projectId),
                );
              },
            ),
          ],
        ).animate().scale(duration: 300.ms).fadeIn(duration: 300.ms);
      },
    );
  }

  void _openFullScreenMap(LatLng location, String title) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MapDisplayPage(location: location, title: title),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final scaleAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn,
          );
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(scaleAnimation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isLargeScreen = screenWidth > 900;

    return Scaffold(
      floatingActionButton: _showFloatingButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppColors.OceanBlue,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ).animate().scale(duration: 300.ms).fadeIn(duration: 300.ms)
          : null,
      body: MultiBlocListener(
        listeners: [
          BlocListener<CampaignBloc, CampaignState>(
            listener: (context, state) {
              if (state is CampaignError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                    ).animate().shake(hz: 3, duration: 800.ms),
                  ),
                );
              }
            },
          ),
          BlocListener<CampaignManagementBloc, CampaignManagementState>(
            listener: (context, managementState) {
              if (managementState is CampaignStatusUpdatedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      managementState.message,
                    ).animate().scale(duration: 300.ms),
                  ),
                );
                Navigator.pop(context, true);
              } else if (managementState is CampaignManagementError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      managementState.message,
                    ).animate().shake(hz: 3, duration: 800.ms),
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthCoreBloc, AuthCoreState>(
          builder: (authContext, authState) {
            int? currentUserId;
            if (authState is Authenticated) {
              currentUserId = authState.user.id;
            }

            return BlocBuilder<CampaignBloc, CampaignState>(
              builder: (campaignContext, campaignState) {
                if (campaignState is CampaignLoading) {
                  return Center(
                    child: const CircularProgressIndicator().animate().rotate(
                      duration: 1000.ms,
                    ),
                  );
                } else if (campaignState is CampaignDetailsLoaded) {
                  final campaign = campaignState.campaign;
                  final bool isOwner =
                      (currentUserId != null &&
                      campaign.user?.userId == currentUserId);

                  double requiredAmountValue =
                      double.tryParse(campaign.requiredAmount ?? '0') ?? 0.0;
                  double donationTotalValue =
                      double.tryParse(campaign.donationTotal ?? '0') ?? 0.0;
                  double progress = requiredAmountValue > 0
                      ? donationTotalValue / requiredAmountValue
                      : 0.0;
                  if (progress > 1.0) progress = 1.0;

                  _progressAnimation = Tween<double>(begin: 0.0, end: progress)
                      .animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOutCubic,
                        ),
                      );
                  _animationController.forward();

                  return Scaffold(
                    body: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.OceanBlue, Colors.white],
                          stops: const [0.0, 0.2],
                        ),
                      ),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CampaignHeaderBar(title: campaign.title),
                              CampaignImageBanner(
                                imageUrl: campaign.imageUrl,
                                isSmallScreen: isSmallScreen,
                              ),
                              CampaignTitleCategory(
                                title: campaign.title,
                                category: campaign.category,
                                isSmallScreen: isSmallScreen,
                              ),
                              const SizedBox(height: 20),
                              if (campaign.status == "نشطة" ||
                                  campaign.status == "منجزة") ...[
                                CampaignProgressBar(
                                  donationTotal: donationTotalValue,
                                  requiredAmount: requiredAmountValue,
                                  progressAnimation: _progressAnimation,
                                  isSmallScreen: isSmallScreen,
                                ),
                                const SizedBox(height: 20),
                              ],
                              CampaignInfoSection(
                                createdBy: campaign.user?.createdBy,
                                executionDate: campaign.executionDate,
                                description: campaign.description,
                                isSmallScreen: isSmallScreen,
                              ),
                              const SizedBox(height: 24),
                              CampaignStatsGrid(
                                requiredAmount: requiredAmountValue,
                                donationTotal: donationTotalValue,
                                numberOfParticipants:
                                    campaign.numberOfParticipants,
                                joinedParticipants: campaign.joinedParticipants,
                                isSmallScreen: isSmallScreen,
                                isLargeScreen: isLargeScreen,
                              ),
                              const SizedBox(height: 24),
                              CampaignLocationCard(
                                location: campaign.location,
                                isSmallScreen: isSmallScreen,
                                onMapTap: _openFullScreenMap,
                              ),
                              const SizedBox(height: 24),
                              if (isOwner && campaign.status != 'منجزة') ...[
                                CampaignStatusActionButton(
                                  isSmallScreen: isSmallScreen,
                                  onPressed: () =>
                                      _changeCampaignStatus(campaign.id),
                                ),
                                const SizedBox(height: 20),
                              ],
                              CampaignRatingsSection(
                                avgRating: campaign.avgRating,
                                ratings: campaign.ratings,
                                isSmallScreen: isSmallScreen,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (campaignState is CampaignError) {
                  return Center(child: Text(campaignState.message));
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}
