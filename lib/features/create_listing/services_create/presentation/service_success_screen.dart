import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_listing_model.dart';

class ServiceSuccessScreen extends StatelessWidget {
  final ServiceListingModel model;

  const ServiceSuccessScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 48.h),
                      // Large Green Success Circle
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEBFDF2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 72.w,
                            height: 72.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1B8E5A),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40.w,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Title
                      Text(
                        "Listing Submitted\nSuccessfully",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.textStyle22IbmPlexSansW600
                            .copyWith(
                              fontSize: 22.sp,
                              color: AppColor.c2E3227,
                              height: 1.3,
                            ),
                      ),
                      SizedBox(height: 12.h),

                      // Description
                      Text(
                        "Your service offering has been submitted and is currently awaiting admin approval. It will become visible to other users once approved.",
                        textAlign: TextAlign.center,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(
                              color: const Color(0xFF6B7280),
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                      ),
                      SizedBox(height: 32.h),

                      // Status Info Card
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFF3F4F6)),
                        ),
                        child: Column(
                          children: [
                            _buildStatusItem(
                              icon: Icons.access_time_outlined,
                              iconBg: const Color(0xFFEFF6FF),
                              iconColor: const Color(0xFF3B82F6),
                              title: "Review Time",
                              subtitle: "Usually within 24 hours",
                            ),
                            const Divider(color: Color(0xFFF3F4F6), height: 1),
                            _buildStatusItem(
                              icon: Icons.notifications_none_outlined,
                              iconBg: const Color(0xFFECFDF5),
                              iconColor: const Color(0xFF10B981),
                              title: "Notification",
                              subtitle:
                                  "You'll be notified when approved or rejected",
                            ),
                            const Divider(color: Color(0xFFF3F4F6), height: 1),
                            _buildStatusItem(
                              icon: Icons.visibility_off_outlined,
                              iconBg: const Color(0xFFFEF2F2),
                              iconColor: const Color(0xFFEF4444),
                              title: "Visibility",
                              subtitle: "Hidden from public until approved",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Pending Approval Status Chip
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(0xFFFFEDD5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "Status: Pending Approval",
                          style: TextStyle(
                            color: const Color(0xFFEA580C),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons
              Column(
                children: [
                  // Back to Home Button
                  GestureDetector(
                    onTap: () {
                      NavigationService.navigateToUntilReplacement(
                        Routes.createListingScreen,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D3B71),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          "Back to Home",
                          style: TextFontStyle.textStyle16InterW600.copyWith(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // View My Listings Button
                  GestureDetector(
                    onTap: () {
                      ToastUtil.showShortToast("My Listings coming soon!");
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          "View My Listings",
                          style: TextFontStyle.textStyle16InterW600.copyWith(
                            color: const Color(0xFF4B5563),
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
                    fontSize: 14.sp,
                    color: AppColor.c2E3227,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                    fontSize: 12.sp,
                    color: const Color(0xFF797A7C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
