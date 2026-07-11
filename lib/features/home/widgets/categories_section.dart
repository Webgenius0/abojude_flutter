import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/business_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/buy_&_sell_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/job_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/services_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:abojude_flutter/features/home/model/get_category_list_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  static const Color navyBlue = Color(0xFF1B2D6B);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CategoryListModel>(
      stream: getCategoryListRxObj.getCategoryListData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return _buildShimmerLoading();
        }
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        if (!snapshot.hasData ||
            snapshot.data?.data == null ||
            snapshot.data!.data!.isEmpty) {
          return _buildShimmerLoading();
        }

        final categories = snapshot.data!.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Categories'),
            ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final label = cat.name ?? '';
                final subtitle = cat.shotDesc ?? '';
                final iconUrl = cat.icon ?? '';

                return GestureDetector(
                  onTap: () {
                    final lowerLabel = label.toLowerCase();
                    if (lowerLabel.contains('buy') ||
                        lowerLabel.contains('sell')) {
                      Get.to(() => const BuySellScreen());
                    } else if (lowerLabel.contains('job')) {
                      Get.to(() => const JobScreen());
                    } else if (lowerLabel.contains('business') ||
                        lowerLabel.contains('directory')) {
                      Get.to(() => const BusinessScreen());
                    } else if (lowerLabel.contains('service')) {
                      Get.to(() => const ServicesScreen());
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Icon Container
                        Container(
                          width: 42,
                          height: 42,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: navyBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _buildCategoryIcon(iconUrl),
                        ),

                        const SizedBox(width: 14),

                        // Text Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Arrow
                        const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Categories'),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 100, height: 14, color: Colors.grey),
                          const SizedBox(height: 6),
                          Container(width: 180, height: 12, color: Colors.grey),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String iconUrl) {
    if (iconUrl.isEmpty) {
      return const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.grey,
        size: 22,
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
      width: 24.w,
      height: 24.h,
      color: navyBlue,
    );
  }
}

class _SvgBase64Image extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final Color? color;

  const _SvgBase64Image({
    required this.url,
    this.width,
    this.height,
    this.color,
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
    return Icon(
      Icons.shopping_bag_outlined,
      color: Colors.grey,
      size: widget.height ?? 22,
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
