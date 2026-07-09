import 'package:abojude_flutter/common_widgets/custom_button.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../navigation_menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------- Back Button ---------------
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: const Color(0xFF1F2937),
                        size: 24.w,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // --------------- Title ---------------
                  Text(
                    'Welcome Back',
                    style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // --------------- Subtitle ---------------
                  Text(
                    'Sign in to your Wasel Canada account',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // --------------- Email Input Field ---------------
                  _buildInputField(
                    label: 'Email address',
                    hintText: 'your@email.com',
                    prefixIconPath: 'assets/icons/email.svg',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  // --------------- Password Input Field ---------------
                  _buildInputField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    prefixIconPath: 'assets/icons/password.svg',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 20.w,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 12.h),

                  // --------------- Remember Me & Forget Password Row ---------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rememberMe = !_rememberMe;
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: _rememberMe
                                    ? const Color(0xFF1B8E5A)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(
                                  color: _rememberMe
                                      ? const Color(0xFF1B8E5A)
                                      : const Color(0xFFD1D5DB),
                                  width: 1.5,
                                ),
                              ),
                              child: _rememberMe
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14.w,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Remember me',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateTo(
                            Routes.forgetPasswordScreen,
                          );
                        },
                        child: Text(
                          'Forget password?',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: const Color(0xFF1B8E5A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 28.h),

                  // --------------- Login Button ---------------
                  ValueListenableBuilder<bool>(
                    valueListenable: loginRxObj.isLoading,
                    builder: (context, isLoading, child) {
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await loginRxObj.loginRx(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  if (success) {
                                    Get.offAll(NavigationMenu());
                                  }
                                }
                              },
                        child: Container(
                          width: double.infinity,
                          height: 52.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF03045E),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),

                  // --------------- OR Separator ---------------
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE5E7EB),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE5E7EB),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --------------- Social Login Buttons ---------------
                  CustomButton(
                    icon: SvgPicture.asset(
                      'assets/icons/google.svg',
                      width: 22.w,
                      height: 22.w,
                    ),
                    onTap: () {
                      // Google Auth Action
                    },
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    text: 'Continue with Google',
                  ),
                  SizedBox(height: 14.h),
                  CustomButton(
                    text: 'Continue with Apple',
                    icon: SvgPicture.asset(
                      'assets/icons/apple.svg',
                      width: 22.w,
                      height: 22.w,
                    ),
                    onTap: () {
                      // Apple Auth Action
                    },
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),

                  SizedBox(height: 32.h),

                  // --------------- Footer Sign Up ---------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: const Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateTo(Routes.registerScreen);
                        },
                        child: Text(
                          'Sign UP',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: const Color(0xFF1B8E5A),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required String prefixIconPath,
    TextEditingController? controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              color: const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 15.sp,
                color: const Color(0xFF9CA3AF),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  prefixIconPath,
                  width: 15.w,
                  height: 15.w,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF9CA3AF),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: Color(0xFF03045E),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
