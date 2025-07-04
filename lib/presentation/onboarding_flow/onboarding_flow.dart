import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Discover Your Dream College",
      "description":
          "Browse thousands of colleges with detailed information, photos, and admission requirements all in one place.",
      "image":
          "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "icon": "school"
    },
    {
      "title": "Track Your Applications",
      "description":
          "Manage all your college applications, deadlines, and documents with our smart tracking system.",
      "image":
          "https://images.pexels.com/photos/590016/pexels-photo-590016.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "icon": "assignment"
    },
    {
      "title": "Compare & Choose Wisely",
      "description":
          "Compare colleges side-by-side with fees, courses, ratings, and make informed decisions for your future.",
      "image":
          "https://cdn.pixabay.com/photo/2016/11/29/06/15/adult-1867743_1280.jpg",
      "icon": "compare_arrows"
    }
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _triggerHapticFeedback();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _triggerHapticFeedback();
    }
  }

  void _triggerHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _getStarted() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _signIn() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _triggerHapticFeedback();
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return _OnboardingPageWidget(
                    title: data["title"] as String,
                    description: data["description"] as String,
                    imageUrl: data["image"] as String,
                    iconName: data["icon"] as String,
                    onNext: _nextPage,
                    onPrevious: _previousPage,
                    isFirstPage: index == 0,
                    isLastPage: index == _onboardingData.length - 1,
                  );
                },
              ),
            ),

            // Page indicator and navigation
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              child: Column(
                children: [
                  // Page indicator dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 1.w),
                        width: _currentPage == index ? 8.w : 2.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Action buttons
                  _currentPage == _onboardingData.length - 1
                      ? Column(
                          children: [
                            // Get Started button
                            SizedBox(
                              width: double.infinity,
                              height: 6.h,
                              child: ElevatedButton(
                                onPressed: _getStarted,
                                style: AppTheme
                                    .lightTheme.elevatedButtonTheme.style
                                    ?.copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                                child: Text(
                                  'Get Started',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 2.h),

                            // Sign In link
                            TextButton(
                              onPressed: _signIn,
                              child: Text(
                                'Already have an account? Sign In',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: AppTheme.lightTheme.elevatedButtonTheme.style
                                ?.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'arrow_forward',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String iconName;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isFirstPage;
  final bool isLastPage;

  const _OnboardingPageWidget({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.iconName,
    required this.onNext,
    required this.onPrevious,
    required this.isFirstPage,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 0 && !isFirstPage) {
            onPrevious();
          } else if (details.primaryVelocity! < 0 && !isLastPage) {
            onNext();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            // Hero illustration
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: 40.h,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background illustration
                    Container(
                      width: 80.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CustomImageWidget(
                          imageUrl: imageUrl,
                          width: 80.w,
                          height: 35.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Overlay with icon
                    Positioned(
                      bottom: 2.h,
                      right: 4.w,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Content section
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Headline
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
