import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_get_post_draft_model.dart';

class BuySellDetailsScreen extends StatefulWidget {
  final BuySellListingModel model;

  const BuySellDetailsScreen({super.key, required this.model});

  @override
  State<BuySellDetailsScreen> createState() => _BuySellDetailsScreenState();
}

class _BuySellDetailsScreenState extends State<BuySellDetailsScreen> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    buyAndSellGetPostDraftRxObj.getPostDraft();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.model.images;

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
        child: StreamBuilder<BuyAndSellGetPostDraftModel>(
          stream: buyAndSellGetPostDraftRxObj.getPostDraftData,
          builder: (context, snapshot) {
            final draftData = snapshot.data?.data;
            final displayTitle = draftData?.title ?? widget.model.title;
            final displayDescription =
                draftData?.description ?? widget.model.description;
            final displayProvince =
                draftData?.province ?? widget.model.province;
            final displayCity = draftData?.city ?? widget.model.city;
            final displayAddress = draftData?.address ?? widget.model.address;
            final displayPhone = draftData?.phone ?? widget.model.phoneNumber;
            final displayWhatsapp =
                draftData?.whatsapp ?? widget.model.whatsAppNumber;
            final displayEmail = draftData?.email ?? widget.model.emailAddress;
            final displayPrice = widget.model.price;
            final displayCondition = widget.model.condition;

            return Column(
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
                                  children: List.generate(images.length, (
                                    index,
                                  ) {
                                    final isActive =
                                        index == _currentImageIndex;
                                    return AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      width: isActive ? 12.w : 8.w,
                                      height: 8.w,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? const Color(0xFF1B8E5A)
                                            : const Color(
                                                0x99FFFFFF,
                                              ), // 60% opacity white
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
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

                        // --- Text Details Padding ---
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Price & Category Badge Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    displayPrice,
                                    style: TextFontStyle
                                        .textStyle22IbmPlexSansW600
                                        .copyWith(
                                          color: const Color(0xFF1D3B71),
                                          fontSize: 22.sp,
                                        ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F4F6),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      "Buy & Sell",
                                      style: TextFontStyle
                                          .textStyle14IbmPlexSansW400
                                          .copyWith(
                                            fontSize: 12.sp,
                                            color: const Color(0xFF4B5563),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),

                              // Title
                              Text(
                                displayTitle,
                                style: TextFontStyle.textStyle22IbmPlexSansW600
                                    .copyWith(
                                      fontSize: 18.sp,
                                      color: AppColor.c2E3227,
                                    ),
                              ),
                              SizedBox(height: 10.h),

                              // Location & Time ago
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16.w,
                                    color: const Color(0xFF797A7C),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "$displayCity, $displayProvince",
                                    style: TextFontStyle
                                        .textStyle14IbmPlexSansW400
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
                                    "Just now",
                                    style: TextFontStyle
                                        .textStyle14IbmPlexSansW400
                                        .copyWith(
                                          fontSize: 13.sp,
                                          color: const Color(0xFF797A7C),
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),

                              // Condition badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: const Color(0xFFA7F3D0),
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  "Condition: $displayCondition",
                                  style: TextStyle(
                                    color: const Color(0xFF10B981),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                displayDescription,
                                style: TextFontStyle.textStyle14IbmPlexSansW400
                                    .copyWith(
                                      color: const Color(0xFF4B5563),
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
                              StreamBuilder<BuyAndSellGetPostDraftModel>(
                                stream: buyAndSellGetPostDraftRxObj
                                    .getPostDraftData,
                                builder: (context, snapshot) {
                                  final draftData = snapshot.data?.data;
                                  final userName =
                                      draftData?.userName ?? "Ferdaus";
                                  final userSince =
                                      draftData?.userSince ?? "2026";
                                  final displayCity =
                                      draftData?.city ?? widget.model.city;
                                  final displayProvince =
                                      draftData?.province ??
                                      widget.model.province;
                                  final location =
                                      "$displayCity, $displayProvince";

                                  String initials = "FE";
                                  if (userName.trim().isNotEmpty) {
                                    final parts = userName.trim().split(" ");
                                    if (parts.length > 1) {
                                      initials = (parts[0][0] + parts[1][0])
                                          .toUpperCase();
                                    } else {
                                      initials = parts[0][0].toUpperCase();
                                    }
                                  }

                                  return Container(
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
                                          backgroundColor: const Color(
                                            0xFF1D3B71,
                                          ),
                                          child: Text(
                                            initials,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userName,
                                              style: TextFontStyle
                                                  .textStyle16IbmPlexSansW600
                                                  .copyWith(fontSize: 14.sp),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              location,
                                              style: TextStyle(
                                                color: const Color(0xFF797A7C),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              "Member since $userSince",
                                              style: TextStyle(
                                                color: const Color(0xFF9CA3AF),
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
                                      label: "Phone",
                                      value: displayPhone.isNotEmpty
                                          ? displayPhone
                                          : "+1-416-555-1234",
                                    ),
                                    const Divider(
                                      color: Color(0xFFE5E7EB),
                                      height: 1,
                                    ),
                                    _buildContactItem(
                                      icon: Icons.chat_bubble_outline,
                                      label: "What's app number",
                                      value: displayWhatsapp.isNotEmpty
                                          ? displayWhatsapp
                                          : "+1-416-555-1234",
                                    ),
                                    const Divider(
                                      color: Color(0xFFE5E7EB),
                                      height: 1,
                                    ),
                                    _buildContactItem(
                                      icon: Icons.mail_outline,
                                      label: "Email",
                                      value: displayEmail.isNotEmpty
                                          ? displayEmail
                                          : "alnour@example.com",
                                    ),
                                    const Divider(
                                      color: Color(0xFFE5E7EB),
                                      height: 1,
                                    ),
                                    _buildContactItem(
                                      icon: Icons.location_on_outlined,
                                      label: "Address",
                                      value: displayAddress.isNotEmpty
                                          ? displayAddress
                                          : "1450 Taylor Ave, Winnipeg, MB R3N 1Y6, Canada",
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
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
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF797A7C), size: 18.w),
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
