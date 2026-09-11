import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/domain/entities/campaign_entity.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/blocs/campaigns_bloc/campaigns_bloc.dart';
import 'package:graduationregistration/features/volunteer_management/presentation/widgets/campaign_card.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({Key? key}) : super(key: key);

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage>
    with SingleTickerProviderStateMixin {
  String? _selectedCategoryFilter;
  final TextEditingController _searchController = TextEditingController();
  ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  final List<Map<String, dynamic>> _categories = [
    {'id': 0, 'name': 'جميع التصنيفات'},
    {'id': 1, 'name': 'إنارة الشوارع بالطاقة الشمسية'},
    {'id': 2, 'name': 'تنظيف وتزيين الأماكن العامة'},
    {'id': 3, 'name': 'يوم خيري'},
    {'id': 4, 'name': 'حملات تشجير'},
    {'id': 5, 'name': 'ترميم أضرار (كوارث , عدوان)'},
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _selectedCategoryFilter = _categories[0]['name'];

    _loadCampaigns();

    _searchController.addListener(() {
      _searchQuery.value = _searchController.text;
      _debounceSearch();
    });
  }

  void _debounceSearch() {
    _performSearch();
  }

  void _loadCampaigns() {
    String? statusFilter;
    if (_tabController.index == 1) {
      statusFilter = 'نشطة';
    } else if (_tabController.index == 2) {
      statusFilter = 'منجزة';
    }

    if (_searchController.text.isNotEmpty) {
      _performSearch();
      return;
    }

    if (_selectedCategoryFilter == _categories[0]['name']) {
      context.read<CampaignBloc>().add(
        LoadAllCampaignsEvent(status: statusFilter),
      );
    } else {
      final int categoryId = _categories.firstWhere(
        (cat) => cat['name'] == _selectedCategoryFilter,
      )['id'];
      context.read<CampaignBloc>().add(
        LoadCampaignsByCategoryEvent(
          categoryId: categoryId,
          status: statusFilter,
        ),
      );
    }
  }

  void _performSearch() {
    String? statusFilter;
    if (_tabController.index == 1) {
      statusFilter = 'نشطة';
    } else if (_tabController.index == 2) {
      statusFilter = 'منجزة';
    }

    context.read<CampaignBloc>().add(
      SearchCampaignsEvent(
        query: _searchController.text,
        categoryFilter: _selectedCategoryFilter,
        statusFilter: statusFilter,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'البحث عن حملة...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _loadCampaigns();
                    },
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 0,
                  ),
                ),
                onSubmitted: (query) {
                  _performSearch();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'فلتر حسب التصنيف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                value: _selectedCategoryFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategoryFilter = newValue;
                  });
                  _loadCampaigns();
                },
                items: _categories.map<DropdownMenuItem<String>>((
                  Map<String, dynamic> category,
                ) {
                  return DropdownMenuItem<String>(
                    value: category['name'],
                    child: Text(category['name']),
                  );
                }).toList(),
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'جميع الحملات'),
                Tab(text: 'نشطة'),
                Tab(text: 'منجزة'),
              ],
              onTap: (index) {
                _loadCampaigns();
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCampaignList(context),
                  _buildCampaignList(context), // الحملات النشطة
                  _buildCampaignList(context), // الحملات المنجزة
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignList(BuildContext context) {
    String statusFilter;
    switch (_tabController.index) {
      case 0:
        statusFilter = 'جميع الحملات';
        break;
      case 1:
        statusFilter = 'نشطة';
        break;
      case 2:
        statusFilter = 'منجزة';
        break;
      default:
        statusFilter = 'جميع الحملات'; // الافتراضي
    }

    return BlocConsumer<CampaignBloc, CampaignState>(
      listener: (context, state) {
        if (state is CampaignError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        List<CampaignEntity>? campaignsToDisplay;
        bool isLoading = false;
        String? errorMessage;

        if (state is CampaignLoading) {
          isLoading = true;
          campaignsToDisplay = state.oldCampaigns;
        } else if (state is CampaignsLoaded) {
          campaignsToDisplay = state.campaigns;
        } else if (state is CampaignError) {
          errorMessage = state.message;
          campaignsToDisplay = state.oldCampaigns;
        } else if (state is CampaignDetailsLoaded) {
          campaignsToDisplay = context
              .read<CampaignBloc>()
              .lastLoadedAllCampaigns;
        } else if (state is CampaignInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        List<CampaignEntity> finalFilteredCampaigns = [];
        if (campaignsToDisplay != null) {
          if (statusFilter == 'جميع الحملات') {
            finalFilteredCampaigns = campaignsToDisplay;
          } else if (statusFilter == 'نشطة') {
            finalFilteredCampaigns = campaignsToDisplay
                .where((c) => c.status == 'نشطة')
                .toList();
          } else if (statusFilter == 'منجزة') {
            finalFilteredCampaigns = campaignsToDisplay
                .where((c) => c.status == 'منجزة')
                .toList();
          } else {
            finalFilteredCampaigns = campaignsToDisplay;
          }
        }

        if (finalFilteredCampaigns.isEmpty) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'اسحب للتحديث لجلب الحملات.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'لا توجد حملات ${statusFilter} مطابقة لفلترك الحالي أو نص البحث.',
                textAlign: TextAlign.center,
              ),
            );
          }
        }

        return RefreshIndicator(
          onRefresh: () async {
            _loadCampaigns();
          },
          child: Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: finalFilteredCampaigns.length,
                itemBuilder: (context, index) {
                  final campaign = finalFilteredCampaigns[index];
                  return CampaignCard(
                    campaign: campaign,
                    color1: Colors.greenAccent,
                    color2: Colors.white,
                  );
                },
              ),
              if (isLoading)
                const Opacity(
                  opacity: 0.8,
                  child: ModalBarrier(
                    dismissible: false,
                    color: Colors.black38,
                  ),
                ),
              if (isLoading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }
}
