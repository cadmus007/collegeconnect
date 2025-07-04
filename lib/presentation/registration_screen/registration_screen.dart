import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/registration_form_widget.dart';
import './widgets/registration_header_widget.dart';
import './widgets/social_registration_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String _selectedStudentType = 'High School';
  int _selectedGraduationYear = DateTime.now().year + 1;

  // Validation state
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateFullName(String value) {
    setState(() {
      if (value.isEmpty) {
        _fullNameError = 'Full name is required';
      } else if (value.trim().split(' ').length < 2) {
        _fullNameError = 'Please enter your full name';
      } else if (value.length < 3) {
        _fullNameError = 'Name must be at least 3 characters';
      } else {
        _fullNameError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
      } else {
        _passwordError = null;
        _calculatePasswordStrength(value);
      }
    });
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    String strengthText = '';

    if (password.length >= 8) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;

    if (strength <= 0.2) {
      strengthText = 'Weak';
    } else if (strength <= 0.6) {
      strengthText = 'Medium';
    } else {
      strengthText = 'Strong';
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
    });
  }

  bool get _isFormValid {
    return _fullNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _acceptTerms;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration logic
      if (_emailController.text.toLowerCase() == 'test@example.com') {
        _showErrorSnackBar(
            'Email already exists. Please use a different email.');
        return;
      }

      // Success - show welcome animation and navigate
      _showSuccessAnimation();
    } catch (e) {
      _showErrorSnackBar(
          'Registration failed. Please check your internet connection and try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 10.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Welcome to CollegeConnect!',
                style: AppTheme.lightTheme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Your account has been created successfully. Let\'s find your perfect college!',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(
                        context, '/college-browse-screen');
                  },
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSocialRegistration(String provider) {
    setState(() {
      _isLoading = true;
    });

    // Simulate social registration
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      _showSuccessAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // Header
              RegistrationHeaderWidget(),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),

                      // Registration Form
                      RegistrationFormWidget(
                        formKey: _formKey,
                        fullNameController: _fullNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        isPasswordVisible: _isPasswordVisible,
                        isConfirmPasswordVisible: _isConfirmPasswordVisible,
                        acceptTerms: _acceptTerms,
                        selectedStudentType: _selectedStudentType,
                        selectedGraduationYear: _selectedGraduationYear,
                        fullNameError: _fullNameError,
                        emailError: _emailError,
                        passwordError: _passwordError,
                        confirmPasswordError: _confirmPasswordError,
                        passwordStrength: _passwordStrength,
                        passwordStrengthText: _passwordStrengthText,
                        isFormValid: _isFormValid,
                        isLoading: _isLoading,
                        onPasswordVisibilityToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        onConfirmPasswordVisibilityToggle: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                        onTermsChanged: (value) {
                          setState(() {
                            _acceptTerms = value ?? false;
                          });
                        },
                        onStudentTypeChanged: (value) {
                          setState(() {
                            _selectedStudentType = value;
                          });
                        },
                        onGraduationYearChanged: (value) {
                          setState(() {
                            _selectedGraduationYear = value;
                          });
                        },
                        onFullNameChanged: _validateFullName,
                        onEmailChanged: _validateEmail,
                        onPasswordChanged: _validatePassword,
                        onConfirmPasswordChanged: _validateConfirmPassword,
                        onRegistrationPressed: _handleRegistration,
                      ),

                      SizedBox(height: 4.h),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppTheme.lightTheme.colorScheme.outline,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Text(
                              'or',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppTheme.lightTheme.colorScheme.outline,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Social Registration
                      SocialRegistrationWidget(
                        isLoading: _isLoading,
                        onSocialRegistration: _handleSocialRegistration,
                      ),

                      SizedBox(height: 4.h),

                      // Sign In Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/login-screen');
                            },
                            child: Text(
                              'Sign In',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
