import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_step_header.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_button.dart';

class ServiceStep5ReviewScreen extends StatelessWidget {
  final ServiceListingModel model;

  const ServiceStep5ReviewScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final imageFile = model.images.isNotEmpty ? model.images[0] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ServiceStepHeader(currentStep: 5, title: "Review & Submit"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Review your listing details before submitting for approval.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Preview Listing Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFEFF4FC),
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x04000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail Image Area
                          if (imageFile != null)
                            Stack(
                              children: [
                                Container(
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16.r),
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Click to see public view overlay banner
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color(0x99000000), // 60% opacity black
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Click to See Public View",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Container(
                              height: 180.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.r),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: const Color(0xFF9CA3AF),
                                  size: 40.w,
                                ),
                              ),
                            ),

                          // Text Content details
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  model.title,
                                  style: TextFontStyle
                                      .textStyle22IbmPlexSansW600
                                      .copyWith(
                                        color: AppColor.c2E3227,
                                        fontSize: 18.sp,
                                      ),
                                ),
                                SizedBox(height: 12.h),

                                // Badges
                                Row(
                                  children: [
                                    // Category Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        "Service",
                                        style: TextFontStyle
                                            .textStyle14IbmPlexSansW400
                                            .copyWith(
                                              fontSize: 12.sp,
                                              color: const Color(0xFF4B5563),
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    // Location Badge
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 16.w,
                                          color: const Color(0xFF797A7C),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "${model.city}, ${model.province}",
                                          style: TextFontStyle
                                              .textStyle14IbmPlexSansW400
                                              .copyWith(
                                                fontSize: 12.sp,
                                                color: const Color(0xFF797A7C),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Before You Submit Box
                    Text(
                      "Before You Submit",
                      style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEFBF0),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFFDE68A),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildBulletPoint(
                            "Your listing will be reviewed by our team",
                          ),
                          _buildBulletPoint(
                            "Review usually takes up to 24 hours",
                          ),
                          _buildBulletPoint("You'll be notified once approved"),
                          _buildBulletPoint(
                            "Approved listings become visible to all users",
                          ),
                          _buildBulletPoint(
                            "You can edit or remove your listing later",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Submit Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: ServiceButton(
                text: "Submit Listing",
                isSubmit: true,
                onTap: () {
                  NavigationService.navigateTo(
                    Routes.serviceDetails,
                    arguments: model,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, right: 8.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(
                color: Color(0xFFD97706),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                fontSize: 13.sp,
                color: const Color(0xFF78350F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
