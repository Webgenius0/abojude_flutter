import 'package:abojude_flutter/features/profile/model/my_listing_model.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initial fetch from API
    getMyListRxObj.getMyList(isRefresh: true);

    // Add scroll listener for Lazy Loading (pagination)
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      getMyListRxObj.fetchMoreData();
    }
  }

  List<Post> _filterPostsByStatus(List<Post> posts, String status) {
    if (status == 'All') return posts;
    return posts.where((p) => (p.status ?? '').toLowerCase() == status.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                    border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
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
              'My Listings',
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Manual Refresh Button
                      Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F3F5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.refresh_rounded, color: const Color(0xFF0F3D7A), size: 22.sp),
                          onPressed: () {
                            getMyListRxObj.getMyList(isRefresh: true);
                          },
                          padding: EdgeInsets.zero,
                          tooltip: 'Refresh Listings',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Create Listing Button
                      Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F3D7A),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add, color: Colors.white, size: 22.sp),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.createListingScreen);
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: getMyListRxObj.isLoading,
          builder: (context, isLoading, _) {
            return StreamBuilder<GetMyListingModel>(
              stream: getMyListRxObj.getMyListData,
              builder: (context, snapshot) {
                final model = snapshot.data;
                final data = model?.data;
                final List<Post> posts = data?.posts ?? [];

                if (isLoading && posts.isEmpty) {
                  return Column(
                    children: [
                      _buildStatsSummaryPanel(data, 0),
                      _buildCustomTabBar(
                        allCount: 0,
                        pendingCount: 0,
                        activeCount: 0,
                        expiredCount: 0,
                      ),
                      Expanded(child: _buildShimmerList()),
                    ],
                  );
                }

                final int pendingCount = posts.where((l) => (l.status ?? '').toLowerCase() == 'pending').length;
                final int activeCount = posts.where((l) => (l.status ?? '').toLowerCase() == 'active').length;
                final int expiredCount = posts.where((l) => (l.status ?? '').toLowerCase() == 'expired').length;

                return Column(
                  children: [
                    // 1. Stats Summary Panel
                    _buildStatsSummaryPanel(data, posts.length),

                    // 2. Custom Selectable Tabs
                    _buildCustomTabBar(
                      allCount: data?.totalPost ?? posts.length,
                      pendingCount: pendingCount,
                      activeCount: activeCount,
                      expiredCount: expiredCount,
                    ),

                    // 3. Tab Views list with Pull-To-Refresh & Lazy Loading
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildListingsList(posts, 'All'),
                          _buildListingsList(posts, 'Pending'),
                          _buildListingsList(posts, 'Active'),
                          _buildListingsList(posts, 'Expired'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Shimmer loading list placeholder
  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            height: 130.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
    );
  }

  // Statistics summaries (Listings, Views, Favorites, Messages)
  Widget _buildStatsSummaryPanel(Data? data, int postCount) {
    final String listingsVal = (data?.totalPost ?? postCount).toString().padLeft(2, '0');
    final String viewsVal = (data?.totalView ?? 0).toString().padLeft(2, '0');
    final String wishesVal = (data?.totalWish ?? 0).toString().padLeft(2, '0');
    final String messagesVal = (data?.totalMessage ?? 0).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F9FA),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(listingsVal, 'Listings', const Color(0xFF0F3D7A)),
          _buildStatItem(viewsVal, 'View', const Color(0xFF2B8A3E)),
          _buildStatItem(wishesVal, 'Favorites', const Color(0xFFE03131)),
          _buildStatItem(messagesVal, 'Message', const Color(0xFFF0A020)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // Custom Tabs matching design
  Widget _buildCustomTabBar({
    required int allCount,
    required int pendingCount,
    required int activeCount,
    required int expiredCount,
  }) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: const Color(0xFF0F3D7A),
        unselectedLabelColor: Colors.grey[500],
        indicatorColor: const Color(0xFF0F3D7A),
        indicatorWeight: 2,
        labelStyle: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500),
        tabs: [
          _buildTabWithBadge('All', allCount),
          _buildTabWithBadge('Pending', pendingCount),
          _buildTabWithBadge('Active', activeCount),
          _buildTabWithBadge('Expired', expiredCount),
        ],
      ),
    );
  }

  Tab _buildTabWithBadge(String label, int count) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: const BoxDecoration(
              color: Color(0xFFE9ECEF),
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.h),
            child: Center(
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF495057),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Listing item list builder with lazy loading & Pull-To-Refresh support
  Widget _buildListingsList(List<Post> posts, String filterStatus) {
    final filteredPosts = _filterPostsByStatus(posts, filterStatus);

    return RefreshIndicator(
      onRefresh: () async {
        await getMyListRxObj.getMyList(isRefresh: true);
      },
      color: const Color(0xFF0F3D7A),
      backgroundColor: Colors.white,
      child: filteredPosts.isEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: SizedBox(
                height: 350.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 48.sp,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No listings found in $filterStatus',
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Pull down to refresh',
                        style: GoogleFonts.inter(
                          color: Colors.grey[400],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : ValueListenableBuilder<bool>(
              valueListenable: getMyListRxObj.isLoadingMore,
              builder: (context, isLoadingMore, _) {
                final int itemCount = filteredPosts.length + (isLoadingMore ? 1 : 0);

                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                      getMyListRxObj.fetchMoreData();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == filteredPosts.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(color: Color(0xFF0F3D7A)),
                          ),
                        );
                      }

                      final post = filteredPosts[index];
                      return _buildListingCard(post);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmationDialog(Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          backgroundColor: Colors.white,
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon Badge
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEE2E2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 46.r,
                      height: 46.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCA5A5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: const Color(0xFFDC2626),
                        size: 26.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Title
                Text(
                  'Delete Listing?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 8.h),

                // Description
                Text(
                  'Are you sure you want to delete this listing? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.h),

                // Listing preview box with CachedNetworkImage
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: (post.thumbnail != null && post.thumbnail!.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl: post.thumbnail!,
                                width: 40.w,
                                height: 40.h,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.white),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 40.w,
                                  height: 40.h,
                                  color: const Color(0xFFE5E7EB),
                                  child: Icon(Icons.phone_android, size: 20.sp, color: Colors.grey),
                                ),
                              )
                            : Container(
                                width: 40.w,
                                height: 40.h,
                                color: const Color(0xFFE5E7EB),
                                child: Icon(Icons.phone_android, size: 20.sp, color: Colors.grey),
                              ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          post.displayTitle.isNotEmpty ? post.displayTitle : (post.title ?? 'Listing Item'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Actions row
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF374151),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteListing(post);
                          },
                          child: Text(
                            'Delete',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteListing(Post post) {
    if (post.id != null) {
      getMyListRxObj.deletePostLocally(post.id!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Listing deleted successfully',
          style: GoogleFonts.inter(fontSize: 14.sp),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildListingCard(Post post) {
    final String status = post.status ?? 'Active';
    final bool isPending = status.toLowerCase() == 'pending';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPending ? const Color(0xFFFFECC8) : const Color(0xFFF1F3F5),
          width: isPending ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yellow Awaiting Admin review banner (Only for pending listings)
          if (isPending)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9ED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, color: const Color(0xFFB7791F), size: 14.sp),
                  SizedBox(width: 6.w),
                  Text(
                    'Awaiting admin review - not yet visible to others',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB7791F),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Main product information
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail image with CachedNetworkImage & Shimmer
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    width: 76.w,
                    height: 76.h,
                    color: const Color(0xFFF8F9FA),
                    child: (post.thumbnail != null && post.thumbnail!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: post.thumbnail!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.phone_android,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(
                            Icons.phone_android,
                            color: Colors.grey,
                          ),
                  ),
                ),
                SizedBox(width: 14.w),

                // Text fields details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.displayTitle.isNotEmpty ? post.displayTitle : (post.title ?? ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _buildStatusTag(status),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              post.timeAgo ?? post.submitDate ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                color: Colors.grey[400],
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // More vertical menu action button
                Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F5),
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert, color: Colors.black87, size: 16.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmationDialog(post);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                color: Colors.red,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
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

          const Divider(height: 1, color: Color(0xFFF1F3F5)),

          // Bottom card statistics (Views, Favorites, Messages)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                _buildMetricItem(Icons.remove_red_eye_outlined, post.totalView ?? 0),
                SizedBox(width: 24.w),
                _buildMetricItem(Icons.favorite_border_rounded, post.totalWish ?? 0),
                SizedBox(width: 24.w),
                _buildMetricItem(Icons.chat_bubble_outline_rounded, post.totalMessage ?? 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color bg = const Color(0xFFE9ECEF);
    Color fg = const Color(0xFF495057);

    final String lowerStatus = status.toLowerCase();

    if (lowerStatus == 'pending') {
      bg = const Color(0xFFFFF3CD);
      fg = const Color(0xFF856404);
    } else if (lowerStatus == 'active') {
      bg = const Color(0xFFD4EDDA);
      fg = const Color(0xFF155724);
    } else if (lowerStatus == 'featured') {
      bg = const Color(0xFFF0A020);
      fg = Colors.white;
    } else if (lowerStatus == 'expired') {
      bg = const Color(0xFFF8D7DA);
      fg = const Color(0xFF721C24);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (lowerStatus == 'featured') ...[
            Icon(Icons.star, color: Colors.white, size: 10.sp),
            SizedBox(width: 3.w),
          ],
          Text(
            status,
            style: GoogleFonts.inter(
              color: fg,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, int val) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: 16.sp),
        SizedBox(width: 6.w),
        Text(
          '$val',
          style: GoogleFonts.inter(
            color: Colors.grey[500],
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
