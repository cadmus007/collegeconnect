import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _screenFadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Mock user authentication status
  final bool _isAuthenticated = false; // Mock value
  final bool _isFirstTime = true; // Mock value for onboarding

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Screen fade animation for transition
    _screenFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchCollegeDataCache(),
        _prepareSearchIndices(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for minimum splash duration
      await Future.delayed(const Duration(milliseconds: 2500));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
      });

      // Show retry option after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _hasError) {
          _showRetryOption();
        }
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate checking authentication
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _fetchCollegeDataCache() async {
    // Simulate fetching college data cache
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _prepareSearchIndices() async {
    // Simulate preparing search indices
    await Future.delayed(const Duration(milliseconds: 400));
  }

  void _navigateToNextScreen() {
    _fadeAnimationController.forward().then((_) {
      if (!mounted) return;

      String nextRoute;
      if (_isAuthenticated) {
        // Authenticated users go directly to college browse screen
        nextRoute = '/college-browse-screen';
      } else if (_isFirstTime) {
        // New users see onboarding flow
        nextRoute = '/onboarding-flow';
      } else {
        // Returning non-authenticated users reach login screen
        nextRoute = '/login-screen';
      }

      Navigator.pushReplacementNamed(context, nextRoute);
    });
  }

  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            _errorMessage,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _hasError = false;
                  _errorMessage = '';
                });
                _initializeApp();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: AnimatedBuilder(
        animation: _screenFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _screenFadeAnimation.value,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.8),
                    AppTheme.lightTheme.colorScheme.secondary,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer to center content
                    SizedBox(height: 20.h),

                    // Animated Logo Section
                    Expanded(
                      flex: 3,
                      child: AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Opacity(
                              opacity: _logoFadeAnimation.value,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // App Logo
                                  Container(
                                    width: 25.w,
                                    height: 25.w,
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          blurRadius: 20.0,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: CustomIconWidget(
                                        iconName: 'school',
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        size: 12.w,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 4.h),

                                  // App Name
                                  Text(
                                    'CollegeConnect',
                                    style: AppTheme
                                        .lightTheme.textTheme.headlineLarge
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),

                                  SizedBox(height: 1.h),

                                  // App Tagline
                                  Text(
                                    'Discover Your Future',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface
                                          .withValues(alpha: 0.9),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Loading Section
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _hasError
                              ? Column(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'error_outline',
                                      color: AppTheme
                                          .lightTheme.colorScheme.surface,
                                      size: 8.w,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Connection Error',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    // Loading Indicator
                                    SizedBox(
                                      width: 8.w,
                                      height: 8.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppTheme
                                              .lightTheme.colorScheme.surface,
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 3.h),

                                    // Loading Text
                                    Text(
                                      _isInitialized
                                          ? 'Ready to explore!'
                                          : 'Preparing your college journey...',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface
                                            .withValues(alpha: 0.8),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    // Bottom Spacing
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
