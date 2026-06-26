import 'package:flutter/cupertino.dart'; // Added for CupertinoSwitch
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _masterEnable = true;
  bool _messagesEnabled = true;
  bool _marketingEnabled = false;
  bool _emailEnabled = false;

  int get _enabledCount {
    int count = 0;
    if (_messagesEnabled) count++;
    if (_marketingEnabled) count++;
    if (_emailEnabled) count++;
    return count;
  }

  void _onMasterToggle(bool value) {
    setState(() {
      _masterEnable = value;
      if (!value) {
        // Turning off master disables all individual types
        _messagesEnabled = false;
        _marketingEnabled = false;
        _emailEnabled = false;
      } else {
        // Turning on master enables at least the message notifications by default
        _messagesEnabled = true;
      }
    });
  }

  void _onSubToggle(String type, bool value) {
    if (!_masterEnable && value) {
      // If master is disabled and user tries to enable any sub-notification,
      // we auto-enable the master toggle first
      setState(() {
        _masterEnable = true;
      });
    }

    setState(() {
      switch (type) {
        case 'messages':
          _messagesEnabled = value;
          break;
        case 'marketing':
          _marketingEnabled = value;
          break;
        case 'email':
          _emailEnabled = value;
          break;
      }

      // If all sub-notifications are toggled off, master is also toggled off
      if (!_messagesEnabled && !_marketingEnabled && !_emailEnabled) {
        _masterEnable = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70.w,
          leading: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // Title
              Text(
                'Notification Settings',
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              // Description
              Text(
                'Control which updates and activities you want to receive',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.grey[500],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32.h),

              // 1. Master Enable Notifications Card
              _buildMasterCard(),

              SizedBox(height: 24.h),
              // Subtitle Label
              Text(
                'Notification Types',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),

              // 2. Individual Notification Sub-options
              _buildSubOptionCard(
                type: 'messages',
                title: 'New Messages',
                subtitle: 'When someone sends you a message',
                value: _messagesEnabled,
              ),
              SizedBox(height: 14.h),

              _buildSubOptionCard(
                type: 'marketing',
                title: 'Marketing',
                subtitle: 'Promotions and tips from Wasel Canada',
                value: _marketingEnabled,
              ),
              SizedBox(height: 14.h),

              _buildSubOptionCard(
                type: 'email',
                title: 'Email Notification',
                subtitle: 'Receive updates via email',
                value: _emailEnabled,
              ),

              const Spacer(),

              // 3. Bottom Auto-save Warning Banner
              _buildAutoSaveBanner(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasterCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bell Icon
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3D7A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: Color(0xFF0F3D7A),
            ),
          ),
          SizedBox(width: 14.w),

          // Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable Notifications',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$_enabledCount of 3 enabled',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Master Cupertino Switch
          CupertinoSwitch(
            value: _masterEnable,
            onChanged: _onMasterToggle,
            activeColor: const Color(0xFF0F3D7A),
          ),
        ],
      ),
    );
  }

  Widget _buildSubOptionCard({
    required String type,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sub titles description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12.5.sp,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Individual Cupertino Switch
          CupertinoSwitch(
            value: value,
            onChanged: (newValue) => _onSubToggle(type, newValue),
            activeColor: const Color(0xFF0F3D7A),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoSaveBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9ED),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFECC8), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: const Color(0xFFB7791F),
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Changes to your notification preferences are saved automatically.',
              style: GoogleFonts.inter(
                color: const Color(0xFFB7791F),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}