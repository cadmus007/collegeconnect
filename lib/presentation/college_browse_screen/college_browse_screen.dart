import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/college_card_widget.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/sort_bottom_sheet.dart';

class CollegeBrowseScreen extends StatefulWidget {
  const CollegeBrowseScreen({super.key});

  @override
  State<CollegeBrowseScreen> createState() => _CollegeBrowseScreenState();
}

class _CollegeBrowseScreenState extends State<CollegeBrowseScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isRefreshing = false;
  List<String> _activeFilters = ['Engineering', 'Under \$50k'];
  String _currentSort = 'Relevance';

  // Mock college data
  final List<Map<String, dynamic>> _colleges = [
    {
      "id": 1,
      "name": "Stanford University",
      "location": "Stanford, CA",
      "image":
          "https://images.unsplash.com/photo-1562774053-701939374585?fm=jpg&q=60&w=3000",
      "acceptanceRate": "4.3%",
      "tuition": "\$56,169",
      "rating": 4.8,
      "isFavorite": false,
      "type": "Private",
      "courses": ["Engineering", "Computer Science", "Business"],
      "description":
          "A leading research university known for innovation and academic excellence."
    },
    {
      "id": 2,
      "name": "MIT",
      "location": "Cambridge, MA",
      "image":
          "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?fm=jpg&q=60&w=3000",
      "acceptanceRate": "6.7%",
      "tuition": "\$53,790",
      "rating": 4.9,
      "isFavorite": true,
      "type": "Private",
      "courses": ["Engineering", "Technology", "Science"],
      "description":
          "World-renowned institute for technology and engineering education."
    },
    {
      "id": 3,
      "name": "UC Berkeley",
      "location": "Berkeley, CA",
      "image":
          "https://images.unsplash.com/photo-1607237138185-eedd9c632b0b?fm=jpg&q=60&w=3000",
      "acceptanceRate": "16.3%",
      "tuition": "\$44,007",
      "rating": 4.7,
      "isFavorite": false,
      "type": "Public",
      "courses": ["Engineering", "Liberal Arts", "Business"],
      "description":
          "Top public research university with diverse academic programs."
    },
    {
      "id": 4,
      "name": "Harvard University",
      "location": "Cambridge, MA",
      "image":
          "https://images.unsplash.com/photo-1549057446-9f5c6ac91a04?fm=jpg&q=60&w=3000",
      "acceptanceRate": "3.4%",
      "tuition": "\$54,002",
      "rating": 4.8,
      "isFavorite": false,
      "type": "Private",
      "courses": ["Liberal Arts", "Medicine", "Law"],
      "description":
          "Prestigious Ivy League university with rich academic tradition."
    },
    {
      "id": 5,
      "name": "Carnegie Mellon",
      "location": "Pittsburgh, PA",
      "image":
          "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?fm=jpg&q=60&w=3000",
      "acceptanceRate": "15.4%",
      "tuition": "\$58,924",
      "rating": 4.6,
      "isFavorite": true,
      "type": "Private",
      "courses": ["Computer Science", "Engineering", "Arts"],
      "description":
          "Leading university in computer science and technology innovation."
    },
    {
      "id": 6,
      "name": "University of Texas",
      "location": "Austin, TX",
      "image":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000",
      "acceptanceRate": "31.8%",
      "tuition": "\$39,322",
      "rating": 4.5,
      "isFavorite": false,
      "type": "Public",
      "courses": ["Engineering", "Business", "Liberal Arts"],
      "description":
          "Large public research university with strong academic programs."
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreColleges();
    }
  }

  Future<void> _loadMoreColleges() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshColleges() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _toggleFavorite(int collegeId) {
    setState(() {
      final collegeIndex = _colleges
          .indexWhere((college) => (college['id'] as int) == collegeId);
      if (collegeIndex != -1) {
        _colleges[collegeIndex]['isFavorite'] =
            !(_colleges[collegeIndex]['isFavorite'] as bool);
      }
    });
  }

  void _removeFilter(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        activeFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
          });
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        currentSort: _currentSort,
        onSortChanged: (sort) {
          setState(() {
            _currentSort = sort;
          });
        },
      ),
    );
  }

  void _navigateToCollegeDetail(Map<String, dynamic> college) {
    Navigator.pushNamed(context, '/college-detail-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: Column(
                children: [
                  // Tab bar
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Browse'),
                      Tab(text: 'Favorites'),
                      Tab(text: 'Applications'),
                      Tab(text: 'Profile'),
                    ],
                  ),

                  // Search bar and filter
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search colleges...',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: CustomIconWidget(
                                    iconName: 'search',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 5.w,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: _showFilterBottomSheet,
                          child: Container(
                            width: 12.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: CustomIconWidget(
                                    iconName: 'tune',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 5.w,
                                  ),
                                ),
                                if (_activeFilters.isNotEmpty)
                                  Positioned(
                                    top: 0.5.h,
                                    right: 1.w,
                                    child: Container(
                                      width: 4.w,
                                      height: 2.h,
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${_activeFilters.length}',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSecondary,
                                            fontSize: 8.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Active filters
                  if (_activeFilters.isNotEmpty)
                    Container(
                      height: 5.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _activeFilters.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 2.w),
                        itemBuilder: (context, index) {
                          return FilterChipWidget(
                            label: _activeFilters[index],
                            onRemove: () =>
                                _removeFilter(_activeFilters[index]),
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 1.h),
                ],
              ),
            ),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Browse tab
                  _buildBrowseTab(),

                  // Favorites tab
                  _buildFavoritesTab(),

                  // Applications tab
                  _buildApplicationsTab(),

                  // Profile tab
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating action button for sort
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showSortBottomSheet,
              child: CustomIconWidget(
                iconName: 'sort',
                color: AppTheme.lightTheme.colorScheme.onSecondary,
                size: 6.w,
              ),
            )
          : null,
    );
  }

  Widget _buildBrowseTab() {
    return RefreshIndicator(
      onRefresh: _refreshColleges,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 100.w > 600 ? 2 : 1,
                childAspectRatio: 100.w > 600 ? 0.8 : 1.2,
                crossAxisSpacing: 4.w,
                mainAxisSpacing: 4.w,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _colleges.length) {
                    return CollegeCardWidget(
                      college: _colleges[index],
                      onTap: () => _navigateToCollegeDetail(_colleges[index]),
                      onFavoriteToggle: () =>
                          _toggleFavorite(_colleges[index]['id'] as int),
                    );
                  } else {
                    return _buildSkeletonCard();
                  }
                },
                childCount: _colleges.length + (_isLoading ? 2 : 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final favoriteColleges =
        _colleges.where((college) => college['isFavorite'] as bool).toList();

    return favoriteColleges.isEmpty
        ? _buildEmptyState('No favorites yet',
            'Start exploring colleges to add them to your favorites')
        : ListView.separated(
            padding: EdgeInsets.all(4.w),
            itemCount: favoriteColleges.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              return CollegeCardWidget(
                college: favoriteColleges[index],
                onTap: () => _navigateToCollegeDetail(favoriteColleges[index]),
                onFavoriteToggle: () =>
                    _toggleFavorite(favoriteColleges[index]['id'] as int),
              );
            },
          );
  }

  Widget _buildApplicationsTab() {
    return _buildEmptyState('No applications yet',
        'Apply to colleges to track your application status here');
  }

  Widget _buildProfileTab() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          CircleAvatar(
            radius: 15.w,
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 15.w,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Student Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage your profile and preferences',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'school',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 2.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 1.5.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
