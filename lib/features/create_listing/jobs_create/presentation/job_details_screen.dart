import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_listing_model.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobListingModel model;

  const JobDetailsScreen({super.key, required this.model});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageFile = widget.model.image;
    final images = imageFile != null ? [imageFile] : [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: const Color(0xFF1F2937),
                  size: 20.w,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Listing Details",
          style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
            fontSize: 16.sp,
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: const Color(0xFF1F2937),
                  size: 18.w,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Image PageView & Dot Indicator ---
                    if (images.isNotEmpty)
                      Stack(
                        children: [
                          SizedBox(
                            height: 250.h,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (int index) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Image.file(
                                  images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                          ),
                          // Dots indicator overlay
                          Positioned(
                            bottom: 12.h,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (index) {
                                final isActive = index == _currentImageIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  width: isActive ? 12.w : 8.w,
                                  height: 8.w,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF1B8E5A)
                                        : const Color(
                                            0x99FFFFFF,
                                          ), // 60% opacity white
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        height: 220.h,
                        color: const Color(0xFFF3F4F6),
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 48.w,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),

                    // --- Text Details Content ---
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badges Row
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF4FC),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  "Jobs",
                                  style: TextFontStyle
                                      .textStyle14IbmPlexSansW400
                                      .copyWith(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF1D3B71),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  widget.model.jobType,
                                  style: TextFontStyle
                                      .textStyle14IbmPlexSansW400
                                      .copyWith(
                                        fontSize: 12.sp,
                                        color: const Color(0xFF059669),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // Title
                          Text(
                            widget.model.title,
                            style: TextFontStyle.textStyle22IbmPlexSansW600
                                .copyWith(
                                  fontSize: 20.sp,
                                  color: AppColor.c2E3227,
                                ),
                          ),
                          SizedBox(height: 8.h),

                          // Location & Time Row
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16.w,
                                color: const Color(0xFF797A7C),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "${widget.model.city}, ${widget.model.province}",
                                style: TextFontStyle.textStyle14IbmPlexSansW400
                                    .copyWith(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF797A7C),
                                    ),
                              ),
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.access_time_outlined,
                                size: 16.w,
                                color: const Color(0xFF797A7C),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "5 hours ago",
                                style: TextFontStyle.textStyle14IbmPlexSansW400
                                    .copyWith(
                                      fontSize: 13.sp,
                                      color: const Color(0xFF797A7C),
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Company Name Section ---
                          Text(
                            "Company Name",
                            style: TextFontStyle.textStyle16IbmPlexSansW600
                                .copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.model.companyName.isNotEmpty
                                ? widget.model.companyName
                                : "Bagdad Restaurant, Toronto",
                            style: TextFontStyle.textStyle14IbmPlexSansW400
                                .copyWith(
                                  color: const Color(0xFF6B7280),
                                  fontSize: 14.sp,
                                ),
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Description Section ---
                          Text(
                            "Description",
                            style: TextFontStyle.textStyle16IbmPlexSansW600
                                .copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.model.description.isNotEmpty
                                ? widget.model.description
                                : "We are looking for an experienced cook for our Middle Eastern restaurant in downtown Toronto. Minimum 2 years experience in Arabic cuisine required. Competitive salary and benefits.",
                            style: TextFontStyle.textStyle14IbmPlexSansW400
                                .copyWith(
                                  color: const Color(0xFF6B7280),
                                  height: 1.5,
                                ),
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Seller Section ---
                          Text(
                            "Seller",
                            style: TextFontStyle.textStyle16IbmPlexSansW600
                                .copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22.r,
                                  backgroundColor: const Color(0xFF1D3B71),
                                  child: Text(
                                    "SA",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sarah Ahmed",
                                      style: TextFontStyle
                                          .textStyle16IbmPlexSansW600
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "Toronto, Ontario",
                                      style: TextStyle(
                                        color: const Color(0xFF797A7C),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "Member since 2023",
                                      style: TextStyle(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Contact Information Section ---
                          Text(
                            "Contact Information",
                            style: TextFontStyle.textStyle16IbmPlexSansW600
                                .copyWith(fontSize: 15.sp),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildContactItem(
                                  icon: Icons.phone_outlined,
                                  iconBg: const Color(0xFFEFFDF4),
                                  iconColor: const Color(0xFF1B8E5A),
                                  label: "Phone",
                                  value: widget.model.phoneNumber.isNotEmpty
                                      ? widget.model.phoneNumber
                                      : "+1-416-555-1234",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                _buildContactItem(
                                  icon: Icons.chat_bubble_outline,
                                  iconBg: const Color(0xFFEFFDF4),
                                  iconColor: const Color(0xFF1B8E5A),
                                  label: "What's app number",
                                  value: widget.model.whatsAppNumber.isNotEmpty
                                      ? widget.model.whatsAppNumber
                                      : "+1-416-555-1234",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                _buildContactItem(
                                  icon: Icons.mail_outline,
                                  iconBg: const Color(0xFFEFF6FF),
                                  iconColor: const Color(0xFF3B82F6),
                                  label: "Email",
                                  value: widget.model.emailAddress.isNotEmpty
                                      ? widget.model.emailAddress
                                      : "alnour@example.com",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                _buildContactItem(
                                  icon: Icons.location_on_outlined,
                                  iconBg: const Color(0xFFFFF7ED),
                                  iconColor: const Color(0xFFF97316),
                                  label: "Address",
                                  value: widget.model.address.isNotEmpty
                                      ? widget.model.address
                                      : "1450 Taylor Ave, Winnipeg, MB R3N 1Y6, Canada, Toronto, Manitoba, Scarborough, Ontario",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom Floating Bar ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000), // 4% opacity black
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Send Message Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(
                          Routes.jobSuccess,
                          arguments: widget.model,
                        );
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D3B71),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.white,
                              size: 20.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Send Message",
                              style: TextFontStyle.textStyle16InterW600
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // WhatsApp Circular Button
                  Container(
                    width: 52.h,
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFDF4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFA7F3D0),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: const Color(0xFF1B8E5A),
                      size: 26.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                    color: AppColor.c2E3227,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
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
