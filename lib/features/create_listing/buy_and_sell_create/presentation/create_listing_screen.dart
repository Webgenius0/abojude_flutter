import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/assets_helper/app_icons.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/create_listing_option_card.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shimmer/shimmer.dart';
import 'package:abojude_flutter/features/home/model/get_category_list_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  static const Color navyBlue = Color(0xFF1D3B71);

  @override
  void initState() {
    super.initState();
    getCategoryListRxObj.getCategoryListRx();
  }

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
        child: StreamBuilder<CategoryListModel>(
          stream: getCategoryListRxObj.getCategoryListData,
          builder: (context, snapshot) {
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Create Listing".tr,
                    style: TextFontStyle.textStyle22IbmPlexSansW600,
                  ),
                  SizedBox(height: 8.h),
                  // Subtitle
                  Text(
                    "Choose the type of listing you would like to create.".tr,
                    style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 28.h),

                  if (isLoading)
                    _buildShimmerLoading()
                  else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data?.data == null ||
                      snapshot.data!.data!.isEmpty)
                    const Center(child: Text("Failed to load categories"))
                  else
                    ...snapshot.data!.data!.map((cat) {
                      final label = cat.name ?? '';
                      final subtitle = cat.shotDesc ?? '';
                      final lowerLabel = label.toLowerCase();

                      String defaultIconPath = AppIcons.buySell;
                      String subtitleText = subtitle;
                      VoidCallback onTap = () {};

                       final slug = cat.slug?.toLowerCase() ?? '';
                      if (slug.contains('buy') ||
                          slug.contains('sell') ||
                          lowerLabel.contains('buy') ||
                          lowerLabel.contains('sell') ||
                          lowerLabel.contains('شراء') ||
                          lowerLabel.contains('بيع')) {
                        defaultIconPath = AppIcons.buySell;
                        if (subtitleText.isEmpty) {
                          subtitleText = "List items for sale or trade";
                        }
                        onTap = () => NavigationService.navigateTo(
                          Routes.buySellStep1Photos,
                        );
                      } else if (slug.contains('job') ||
                          lowerLabel.contains('job') ||
                          lowerLabel.contains('وظائف')) {
                        defaultIconPath = AppIcons.job;
                        if (subtitleText.isEmpty) {
                          subtitleText = "Post a job opportunity";
                        }
                        onTap = () =>
                            NavigationService.navigateTo(Routes.jobStep1Photos);
                      } else if (slug.contains('business') ||
                          slug.contains('directory') ||
                          lowerLabel.contains('business') ||
                          lowerLabel.contains('directory') ||
                          lowerLabel.contains('أعمال') ||
                          lowerLabel.contains('دليل')) {
                        defaultIconPath = AppIcons.business;
                        if (subtitleText.isEmpty) {
                          subtitleText = "Add your business profile";
                        }
                        onTap = () => NavigationService.navigateTo(
                          Routes.businessStep1Photos,
                        );
                      } else if (slug.contains('service') ||
                          lowerLabel.contains('service') ||
                          lowerLabel.contains('خدمات')) {
                        defaultIconPath = AppIcons.service;
                        if (subtitleText.isEmpty) {
                          subtitleText = "Offer your professional services";
                        }
                        onTap = () => NavigationService.navigateTo(
                          Routes.serviceStep1Photos,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }

                      return CreateListingOptionCard(
                        icon: _buildCategoryIcon(
                          cat.icon ?? '',
                          defaultIconPath,
                        ),
                        title: label,
                        subtitle: subtitleText,
                        onTap: onTap,
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String iconUrl, String defaultIconPath) {
    if (iconUrl.isEmpty) {
      return SvgPicture.asset(
        defaultIconPath,
        width: 24.w,
        height: 24.w,
        colorFilter: const ColorFilter.mode(navyBlue, BlendMode.srcIn),
      );
    }

    // Resolve the full URL if it is a relative path
    String fullUrl = iconUrl.replaceAll('/./', '/').replaceAll('/../', '/');
    if (!fullUrl.startsWith('http') && !fullUrl.startsWith('assets/')) {
      const String baseDomain = "https://abojude.thesyndicates.team";
      // Prepend /storage/ if path does not contain 'storage'
      if (!fullUrl.toLowerCase().contains('storage')) {
        final cleanPath = fullUrl.startsWith('/') ? fullUrl : '/$fullUrl';
        fullUrl = '$baseDomain/storage$cleanPath';
      } else {
        final cleanPath = fullUrl.startsWith('/') ? fullUrl : '/$fullUrl';
        fullUrl = '$baseDomain$cleanPath';
      }
    }

    return _SvgBase64Image(
      url: fullUrl,
      width: 36.w,
      height: 36.w,
      color: navyBlue,
      fallbackIconPath: defaultIconPath,
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          4,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 16.h),
            height: 88.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}

class _SvgBase64Image extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final Color? color;
  final String fallbackIconPath;

  const _SvgBase64Image({
    required this.url,
    this.width,
    this.height,
    this.color,
    required this.fallbackIconPath,
  });

  @override
  State<_SvgBase64Image> createState() => _SvgBase64ImageState();
}

class _SvgBase64ImageState extends State<_SvgBase64Image> {
  late Future<Widget> _imageFuture;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadSvgOrImage(widget.url);
  }

  @override
  void didUpdateWidget(_SvgBase64Image oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        _imageFuture = _loadSvgOrImage(widget.url);
      });
    }
  }

  Future<Widget> _loadSvgOrImage(String url) async {
    try {
      String content = '';
      if (url.startsWith('assets/')) {
        content = await DefaultAssetBundle.of(context).loadString(url);
      } else {
        final response = await Dio().get<String>(url);
        if (response.statusCode == 200 && response.data != null) {
          content = response.data!;
        } else {
          return _buildFallback();
        }
      }

      // Check if there is an embedded base64 image in the SVG
      final match = RegExp(
        r'(?:xlink:)?href="data:image/[^;]+;base64,([^"]+)"',
      ).firstMatch(content);
      if (match != null) {
        final base64String =
            match.group(1)?.replaceAll(RegExp(r'\s+'), '') ?? '';
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildFallback(),
        );
      }

      // Otherwise, it is a normal SVG, render it via SvgPicture.string
      return SvgPicture.string(
        content,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.contain,
        colorFilter: widget.color != null
            ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
            : null,
      );
    } catch (e) {
      return _buildFallback();
    }
  }

  Widget _buildFallback() {
    return SvgPicture.asset(
      widget.fallbackIconPath,
      width: widget.width,
      height: widget.height,
      colorFilter: widget.color != null
          ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(width: widget.width, height: widget.height);
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildFallback();
        }
        return snapshot.data!;
      },
    );
  }
}
