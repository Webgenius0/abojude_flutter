import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Listing Model
class UserListing {
  final String id;
  final String title;
  final String imageUrl;
  final String status; // "Pending", "Active", "Featured", "Expired"
  final String dateInfo;
  final int views;
  final int favorites;
  final int messages;

  UserListing({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.status,
    required this.dateInfo,
    required this.views,
    required this.favorites,
    required this.messages,
  });
}

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<UserListing> _allListings = [
    UserListing(
      id: '1',
      title: "iPhone 14 Pro Max - 256GB Deep Purple",
      imageUrl: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&auto=format&fit=crop&q=80",
      status: "Pending",
      dateInfo: "Submitted Jun 18, 2026",
      views: 0,
      favorites: 0,
      messages: 0,
    ),
    UserListing(
      id: '2',
      title: "iPhone 14 Pro Max - 256GB Deep Purple",
      imageUrl: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&auto=format&fit=crop&q=80",
      status: "Active",
      dateInfo: "2 day ago",
      views: 120,
      favorites: 120,
      messages: 120,
    ),
    UserListing(
      id: '3',
      title: "iPhone 14 Pro Max - 256GB Deep Purple",
      imageUrl: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&auto=format&fit=crop&q=80",
      status: "Featured",
      dateInfo: "12 day ago",
      views: 120,
      favorites: 120,
      messages: 120,
    ),
    UserListing(
      id: '4',
      title: "iPhone 14 Pro Max - 256GB Deep Purple",
      imageUrl: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&auto=format&fit=crop&q=80",
      status: "Expired",
      dateInfo: "1 month ago",
      views: 120,
      favorites: 120,
      messages: 120,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<UserListing> _getListingsByStatus(String status) {
    if (status == 'All') return _allListings;
    return _allListings.where((l) => l.status.toLowerCase() == status.toLowerCase()).toList();
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
                color: Colors.grey.withOpacity(0.05),
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
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F3D7A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 22.sp),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Stats Summary Panel
            _buildStatsSummaryPanel(),

            // 2. Custom Selectable Tabs
            _buildCustomTabBar(),

            // 3. Tab Views list
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildListingsList('All'),
                  _buildListingsList('Pending'),
                  _buildListingsList('Active'),
                  _buildListingsList('Expired'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Statistics summaries (Listings, Views, Favorites, Messages)
  Widget _buildStatsSummaryPanel() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF8F9FA),
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('09', 'Listings', const Color(0xFF0F3D7A)),
          _buildStatItem('80', 'View', const Color(0xFF2B8A3E)),
          _buildStatItem('45', 'Favorites', const Color(0xFFE03131)),
          _buildStatItem('35', 'Message', const Color(0xFFF0A020)),
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

  // Custom Tabs matching the look and feel of Image 1
  Widget _buildCustomTabBar() {
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
          _buildTabWithBadge('All', 9),
          _buildTabWithBadge('Pending', 2),
          _buildTabWithBadge('Active', 6),
          _buildTab('Expired'),
        ],
      ),
    );
  }

  Tab _buildTab(String label) {
    return Tab(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(label),
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
            decoration: BoxDecoration(
              color: const Color(0xFFE9ECEF),
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

  // Listing item list builder
  Widget _buildListingsList(String filterStatus) {
    final listings = _getListingsByStatus(filterStatus);

    if (listings.isEmpty) {
      return Center(
        child: Text(
          'No listings found in $filterStatus',
          style: TextStyle(color: Colors.grey[400]),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];

        return _buildListingCard(listing);
      },
    );
  }

  Widget _buildListingCard(UserListing listing) {
    final bool isPending = listing.status == 'Pending';

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
            color: Colors.black.withOpacity(0.015),
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
                // Thumbnail image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    width: 76.w,
                    height: 76.h,
                    color: const Color(0xFFF8F9FA),
                    child: Image.network(
                      listing.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.phone_android, color: Colors.grey);
                      },
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
                        listing.title,
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
                          _buildStatusTag(listing.status),
                          SizedBox(width: 8.w),
                          Text(
                            listing.dateInfo,
                            style: GoogleFonts.inter(
                              color: Colors.grey[400],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
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
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.more_vert, color: Colors.black87, size: 16.sp),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
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
                _buildMetricItem(Icons.remove_red_eye_outlined, listing.views),
                SizedBox(width: 24.w),
                _buildMetricItem(Icons.favorite_border_rounded, listing.favorites),
                SizedBox(width: 24.w),
                _buildMetricItem(Icons.chat_bubble_outline_rounded, listing.messages),
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

    if (status == 'Pending') {
      bg = const Color(0xFFFFF3CD);
      fg = const Color(0xFF856404);
    } else if (status == 'Active') {
      bg = const Color(0xFFD4EDDA);
      fg = const Color(0xFF155724);
    } else if (status == 'Featured') {
      bg = const Color(0xFFF0A020);
      fg = Colors.white;
    } else if (status == 'Expired') {
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
          if (status == 'Featured') ...[
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
