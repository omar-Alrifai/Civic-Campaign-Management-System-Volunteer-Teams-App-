import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/features/notifications/presentation/page/notification_page.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/joining_requests_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/joining_requests_bloc/joining_requests_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/create_campaign_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/joining_request_card.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/joining_request_card_shimmer.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/my_team_campaigns_page.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/pages/volunteer_leader_home_page.dart';
import 'package:graduationregistration/features/volunteer_profile/presentation/pages/profile_page.dart';

class JoiningRequestsPage extends StatefulWidget {
  const JoiningRequestsPage({Key? key}) : super(key: key);

  @override
  State<JoiningRequestsPage> createState() => _JoiningRequestsPageState();
}

class _JoiningRequestsPageState extends State<JoiningRequestsPage> {
  int _currentIndex = 2;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<JoiningRequestsBloc>().add(
      const LoadAllJoiningRequestsEvent(),
    );
    _searchController.addListener(_debounceSearch);
  }

  Future<void> _debounceSearch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    context.read<JoiningRequestsBloc>().add(
      const LoadAllJoiningRequestsEvent(),
    );
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const VolunteerLeaderHomePage(),
          ),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyTeamCampaignsPage()),
          (Route<dynamic> route) => false,
        );
        break;
      case 2:
        setState(() {
          _currentIndex = index;
        });
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateCampaignPage()),
        );
        break;
      case 4:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
          (route) => false,
        );
        break;
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('هل أنت متأكد؟'),
            content: const Text('هل تريد الخروج من التطبيق؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('نعم'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.OceanBlue.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.notifications_none,
          size: 22,
          color: AppColors.OceanBlue,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationPage()),
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'البحث في الطلبات...',
            prefixIcon: const Icon(Icons.search_outlined, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestsList() {
    return BlocConsumer<JoiningRequestsBloc, JoiningRequestsState>(
      listener: (context, state) {
        if (state is JoiningRequestsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is JoiningRequestActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is JoiningRequestsLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const JoiningRequestCardShimmer(),
              childCount: 5,
            ),
          );
        } else if (state is JoiningRequestsLoaded) {
          final List<JoiningRequestsEntity> requests = state.requests;

          // فلترة الطلبات بناءً على نص البحث
          final filteredRequests = _searchController.text.isEmpty
              ? requests
              : requests.where((request) {
                  final volunteerName = request.userName?.toLowerCase() ?? '';
                  final campaignName =
                      request.projectTitle?.toLowerCase() ?? '';
                  final searchText = _searchController.text.toLowerCase();
                  return volunteerName.contains(searchText) ||
                      campaignName.contains(searchText);
                }).toList();

          if (filteredRequests.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Text(
                  _searchController.text.isEmpty
                      ? 'لا توجد طلبات انضمام معلقة حالياً.'
                      : 'لا توجد نتائج مطابقة للبحث',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final request = filteredRequests[index];
              return JoiningRequestCard(request: request);
            }, childCount: filteredRequests.length),
          );
        } else if (state is JoiningRequestsError) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return SliverFillRemaining(
          child: Center(
            child: Text(
              'اسحب للتحديث لجلب الطلبات.',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final bool shouldPop = await _onWillPop();
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<JoiningRequestsBloc>().add(
                  const RefreshAllJoiningRequestsEvent(),
                );
              },
              color: AppColors.OceanBlue,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  // Header Section
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button and Title Row
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'طلبات الانضمام',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Search and Refresh Row
                          Row(children: [Expanded(child: _buildSearchField())]),
                        ],
                      ),
                    ),
                  ),

                  // Requests List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: _buildRequestsList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          navBarColor: AppColors.OceanBlue.withOpacity(0.9),
          buttonBackgroundColor: AppColors.OceanBlue,
        ),
      ),
    );
  }
}
