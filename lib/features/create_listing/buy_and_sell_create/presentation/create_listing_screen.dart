import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/assets_helper/app_images.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                style: TextFontStyle.textStyle14IbmPlexSansW400,
              ),
              SizedBox(height: 28.h),
              // Option Cards
              CreateListingOptionCard(
                iconPath: AppImages.buy_sell,
                title: "Buy & Sell",
                subtitle: "List items for sale or trade",
                onTap: () {
                  NavigationService.navigateTo(Routes.buySellStep1Photos);
                },
              ),
              CreateListingOptionCard(
                iconPath: AppImages.job,
                title: "Jobs",
                subtitle: "Post a job opportunity",
                onTap: () {
                  debugPrint("Tapped Jobs");
                },
              ),
              CreateListingOptionCard(
                iconPath: AppImages.business,
                title: "Business Directory",
                subtitle: "Add your business profile",
                onTap: () {
                  debugPrint("Tapped Business Directory");
                },
              ),
              CreateListingOptionCard(
                iconPath: AppImages.service,
                title: "Services",
                subtitle: "Offer your professional services",
                onTap: () {
                  debugPrint("Tapped Services");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
