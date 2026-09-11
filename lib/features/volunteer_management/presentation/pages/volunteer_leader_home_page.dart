import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/core/app_colors.dart';
import 'package:graduationregistration/core/widget/loading_widget.dart';
import 'package:graduationregistration/features/volunteer_management/data/models/category_model.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/category.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/lookups_bloc/lookups_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaigns_sliver_list.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/selected_category_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/status_chips_bar.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/volunteer_header_bar.dart';

class VolunteerLeaderHomePage extends StatefulWidget {
  const VolunteerLeaderHomePage({Key? key}) : super(key: key);

  @override
  State<VolunteerLeaderHomePage> createState() =>
      _VolunteerLeaderHomePageState();
}

class _VolunteerLeaderHomePageState extends State<VolunteerLeaderHomePage>
    with RouteAware, TickerProviderStateMixin {
  String? _selectedCategoryFilter;
  final TextEditingController _searchController = TextEditingController();

  int _selectedStatusIndex = 0; // 0: الكل, 1: نشطة, 2: منجزة
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    _loadCampaigns();
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
    Future.microtask(() {
      context.read<CampaignBloc>().add(const RefreshAllCampaignsEvent());
    });

    _searchController.addListener(() {
      _debounceSearch();
    });
  }

  bool get isSmallScreen => MediaQuery.of(context).size.width < 360;
  bool get isMediumScreen => MediaQuery.of(context).size.width < 400;

  Future<void> _debounceSearch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _loadCampaigns();
  }

  void _loadCampaigns() {
    if (!mounted) return;

    context.read<CampaignBloc>().emit(const CampaignLoading(oldCampaigns: []));

    String? statusFilterForLocalUse;
    if (_selectedStatusIndex == 1) {
      statusFilterForLocalUse = 'نشطة';
    } else if (_selectedStatusIndex == 2) {
      statusFilterForLocalUse = 'منجزة';
    }

    List<MyCategory> currentCategories = [];
    final lookupsState = context.read<LookupsBloc>().state;

    if (lookupsState is CategoriesLoaded) {
      currentCategories = lookupsState.categories;
    } else if (lookupsState is LookupsDataLoaded) {
      currentCategories = lookupsState.categories;
    }

    int? categoryIdForApi;
    if (_selectedCategoryFilter != null &&
        _selectedCategoryFilter != 'جميع التصنيفات') {
      final selectedCategory = currentCategories.firstWhere(
        (cat) => cat.name == _selectedCategoryFilter,
        orElse: () => CategoryModel(id: 0, name: 'جميع التصنيفات'),
      );
      if (selectedCategory.id != 0) {
        categoryIdForApi = selectedCategory.id;
      }
    }

    if (_selectedCategoryFilter == 'جميع التصنيفات' ||
        categoryIdForApi == null) {
      context.read<CampaignBloc>().add(const LoadAllCampaignsEvent());
    } else {
      context.read<CampaignBloc>().add(
        LoadCampaignsByCategoryEvent(categoryId: categoryIdForApi),
      );
    }
  }

  void _RefreshAllCampaigns() {
    context.read<CampaignBloc>().add(const RefreshAllCampaignsEvent());
  }

  void _performSearch() {
    String? statusFilterForLocalOrSearch;
    if (_selectedStatusIndex == 1) {
      statusFilterForLocalOrSearch = 'نشطة';
    } else if (_selectedStatusIndex == 2) {
      statusFilterForLocalOrSearch = 'منجزة';
    }

    context.read<CampaignBloc>().add(
      SearchCampaignsEvent(
        query: _searchController.text,
        categoryFilter: _selectedCategoryFilter,
        statusFilter: statusFilterForLocalOrSearch,
      ),
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

                            _loadCampaigns();
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

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
              onRefresh: () async => _RefreshAllCampaigns(),
              color: AppColors.OceanBlue,
              backgroundColor: AppColors.WhisperWhite,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width < 360
                          ? 12.0
                          : 16.0,
                      vertical: 16,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: VolunteerHeaderBar(
                        searchController: _searchController,
                        onSearchSubmitted: (_) => _loadCampaigns(),
                        onFilterPressed: _showCategoryFilterSheet,
                      ),
                    ),
                  ),
                  if (_selectedCategoryFilter != null &&
                      _selectedCategoryFilter != 'جميع التصنيفات')
                    SliverToBoxAdapter(
                      child: SelectedCategoryBar(
                        selectedCategoryFilter: _selectedCategoryFilter!,
                        onClearFilter: () {
                          setState(() {
                            _selectedCategoryFilter = 'جميع التصنيفات';
                          });
                          _loadCampaigns();
                        },
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: StatusChipsBar(
                      selectedStatusIndex: _selectedStatusIndex,
                      animationController: _animationController,
                      scaleAnimation: _scaleAnimation,
                      onStatusSelected: (index) {
                        setState(() {
                          _selectedStatusIndex = index;
                        });
                        _loadCampaigns();
                      },
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: CampaignsSliverList(
                      searchController: _searchController,
                      selectedStatusIndex: _selectedStatusIndex,
                      filterBySearchQuery: _filterCampaignsBySearchQuery,
                      filterByStatus: _filterCampaignsByStatus,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 0,
          navBarColor: AppColors.OceanBlue.withOpacity(0.9),
          buttonBackgroundColor: AppColors.OceanBlue.withOpacity(0.9),
        ),
      ),
    );
  }
}
