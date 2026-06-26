import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/features/profile/widgets/custom_app_version_footer.dart';
import 'package:abojude_flutter/features/profile/presentation/language_screen.dart';
import 'package:abojude_flutter/features/profile/presentation/contact_us_screen.dart';
import 'package:abojude_flutter/features/profile/presentation/about_wasel_canada_screen.dart';

class GuestUserProfile extends StatefulWidget {
  const GuestUserProfile({super.key});

  @override
  State<GuestUserProfile> createState() => _GuestUserProfileState();
}

class _GuestUserProfileState extends State<GuestUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Screen Title Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Text(
                  'Profile',
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // 2. Banner Card
              Container(
                width: double.infinity,
                height: 130.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3D7A),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F3D7A).withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // White Logo Icon
                      _buildLogoIcon(),
                      SizedBox(width: 10.w),
                      Text(
                        'WASEL CANADA',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // 3. Header Text
              Center(
                child: Column(
                  children: [
                    Text(
                      'Sign In/Create Account Now',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F3D7A),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'Please sign in or create an account to access your profile, manage activities, and enjoy the full Wasel Canada experience.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // 4. Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    // Sign In Button
                    _buildButton(
                      text: 'Sign In',
                      backgroundColor: const Color(0xFF0F3D7A),
                      textColor: Colors.white,
                      onPressed: () {
                        NavigationService.navigateTo(Routes.loginScreen);
                      },
                    ),
                    SizedBox(height: 12.h),

                    // Create Account Button
                    _buildButton(
                      text: 'Create Account',
                      backgroundColor: Colors.white,
                      textColor: const Color(0xFF0F3D7A),
                      borderColor: const Color(0xFFE2E8F0),
                      onPressed: () {
                        NavigationService.navigateTo(Routes.registerScreen);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // 5. Settings and Support Section
              Padding(
                padding: EdgeInsets.only(left: 20.w, bottom: 8.h),
                child: Text(
                  'Settings and Support',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // 6. Settings and Support Options Group Card
              _buildGroupCard([
                _buildTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3D7A).withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'English',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F3D7A),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => const LanguageScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.headset_mic_outlined,
                  title: 'Contact Us',
                  onTap: () {
                    Get.to(() => const ContactUsScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About Wasel Canada',
                  onTap: () {
                    Get.to(() => const AboutWaselCanadaScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () {},
                ),
              ]),

              // 7. Version Footer
              const AppVersionFooter(
                version: 'Wasel Canada v1.0.0',
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  // Draw the custom logo icon W with dots next to it
  Widget _buildLogoIcon() {
    return Container(
      width: 36.w,
      height: 36.h,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo base arcs drawing or icons
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/icons/Logos.png'),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          // Small dots at the top of the logo
          Positioned(
            top: 2.h,
            left: 4.w,
            child: Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: 2.h,
            right: 4.w,
            child: Container(
              width: 4.r,
              height: 4.r,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF0F3D7A)).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFF0F3D7A),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 14.w),

            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: titleColor ?? Colors.black87,
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Optional Trailing element (Language badge, etc.)
            if (trailing != null) ...[
              trailing,
              SizedBox(width: 8.w),
            ],

            // Chevron Right
            Icon(
              Icons.chevron_right_rounded,
              color: titleColor != null ? Colors.red[200] : Colors.grey[400],
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F3F5),
      indent: 16,
      endIndent: 16,
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
                  color: backgroundColor.withValues(alpha: 0.15),
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