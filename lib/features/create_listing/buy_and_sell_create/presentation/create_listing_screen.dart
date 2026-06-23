import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/assets_helper/app_icons.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/create_listing_option_card.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cFFFFFF,
      appBar: AppBar(
        backgroundColor: AppColor.cFFFFFF,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20.w,
                  color: AppColor.c2E3227,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Create Listing",
                style: TextFontStyle.textStyle22IbmPlexSansW600,
              ),
              SizedBox(height: 8.h),
              // Subtitle
              Text(
                "Choose the type of listing you would like to create.",
                style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 28.h),
              // Option Cards
              CreateListingOptionCard(
                iconPath: AppIcons.bag,
                title: "Buy & Sell",
                subtitle: "List items for sale or trade",
                onTap: () {
                  NavigationService.navigateTo(Routes.buySellStep1Photos);
                },
              ),
              CreateListingOptionCard(
                iconPath: AppIcons.job,
                title: "Jobs",
                subtitle: "Post a job opportunity",
                onTap: () {
                  NavigationService.navigateTo(Routes.jobStep1Photos);
                },
              ),
              CreateListingOptionCard(
                iconPath: AppIcons.business,
                title: "Business Directory",
                subtitle: "Add your business profile",
                onTap: () {
                  NavigationService.navigateTo(Routes.businessStep1Photos);
                },
              ),
              CreateListingOptionCard(
                iconPath: AppIcons.service,
                title: "Services",
                subtitle: "Offer your professional services",
                onTap: () {
                  NavigationService.navigateTo(Routes.serviceStep1Photos);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
