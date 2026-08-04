import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:abojude_flutter/features/explore_deatils_screen/business_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/job_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/services_screen.dart';
import 'package:abojude_flutter/features/home/presentation/product_details_screen.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class ListingCard extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onFavoriteToggle;

  const ListingCard({super.key, required this.item, this.onFavoriteToggle});

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  static const Color navyBlue = Color(0xFF1B2D6B);
  static const Color accentYellow = Color(0xFFFFC107);

  String? _formatImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    String url = rawUrl.trim();
    if (url.startsWith('http://') || url.startsWith('https://')) return url;

    const String baseDomain = "https://abojude.thesyndicates.team";
    url = url.replaceAll('/./', '/').replaceAll('/../', '/');
    if (!url.toLowerCase().contains('storage')) {
      final cleanPath = url.startsWith('/') ? url : '/$url';
      return '$baseDomain/storage$cleanPath';
    } else {
      final cleanPath = url.startsWith('/') ? url : '/$url';
      return '$baseDomain$cleanPath';
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final String title = item is Map
        ? (item['title'] as String? ?? '')
        : (item.title ?? '');
    final String category = item is Map
        ? (item['category'] as String? ?? '')
        : (item.categoryName ?? '');
    final String? rawImageUrl = item is Map
        ? (item['imageUrl'] as String?)
        : (item.thumbnail);
    final String? imageUrl = _formatImageUrl(rawImageUrl);

    final bool isFeatured = item is Map
        ? (item['isFeatured'] as bool? ?? false)
        : (item.isFeatured ?? false);
    final String time = item is Map
        ? (item['time'] as String? ?? '')
        : (item.timeAgo ?? '');
    final bool isFavorite = item is Map
        ? (item['isFavorite'] as bool? ?? false)
        : (item.isWish ?? false);
    final bool hasPrice = item is Map
        ? (item['hasPrice'] as bool? ?? false)
        : (item.price != null && item.price.toString().isNotEmpty);
    final String priceStr = item is Map
        ? (item['price'] as String? ?? '')
        : (item.price != null
              ? (item.price.toString().startsWith('£')
                    ? item.price.toString()
                    : '£${item.price}')
              : '');
    final String location = item is Map
        ? (item['location'] as String? ?? '')
        : ("${item.city ?? ''}${item.city != null && item.province != null ? ', ' : ''}${item.province ?? ''}");
    final IconData icon = item is Map
        ? (item['icon'] as IconData? ?? Icons.image)
        : Icons.image;

    final int? postId = item is Map
        ? (item['id'] is int ? item['id'] as int : int.tryParse(item['id']?.toString() ?? ''))
        : (item.id is int ? item.id as int : int.tryParse(item.id?.toString() ?? ''));

    return GestureDetector(
      onTap: () {
        if (category == 'Buy & Sell') {
          Get.to(() => ProductDetailsScreen(postId: postId));
        } else if (category == 'Business') {
          Get.to(() => BusinessScreen(postId: postId));
        } else if (category == 'Jobs') {
          Get.to(() => JobScreen(postId: postId));
        } else if (category == 'Services') {
          Get.to(() => const ServicesScreen());
        } else {
          Get.to(() => BusinessScreen(postId: postId));
        }
      },
      child: Container(
        width: 165.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isBounded = constraints.hasBoundedHeight;

            Widget imageSection = Stack(
              fit: isBounded ? StackFit.expand : StackFit.loose,
              children: [
                Container(
                  height: isBounded ? null : 110.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                    ),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                icon,
                                size: 48.r,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              icon,
                              size: 48.r,
                              color: Colors.grey.shade400,
                            ),
                          ),
                  ),
                ),
                if (isFeatured)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: accentYellow,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 10.sp),
                          SizedBox(width: 3.w),
                          Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (time.isNotEmpty)
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (item is Map) {
                          item['isFavorite'] =
                              !(item['isFavorite'] as bool? ?? false);
                        } else {
                          try {
                            (item as dynamic).isWish =
                                !((item as dynamic).isWish ?? false);
                          } catch (_) {}
                        }
                      });

                      if (postId != null) {
                        saveWishesRxObj.save(postId: postId);
                      }

                      widget.onFavoriteToggle?.call();
                    },
                    child: Container(
                      width: 28.r,
                      height: 28.r,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16.r,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBounded) Expanded(child: imageSection) else imageSection,
                // Info
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasPrice)
                        Text(
                          priceStr,
                          style: TextStyle(
                            color: navyBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 14.sp,
                          ),
                        ),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      if (category.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12.r,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
