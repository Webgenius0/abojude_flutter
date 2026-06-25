import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_contact_item.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_hours_card.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_logo_widget.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_image_carousel.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_seller_card.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_photos_gallery.dart';

class BusinessDetailsScreen extends StatelessWidget {
  final BusinessListingModel model;

  const BusinessDetailsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // Combine cover image and gallery images for the top carousel
    final List<dynamic> carouselImages = [];
    if (model.coverImage != null) {
      carouselImages.add(model.coverImage!);
    }
    carouselImages.addAll(model.galleryImages);

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
          style: TextFontStyle.textStyle16IbmPlexSansW600,
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
                    // --- Image PageView & Dot Indicator + Logo Overlay ---
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        BusinessImageCarousel(images: carouselImages),

                        // Logo overlay at bottom left of cover image (Rounded Square as per mockup)
                        if (model.logo != null)
                          Positioned(
                            bottom: -32.w,
                            left: 20.w,
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3.w,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1F000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: BusinessLogoWidget(
                                  logoData: model.logo!,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // --- Text Details Content ---
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Aligned "Business Directory" category badge on the right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 80.w), // spacing for logo overlay
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
                                  "Business Directory",
                                  style: TextFontStyle
                                      .textStyle12IbmPlexSansW600Navy,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Title
                          Text(
                            model.businessName.isNotEmpty
                                ? model.businessName
                                : "Halal Butcher Shop - Vancouver",
                            style: TextFontStyle.textStyle20IbmPlexSansW600,
                          ),
                          if (model.businessCategory.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            // Food & Grocery subcategory pill
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7ED),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                model.businessCategory,
                                style: TextFontStyle
                                    .textStyle12IbmPlexSansW600Navy
                                    .copyWith(color: const Color(0xFFEA580C)),
                              ),
                            ),
                          ],
                          SizedBox(height: 12.h),

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
                                "${model.city.isNotEmpty ? model.city : "Toronto"}, ${model.province.isNotEmpty ? model.province : "Manitoba"}",
                                style: TextFontStyle
                                    .textStyle13IbmPlexSansW400Grey,
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
                                style: TextFontStyle
                                    .textStyle13IbmPlexSansW400Grey,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- About Section ---
                          Text(
                            "About",
                            style: TextFontStyle.textStyle15IbmPlexSansW600,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            model.description.isNotEmpty
                                ? model.description
                                : "Premium halal butcher shop serving the Toronto community since 2015. Fresh daily cuts of beef, lamb, and poultry. Certified halal. Custom cuts available. Home delivery available for orders over \$50.",
                            style: TextFontStyle
                                .textStyle14IbmPlexSansW400LightGrey,
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Business Hours Collapsible Accordion Section (Extracted Widget) ---
                          BusinessHoursCard(businessHours: model.businessHours),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Seller Section ---
                          const BusinessSellerCard(
                            name: "Sarah Ahmed",
                            location: "Toronto, Ontario",
                            memberSince: "Member since 2023",
                            initials: "SA",
                          ),
                          SizedBox(height: 16.h),
                          const Divider(color: Color(0xFFE5E7EB)),
                          SizedBox(height: 12.h),

                          // --- Contact Information Section (Extracted Widgets) ---
                          Text(
                            "Contact Information",
                            style: TextFontStyle.textStyle15IbmPlexSansW600,
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
                                BusinessContactItem(
                                  icon: Icons.phone_outlined,
                                  iconBg: const Color(0xFFEFFDF4),
                                  iconColor: const Color(0xFF1B8E5A),
                                  label: "Phone",
                                  value: model.phoneNumber.isNotEmpty
                                      ? model.phoneNumber
                                      : "+1-416-555-1234",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                BusinessContactItem(
                                  icon: Icons.chat_bubble_outline,
                                  iconBg: const Color(0xFFEFFDF4),
                                  iconColor: const Color(0xFF1B8E5A),
                                  label: "What's app number",
                                  value: model.whatsAppNumber.isNotEmpty
                                      ? model.whatsAppNumber
                                      : "+1-416-555-1234",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                BusinessContactItem(
                                  icon: Icons.mail_outline,
                                  iconBg: const Color(0xFFEFF6FF),
                                  iconColor: const Color(0xFF3B82F6),
                                  label: "Email",
                                  value: model.emailAddress.isNotEmpty
                                      ? model.emailAddress
                                      : "alnour@example.com",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                BusinessContactItem(
                                  icon: Icons.language,
                                  iconBg: const Color(0xFFF3E8FF),
                                  iconColor: const Color(0xFF7C3AED),
                                  label: "Website",
                                  value: model.website.isNotEmpty
                                      ? model.website
                                      : "https://alnour.ca",
                                ),
                                const Divider(
                                  color: Color(0xFFE5E7EB),
                                  height: 1,
                                ),
                                BusinessContactItem(
                                  icon: Icons.location_on_outlined,
                                  iconBg: const Color(0xFFFFF7ED),
                                  iconColor: const Color(0xFFF97316),
                                  label: "Address",
                                  value: model.address.isNotEmpty
                                      ? model.address
                                      : "Scarborough, Ontario",
                                ),
                              ],
                            ),
                          ),

                          // --- Photos Gallery (Extracted Grid Widget) ---
                          BusinessPhotosGallery(
                            galleryImages: model.galleryImages,
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
                    color: Color(0x0A000000),
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        NavigationService.navigateTo(
                          Routes.businessSuccess,
                          arguments: model,
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
                              style: TextFontStyle.textStyle15InterW600White,
                            ),
                          ],
                        ),
                      ),
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
}
