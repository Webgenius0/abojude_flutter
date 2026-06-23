import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Favorite Item Model
class FavoriteItem {
  final String id;
  final String title;
  final String imageUrl;
  final String category; // "Buy & Sell", "Jobs", "Business", "Services"
  final String? price;
  final String location;
  final String timeAgo;
  final bool isFeatured;

  FavoriteItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.price,
    required this.location,
    required this.timeAgo,
    this.isFeatured = false,
  });
}

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<FavoriteItem> _favorites = [
    FavoriteItem(
      id: '1',
      title: "Samsung Galaxy S24 Ultra Excelle...",
      imageUrl: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&auto=format&fit=crop&q=80",
      category: "Buy & Sell",
      price: "\$1,199",
      location: "Toronto, Manitoba",
      timeAgo: "5 day ago",
    ),
    FavoriteItem(
      id: '2',
      title: "Shop Vancouver",
      imageUrl: "https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&auto=format&fit=crop&q=80",
      category: "Business",
      location: "Toronto, Manitoba",
      timeAgo: "5 day ago",
    ),
    FavoriteItem(
      id: '3',
      title: "Restaurant Manager Needed",
      imageUrl: "https://images.unsplash.com/photo-1552664730-d307ca884978?w=400&auto=format&fit=crop&q=80",
      category: "Jobs",
      location: "Toronto, Manitoba",
      timeAgo: "3 minutes ago",
    ),
    FavoriteItem(
      id: '4',
      title: "Professional Cleaning Services",
      imageUrl: "https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400&auto=format&fit=crop&q=80",
      category: "Services",
      location: "Toronto, Manitoba",
      timeAgo: "21 hours ago",
      isFeatured: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<FavoriteItem> _getFilteredFavorites(String category) {
    if (category == 'All') return _favorites;
    return _favorites.where((f) => f.category.toLowerCase() == category.toLowerCase()).toList();
  }

  void _removeFavorite(String id) {
    setState(() {
      _favorites.removeWhere((item) => item.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECEC),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      '${_favorites.length}',
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
                labelStyle: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.bold),
                unselectedLabelStyle: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w500),
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
                  _buildFavoritesGrid('All'),
                  _buildFavoritesGrid('Buy & Sell'),
                  _buildFavoritesGrid('Jobs'),
                  _buildFavoritesGrid('Business'),
                  _buildFavoritesGrid('Services'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid builder
  Widget _buildFavoritesGrid(String categoryFilter) {
    final items = _getFilteredFavorites(categoryFilter);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No favorites in $categoryFilter',
          style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
        ),
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
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

  Widget _buildFavoriteCard(FavoriteItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(11.r),
                    topRight: Radius.circular(11.r),
                  ),
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF8F9FA),
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),

                // Featured Tag
                if (item.isFeatured)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
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
                Positioned(
                  bottom: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      item.timeAgo,
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
                    onTap: () => _removeFavorite(item.id),
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
                if (item.price != null) ...[
                  Text(
                    item.price!,
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
                  item.title,
                  maxLines: item.price == null ? 2 : 1,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    item.category,
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
                    Icon(Icons.location_on_outlined, color: Colors.grey[400], size: 12.sp),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        item.location,
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
    );
  }
}
