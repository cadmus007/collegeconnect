import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';
import '../presentation/college_browse_screen/college_browse_screen.dart';
import '../presentation/college_detail_screen/college_detail_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String loginScreen = '/login-screen';
  static const String registrationScreen = '/registration-screen';
  static const String collegeBrowseScreen = '/college-browse-screen';
  static const String collegeDetailScreen = '/college-detail-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    loginScreen: (context) => const LoginScreen(),
    registrationScreen: (context) => const RegistrationScreen(),
    collegeBrowseScreen: (context) => const CollegeBrowseScreen(),
    collegeDetailScreen: (context) => const CollegeDetailScreen(),
    // TODO: Add your other routes here
  };
}
