import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';

class ContinueAsGuest extends StatefulWidget {
  final String? title;
  final String? subtitle;

  const ContinueAsGuest({super.key, this.title, this.subtitle});

  @override
  State<ContinueAsGuest> createState() => _ContinueAsGuestState();
}

class _ContinueAsGuestState extends State<ContinueAsGuest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular icon container
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: AppColor.c03045E.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 44.sp,
                      color: AppColor.c03045E,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),

                // Title
                Text(
                  widget.title ?? 'Sign In To Access Message',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.c03045E,
                  ),
                ),
                SizedBox(height: 12.h),

                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    widget.subtitle ??
                        'Create an account or sign in to communicate with buyers, sellers, businesses, and service providers',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF797A7C),
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 48.h),

                // Sign In Button
                _buildButton(
                  text: 'Sign In',
                  backgroundColor: AppColor.c03045E,
                  textColor: Colors.white,
                  onPressed: () {
                    NavigationService.navigateTo(Routes.loginScreen);
                  },
                ),
                SizedBox(height: 16.h),

                // Create Account Button
                _buildButton(
                  text: 'Create Account',
                  backgroundColor: Colors.white,
                  textColor: AppColor.c03045E,
                  borderColor: const Color(0xFFE2E8F0),
                  onPressed: () {
                    NavigationService.navigateTo(Routes.registerScreen);
                  },
                ),
                SizedBox(height: 24.h),

                // Continue Browsing Text Button
                GestureDetector(
                  onTap: () {
                    if (NavigationService.goBeBack) {
                      NavigationService.goBack;
                    } else {
                      NavigationService.navigateToReplacement(
                        Routes.navigationMenu,
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      'Continue Browsing',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF797A7C),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: borderColor != null
            ? Border.all(color: borderColor, width: 1.r)
            : null,
        boxShadow: backgroundColor != Colors.white
            ? [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
