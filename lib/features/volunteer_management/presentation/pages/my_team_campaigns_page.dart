import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/loading_widget.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaign_management_bloc/campaign_management_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/team_campaigns_header_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/team_campaigns_sliver_list.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/team_selected_category_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/team_status_chips_bar.dart';

class MyTeamCampaignsPage extends StatefulWidget {
  const MyTeamCampaignsPage({Key? key}) : super(key: key);

  @override
  State<MyTeamCampaignsPage> createState() => _MyTeamCampaignsPageState();
}

class _MyTeamCampaignsPageState extends State<MyTeamCampaignsPage>
    with RouteAware, SingleTickerProviderStateMixin {
  String? _selectedCategoryFilter;
  final TextEditingController _searchController = TextEditingController();
  final int _currentIndex = 1;
  int _selectedStatusIndex = 0; // 0: الكل, 1: نشطة, 2: منجزة
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    _loadMyTeamCampaigns();
  }

  @override
  void initState() {
    super.initState();
    _selectedCategoryFilter = 'جميع التصنيفات';
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    context.read<LookupsBloc>().add(const LoadCategoriesEvent());
    _loadMyTeamCampaigns();
    _searchController.addListener(_debounceSearch);
  }

  Future<void> _debounceSearch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _loadMyTeamCampaigns();
  }

  void _loadMyTeamCampaigns() {
    context.read<CampaignBloc>().add(const LoadVolunteerAdminCampaignsEvent());
  }

  void _refreshMyTeamCampaigns() {
    context.read<CampaignBloc>().add(
      const RefreshVolunteerAdminCampaignsEvent(),
    );
  }

  List<CampaignEntity> _filterCampaignsByStatus(
    List<CampaignEntity> campaigns,
    String statusFilter,
  ) {
    if (statusFilter == 'جميع الحملات') {
      return campaigns;
    } else if (statusFilter == 'نشطة') {
      return campaigns.where((c) => c.status == 'نشطة').toList();
    } else if (statusFilter == 'منجزة') {
      return campaigns.where((c) => c.status == 'منجزة').toList();
    }
    return campaigns;
  }

  List<CampaignEntity> _filterCampaignsBySearchQuery(
    List<CampaignEntity> campaigns,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) {
      return campaigns;
    }
    final lowerCaseQuery = searchQuery.toLowerCase();
    return campaigns.where((campaign) {
      final title = campaign.title?.toLowerCase() ?? '';
      final description = campaign.description?.toLowerCase() ?? '';
      final category = campaign.category?.toLowerCase() ?? '';
      final locationName = campaign.location?.name?.toLowerCase() ?? '';
      return title.contains(lowerCaseQuery) ||
          description.contains(lowerCaseQuery) ||
          category.contains(lowerCaseQuery) ||
          locationName.contains(lowerCaseQuery);
    }).toList();
  }

  List<CampaignEntity> _filterCampaignsByCategory(
    List<CampaignEntity> campaigns,
    String? categoryFilter,
  ) {
    if (categoryFilter == null || categoryFilter == 'جميع التصنيفات') {
      return campaigns;
    }
    return campaigns.where((c) => c.category == categoryFilter).toList();
  }

  void _showCategoryFilterSheet() {
    context.read<LookupsBloc>().add(const LoadCategoriesEvent());

    showModalBottomSheet(
      backgroundColor: AppColors.OceanBlue,
      context: context,
      builder: (BuildContext bc) {
        return BlocBuilder<LookupsBloc, LookupsState>(
          builder: (context, lookupsState) {
            List<MyCategory> categories = [];
            if (lookupsState is CategoriesLoaded) {
              categories = lookupsState.categories;
            } else if (lookupsState is LookupsDataLoaded) {
              categories = lookupsState.categories;
            } else if (lookupsState is LookupsLoading) {
              return const Center(
                child: LoadingWidget(
                  textColor: Colors.white,
                  shaderMaskColors: [
                    AppColors.WhisperWhite,
                    AppColors.WhisperWhite,
                  ],
                  spinKitChasingDots: AppColors.WhisperWhite,
                ),
              );
            } else if (lookupsState is LookupsError) {
              return Center(
                child: Text(
                  'خطأ في تحميل الفئات: ${lookupsState.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final List<MyCategory> displayCategories = [
              MyCategory(id: 0, name: 'جميع التصنيفات'),
              ...categories,
            ];

            return Container(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اختر التصنيف',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  const Divider(color: Colors.white70),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayCategories.length,
                      itemBuilder: (context, index) {
                        final category = displayCategories[index];
                        return ListTile(
                          leading: Icon(
                            _selectedCategoryFilter == category.name
                                ? Icons.check_circle_outline
                                : Icons.radio_button_off,
                            color: Colors.white,
                          ),
                          title: Text(
                            category.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedCategoryFilter = category.name;
                            });
                            _loadMyTeamCampaigns();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الخروج'),
            content: const Text('هل أنت متأكد أنك تريد الخروج من التطبيق؟'),
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

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CampaignBloc, CampaignState>(
          listener: (ctx, st) {
            if (st is CampaignError && (st.oldCampaigns?.isEmpty ?? true)) {
              ScaffoldMessenger.of(
                ctx,
              ).showSnackBar(SnackBar(content: Text(st.message)));
            }
          },
        ),
        BlocListener<CampaignManagementBloc, CampaignManagementState>(
          listener: (context, managementState) {
            if (managementState is CampaignStatusUpdatedSuccess) {
              context.read<CampaignBloc>().add(
                const RefreshVolunteerAdminCampaignsEvent(),
              );
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (_didPop, _r) async {
          if (!_didPop && await _onWillPop()) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.OceanBlue, Colors.white],
                stops: [0.0, 0.2],
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => _refreshMyTeamCampaigns(),
                color: AppColors.OceanBlue,
                backgroundColor: AppColors.WhisperWhite,
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: TeamCampaignsHeaderBar(
                          searchController: _searchController,
                          onSearchSubmitted: (_) => _loadMyTeamCampaigns(),
                          onFilterPressed: _showCategoryFilterSheet,
                        ),
                      ),
                    ),
                    if (_selectedCategoryFilter != null &&
                        _selectedCategoryFilter != 'جميع التصنيفات')
                      SliverToBoxAdapter(
                        child: TeamSelectedCategoryBar(
                          selectedCategoryFilter: _selectedCategoryFilter!,
                          onClearFilter: () {
                            setState(() {
                              _selectedCategoryFilter = 'جميع التصنيفات';
                            });
                            _loadMyTeamCampaigns();
                          },
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: TeamStatusChipsBar(
                        selectedStatusIndex: _selectedStatusIndex,
                        animationController: _animationController,
                        scaleAnimation: _scaleAnimation,
                        onStatusSelected: (index) {
                          setState(() {
                            _selectedStatusIndex = index;
                          });
                          _loadMyTeamCampaigns();
                        },
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: TeamCampaignsSliverList(
                        searchController: _searchController,
                        selectedStatusIndex: _selectedStatusIndex,
                        selectedCategoryFilter: _selectedCategoryFilter,
                        filterBySearchQuery: _filterCampaignsBySearchQuery,
                        filterByCategory: _filterCampaignsByCategory,
                        filterByStatus: _filterCampaignsByStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            navBarColor: AppColors.OceanBlue,
            buttonBackgroundColor: AppColors.OceanBlue,
          ),
        ),
      ),
    );
  }
}
