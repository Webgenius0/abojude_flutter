import 'package:flutter/cupertino.dart'; // Added for CupertinoSwitch
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _masterEnable = false;
  bool _messagesEnabled = false;
  bool _marketingEnabled = false;
  bool _emailEnabled = false;

  int get _enabledCount {
    int count = 0;
    if (_messagesEnabled) count++;
    if (_marketingEnabled) count++;
    if (_emailEnabled) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final model = await getNotificationSettingRxObj.getNotificationSetting();
      if (model.data != null) {
        setState(() {
          _masterEnable = model.data!.allNotification ?? false;
          _messagesEnabled = model.data!.newMessage ?? false;
          _marketingEnabled = model.data!.marketing ?? false;
          _emailEnabled = model.data!.emailNotification ?? false;
        });
      }
    } catch (e) {
      // Handled in rx.dart via toast/error sink
    }
  }

  void _onMasterToggle(bool value) {
    setState(() {
      _masterEnable = value;
      // If master is turned on, turn on all options.
      // If master is turned off, we don't automatically turn off all of them.
      if (value) {
        _messagesEnabled = true;
        _marketingEnabled = true;
        _emailEnabled = true;
      }
    });
    _saveSettings();
  }

  void _onSubToggle(String type, bool value) {
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

      // If any individual switch is turned off, master switch must also be off
      if (!value) {
        _masterEnable = false;
      } else {
        // If all individual switches are turned on, master switch becomes on
        if (_messagesEnabled && _marketingEnabled && _emailEnabled) {
          _masterEnable = true;
        }
      }
    });
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    await updateNotificationSettingRxObj.updateNotificationSetting(
      allNotification: _masterEnable,
      newMessage: _messagesEnabled,
      marketing: _marketingEnabled,
      emailNotification: _emailEnabled,
    );
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
                  border: Border.all(
                    color: const Color(0xFFF1F3F5),
                    width: 1.5,
                  ),
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
        child: ValueListenableBuilder<bool>(
          valueListenable: getNotificationSettingRxObj.isLoading,
          builder: (context, isLoading, child) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF0F3D7A)),
              );
            }

            return ValueListenableBuilder<bool>(
              valueListenable: updateNotificationSettingRxObj.isLoading,
              builder: (context, isUpdating, child) {
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h),
                          // Title
                          Text(
                            'Notification Settings'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Description
                          Text(
                            'Control which updates and activities you want to receive'.tr,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // 1. Master Enable Notifications Card
                          _buildMasterCard(isUpdating),

                          SizedBox(height: 24.h),
                          // Subtitle Label
                          Text(
                            'Notification Types'.tr,
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
                            disabled: isUpdating,
                          ),
                          SizedBox(height: 14.h),

                          _buildSubOptionCard(
                            type: 'marketing',
                            title: 'Marketing',
                            subtitle: 'Promotions and tips from Wasel Canada',
                            value: _marketingEnabled,
                            disabled: isUpdating,
                          ),
                          SizedBox(height: 14.h),

                          _buildSubOptionCard(
                            type: 'email',
                            title: 'Email Notification',
                            subtitle: 'Receive updates via email',
                            value: _emailEnabled,
                            disabled: isUpdating,
                          ),

                          const Spacer(),

                          // 3. Bottom Auto-save Warning Banner
                          _buildAutoSaveBanner(),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                    if (isUpdating)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          color: Color(0xFF0F3D7A),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMasterCard(bool disabled) {
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
                  'Enable Notifications'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$_enabledCount'.tr + ' ' + 'of'.tr + ' ' + '3'.tr + ' ' + 'enabled'.tr,
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
            onChanged: disabled ? null : _onMasterToggle,
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
    required bool disabled,
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
                  title.tr,
                  style: GoogleFonts.inter(
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle.tr,
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
            onChanged: disabled
                ? null
                : (newValue) => _onSubToggle(type, newValue),
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
              'Changes to your notification preferences are saved automatically.'.tr,
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
