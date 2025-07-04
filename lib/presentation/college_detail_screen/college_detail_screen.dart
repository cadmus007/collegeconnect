import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/apply_now_bottom_sheet_widget.dart';
import './widgets/college_action_buttons_widget.dart';
import './widgets/college_hero_section_widget.dart';
import './widgets/college_info_header_widget.dart';
import './widgets/college_reviews_widget.dart';
import './widgets/college_section_card_widget.dart';

class CollegeDetailScreen extends StatefulWidget {
  const CollegeDetailScreen({super.key});

  @override
  State<CollegeDetailScreen> createState() => _CollegeDetailScreenState();
}

class _CollegeDetailScreenState extends State<CollegeDetailScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  bool _isHeaderVisible = true;
  bool _isFavorite = false;
  bool _isInCompareList = false;

  // Mock college data
  final Map<String, dynamic> collegeData = {
    "id": 1,
    "name": "Stanford University",
    "location": "Stanford, California, USA",
    "type": "Private Research University",
    "established": 1885,
    "ranking": "#3 National Universities",
    "rating": 4.8,
    "totalReviews": 2847,
    "images": [
      "https://images.pexels.com/photos/207692/pexels-photo-207692.jpeg",
      "https://images.pexels.com/photos/1454360/pexels-photo-1454360.jpeg",
      "https://images.pexels.com/photos/159490/yale-university-landscape-universities-schools-159490.jpeg",
      "https://images.pexels.com/photos/1438081/pexels-photo-1438081.jpeg"
    ],
    "description":
        """Stanford University is a private research university in Stanford, California. The campus occupies 8,180 acres, among the largest in the United States, and enrolls over 17,000 students. Stanford is ranked among the world's top universities.""",
    "highlights": [
      "World-class faculty and research facilities",
      "Silicon Valley location with tech industry connections",
      "Need-blind admissions for US students",
      "Strong alumni network in technology and business"
    ],
    "tuitionFee": "\$56,169",
    "totalCost": "\$78,218",
    "acceptanceRate": "4.3%",
    "studentFacultyRatio": "5:1",
    "totalStudents": "17,249",
    "internationalStudents": "22%",
    "applicationDeadline": "January 5, 2024",
    "programs": [
      "Computer Science",
      "Engineering",
      "Business Administration",
      "Medicine",
      "Law",
      "Education"
    ],
    "facilities": [
      "State-of-the-art laboratories",
      "Multiple libraries and research centers",
      "Athletic facilities and recreation centers",
      "Student housing and dining halls"
    ],
    "contactEmail": "admissions@stanford.edu",
    "contactPhone": "+1-650-723-2091",
    "website": "https://www.stanford.edu"
  };

  final List<Map<String, dynamic>> studentReviews = [
    {
      "id": 1,
      "studentName": "Sarah Johnson",
      "program": "Computer Science",
      "year": "Class of 2023",
      "rating": 5.0,
      "review":
          "Stanford has exceeded all my expectations. The faculty is world-class and the research opportunities are incredible.",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "date": "2 months ago"
    },
    {
      "id": 2,
      "studentName": "Michael Chen",
      "program": "Engineering",
      "year": "Class of 2024",
      "rating": 4.5,
      "review":
          "Great university with amazing resources. The campus is beautiful and the Silicon Valley location provides excellent internship opportunities.",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "date": "1 month ago"
    },
    {
      "id": 3,
      "studentName": "Emily Rodriguez",
      "program": "Business Administration",
      "year": "Class of 2022",
      "rating": 5.0,
      "review":
          "The MBA program at Stanford is top-notch. The networking opportunities and career support are unmatched.",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "date": "3 weeks ago"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && _isHeaderVisible) {
      setState(() {
        _isHeaderVisible = false;
      });
    } else if (_scrollController.offset <= 200 && !_isHeaderVisible) {
      setState(() {
        _isHeaderVisible = true;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleCompare() {
    setState(() {
      _isInCompareList = !_isInCompareList;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isInCompareList
            ? 'Added to compare list'
            : 'Removed from compare list'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareCollege() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing college information...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showApplyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApplyNowBottomSheetWidget(
        collegeName: collegeData["name"] as String,
        applicationDeadline: collegeData["applicationDeadline"] as String,
      ),
    );
  }

  void _callCollege() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${collegeData["contactPhone"]}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 30.h,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.lightTheme.primaryColor,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _shareCollege,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              SizedBox(width: 2.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CollegeHeroSectionWidget(
                images: (collegeData["images"] as List).cast<String>(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CollegeInfoHeaderWidget(
                  name: collegeData["name"] as String,
                  location: collegeData["location"] as String,
                  type: collegeData["type"] as String,
                  ranking: collegeData["ranking"] as String,
                  rating: collegeData["rating"] as double,
                  totalReviews: collegeData["totalReviews"] as int,
                ),
                SizedBox(height: 2.h),
                CollegeActionButtonsWidget(
                  isFavorite: _isFavorite,
                  isInCompareList: _isInCompareList,
                  onApplyPressed: _showApplyBottomSheet,
                  onFavoritePressed: _toggleFavorite,
                  onComparePressed: _toggleCompare,
                ),
                SizedBox(height: 3.h),
                _buildTabSection(),
                SizedBox(height: 2.h),
                _buildTabContent(),
                SizedBox(height: 3.h),
                CollegeReviewsWidget(
                  reviews: studentReviews,
                  averageRating: collegeData["rating"] as double,
                  totalReviews: collegeData["totalReviews"] as int,
                ),
                SizedBox(height: 3.h),
                _buildContactSection(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: AppTheme.lightTheme.primaryColor,
        labelColor: AppTheme.lightTheme.primaryColor,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Academics'),
          Tab(text: 'Admissions'),
          Tab(text: 'Campus Life'),
          Tab(text: 'Costs'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildAcademicsTab(),
          _buildAdmissionsTab(),
          _buildCampusLifeTab(),
          _buildCostsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CollegeSectionCardWidget(
            title: 'About',
            content: collegeData["description"] as String,
            isExpandable: true,
          ),
          SizedBox(height: 2.h),
          CollegeSectionCardWidget(
            title: 'Highlights',
            content: (collegeData["highlights"] as List).join('\n• '),
            isExpandable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CollegeSectionCardWidget(
            title: 'Programs Offered',
            content: (collegeData["programs"] as List).join('\n• '),
            isExpandable: true,
          ),
          SizedBox(height: 2.h),
          CollegeSectionCardWidget(
            title: 'Academic Statistics',
            content:
                '''Student-Faculty Ratio: ${collegeData["studentFacultyRatio"]}
Total Students: ${collegeData["totalStudents"]}
International Students: ${collegeData["internationalStudents"]}
University Ranking: ${collegeData["ranking"]}''',
            isExpandable: false,
          ),
        ],
      ),
    );
  }

  Widget _buildAdmissionsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CollegeSectionCardWidget(
            title: 'Admission Requirements',
            content: '''Acceptance Rate: ${collegeData["acceptanceRate"]}
Application Deadline: ${collegeData["applicationDeadline"]}

Required Documents:
• High School Transcript
• SAT/ACT Scores
• Letters of Recommendation
• Personal Essay
• Application Fee''',
            isExpandable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCampusLifeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CollegeSectionCardWidget(
            title: 'Campus Facilities',
            content: (collegeData["facilities"] as List).join('\n• '),
            isExpandable: true,
          ),
          SizedBox(height: 2.h),
          CollegeSectionCardWidget(
            title: 'Student Life',
            content: '''Campus Size: 8,180 acres
Student Organizations: 650+
Athletic Teams: 36 varsity sports
Housing: On-campus housing available
Dining: Multiple dining halls and cafes''',
            isExpandable: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCostsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CollegeSectionCardWidget(
            title: 'Tuition & Fees',
            content: '''Annual Tuition: ${collegeData["tuitionFee"]}
Total Cost of Attendance: ${collegeData["totalCost"]}

Breakdown:
• Tuition & Fees: ${collegeData["tuitionFee"]}
• Room & Board: \$17,255
• Books & Supplies: \$1,245
• Personal Expenses: \$2,649
• Transportation: \$900''',
            isExpandable: false,
          ),
          SizedBox(height: 2.h),
          CollegeSectionCardWidget(
            title: 'Financial Aid',
            content: '''• Need-blind admissions for US students
• 100% of demonstrated need met
• Average need-based aid: \$53,000
• Merit-based scholarships available
• Work-study programs offered''',
            isExpandable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
          Text(
            'Contact Information',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  collegeData["contactEmail"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  collegeData["contactPhone"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: _callCollege,
                child: Text('Call'),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'language',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  collegeData["website"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
