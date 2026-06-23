import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import 'package:abojude_flutter/helpers/di.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/constants/app_constants.dart';
import 'package:abojude_flutter/networks/stream_cleaner.dart';
import 'my_listings_screen.dart';
import 'favorites_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'language_screen.dart';
import 'blocked_users_screen.dart';
import 'notification_settings_screen.dart';
import 'contact_us_screen.dart';
import 'about_wasel_canada_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock User Info
  final String _name = "Hefzur Rahman";
  final String _email = "hefzurrahman0930@gmail.com";
  final String _initials = "HR";

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

              // 2. Banner and Avatar Card Stack
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Blue Header Banner
                  Container(
                    width: double.infinity,
                    height: 130.h,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F3D7A),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Custom White Logo Icon (Stylized W shape representation)
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

                  // Overlapping Avatar Card
                  Positioned(
                    bottom: -45.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 46.r,
                          backgroundColor: const Color(0xFFE9ECEF),
                          child: Text(
                            _initials,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF0F3D7A),
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Spacer for the overlapping avatar
              SizedBox(height: 54.h),

              // 3. User Name & Email Subheaders
              Center(
                child: Column(
                  children: [
                    Text(
                      _name,
                      style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _email,
                      style: GoogleFonts.inter(
                        color: Colors.grey[500],
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // 4. Section: My Content
              _buildSectionTitle('My Content'),
              _buildGroupCard([
                _buildTile(
                  icon: Icons.list_alt_rounded,
                  title: 'My Listings',
                  onTap: () {
                    Get.to(() => const MyListingsScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.favorite_border_rounded,
                  title: 'Favorites',
                  onTap: () {
                    Get.to(() => const FavoritesScreen());
                  },
                ),
              ]),

              // 5. Section: Account
              _buildSectionTitle('Account'),
              _buildGroupCard([
                _buildTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile',
                  onTap: () {
                    Get.to(() => const EditProfileScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () {
                    Get.to(() => const ChangePasswordScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3D7A).withOpacity(0.06),
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
                  icon: Icons.person_remove_outlined,
                  title: 'Block User',
                  onTap: () {
                    Get.to(() => const BlockedUsersScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notification Settings',
                  onTap: () {
                    Get.to(() => const NotificationSettingsScreen());
                  },
                ),
                _buildDivider(),
                _buildTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete Account',
                  titleColor: Colors.red[400],
                  iconColor: Colors.red[300],
                  onTap: () {},
                ),
              ]),

              // 6. Section: Support
              _buildSectionTitle('Support'),
              _buildGroupCard([
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

              SizedBox(height: 24.h),

              // 7. Logout Action Button
              Center(child: _buildLogoutButton(context)),

              SizedBox(height: 36.h),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13.sp,
          color: Colors.grey[500],
          fontWeight: FontWeight.w600,
        ),
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
            color: Colors.black.withOpacity(0.015),
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
                color: (iconColor ?? const Color(0xFF0F3D7A)).withOpacity(0.06),
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

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFFFFA3A3), width: 1.2),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.exit_to_app_rounded,
              color: Colors.red[400],
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Log Out',
              style: GoogleFonts.inter(
                color: Colors.red[400],
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.red[400],
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }



// Logout confirmation pop-up
  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            'Log Out',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.black87,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of Wasel Canada?',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            // Cancel Button
            CupertinoDialogAction(
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            // Log Out Button (Destructive)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Clear session tokens and auth states
                await totalDataClean();
                appData.remove(kKeyAccessToken);

                // Redirect user to the welcome screen
                NavigationService.navigateToUntilReplacement(Routes.welcomeScreen);
              },
              child: Text(
                'Log Out',
                style: GoogleFonts.inter(
                  color: Colors.red[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
