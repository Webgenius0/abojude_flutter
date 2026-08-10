import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/profile/model/get_wishes_list_model.dart';

import 'package:abojude_flutter/features/explore_deatils_screen/business_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/job_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/services_screen.dart';
import 'package:abojude_flutter/features/home/presentation/product_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // Fetch wishes list from GetWishesListRx
    getWishesListRxObj.getWishesList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  List<Datum> _filterItems(List<Datum> items, String categoryFilter) {
    if (categoryFilter == 'All') return items;
    return items.where((item) {
      final cat = item.categoryName ?? '';
      return cat.toLowerCase() == categoryFilter.toLowerCase();
    }).toList();
  }

  void _navigateToDetail(Datum item) {
    final String category = item.categoryName ?? '';
    final int? postId = item.id;

    if (category.toLowerCase() == 'buy & sell' ||
        category.toLowerCase() == 'buy and sell') {
      Get.to(() => ProductDetailsScreen(postId: postId));
    } else if (category.toLowerCase() == 'business') {
      Get.to(() => BusinessScreen(postId: postId));
    } else if (category.toLowerCase() == 'jobs' ||
        category.toLowerCase() == 'job') {
      Get.to(() => NavigationService.navigateTo(Routes.jobStep1Photos));
    } else if (category.toLowerCase() == 'services' ||
        category.toLowerCase() == 'service') {
      Get.to(() => const ServicesScreen());
    } else {
      Get.to(() => ProductDetailsScreen(postId: postId));
    }
  }

  void _removeItem(Datum item) async {
    if (item.id != null) {
      final success = await saveWishesRxObj.save(postId: item.id!);
      if (success) {
        getWishesListRxObj.getWishesList();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: getWishesListRxObj.isLoading,
      builder: (context, isLoading, _) {
        return StreamBuilder<GetWishListModel>(
          stream: getWishesListRxObj.getProfileData,
          builder: (context, snapshot) {
            final wishListModel = snapshot.data;
            final allItems = wishListModel?.data ?? [];
            final bool showShimmer = isLoading && allItems.isEmpty;

            return Scaffold(
              backgroundColor: const Color(0xFFFAFAFA),
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(70.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leadingWidth: 70.w,
                    leading: Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFF1F3F5), width: 1.5),
                          ),
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.black87,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Favorites',
                      style: GoogleFonts.inter(
                        color: Colors.black87,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Text(
                              '${allItems.length}',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFE03131),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await getWishesListRxObj.getWishesList();
                  },
                  child: Column(
                    children: [
                      // Tabs Row
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: const Color(0xFF0F3D7A),
                          unselectedLabelColor: Colors.grey[500],
                          indicatorColor: const Color(0xFF0F3D7A),
                          indicatorWeight: 2,
                          labelStyle: GoogleFonts.inter(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: GoogleFonts.inter(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                          tabs: const [
                            Tab(text: 'All'),
                            Tab(text: 'Buy & Sell'),
                            Tab(text: 'Jobs'),
                            Tab(text: 'Business'),
                            Tab(text: 'Services'),
                          ],
                        ),
                      ),

                      // Tab Views grid
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildFavoritesGrid(allItems, 'All', showShimmer),
                            _buildFavoritesGrid(allItems, 'Buy & Sell', showShimmer),
                            _buildFavoritesGrid(allItems, 'Jobs', showShimmer),
                            _buildFavoritesGrid(allItems, 'Business', showShimmer),
                            _buildFavoritesGrid(allItems, 'Services', showShimmer),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Grid builder
  Widget _buildFavoritesGrid(
      List<Datum> allItems, String categoryFilter, bool showShimmer) {
    if (showShimmer) {
      return _buildShimmerGrid();
    }

    final items = _filterItems(allItems, categoryFilter);

    if (items.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: 400.h,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 64.r,
                color: Colors.grey[300],
              ),
              SizedBox(height: 12.h),
              Text(
                categoryFilter == 'All'
                    ? 'No favorites added yet'
                    : 'No favorites in $categoryFilter',
                style: GoogleFonts.inter(
                  color: Colors.grey[500],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      padding: EdgeInsets.all(16.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.72,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildFavoriteCard(item);
      },
    );
  }

  // Shimmer placeholder grid
  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.r),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: double.infinity,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: 50.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 80.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteCard(Datum item) {
    final String title = item.title ?? 'No Title';
    final String category = item.categoryName ?? 'General';
    final String? rawImageUrl = item.thumbnail;
    final String? formattedImageUrl = _formatImageUrl(rawImageUrl);
    final bool isFeatured = item.isFeatured ?? false;
    final String timeAgo = item.timeAgo ?? '';
    final String? price = item.price;

    String location = '';
    if (item.city != null && item.city!.isNotEmpty) {
      location += item.city!;
    }
    if (item.province != null && item.province!.isNotEmpty) {
      if (location.isNotEmpty) location += ', ';
      location += item.province!;
    }
    if (location.isEmpty) location = 'Canada';

    return GestureDetector(
      onTap: () => _navigateToDetail(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with Overlays
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(11.r),
                    ),
                    child: formattedImageUrl != null &&
                            formattedImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: formattedImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFFF8F9FA),
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFF8F9FA),
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  // Featured Tag
                  if (isFeatured)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0A020),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 9.sp),
                            SizedBox(width: 3.w),
                            Text(
                              'Featured',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Time ago overlay
                  if (timeAgo.isNotEmpty)
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          timeAgo,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                  // Heart Button
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: () => _removeItem(item),
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE03131),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price if exists
                  if (price != null && price.isNotEmpty) ...[
                    Text(
                      price.startsWith('\$')
                          ? price
                          : '\$$price',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF0F3D7A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],

                  // Title
                  Text(
                    title,
                    maxLines: price == null || price.isEmpty ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Category tag
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F5),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF495057),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Location info row
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: Colors.grey[400], size: 12.sp),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: Colors.grey[500],
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
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
