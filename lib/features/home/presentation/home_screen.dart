
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'notificatosn_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  static const Color navyBlue = Color(0xFF1B2D6B);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color bgGrey = Color(0xFFF5F5F5);

  final List<Map<String, dynamic>> _banners = [
    {
      'tag': 'TRUSTED SERVICES',
      'title': 'Find Trusted',
      'highlight': 'Services Near You',
      'subtitle': 'From home repairs to cleaning, connect with reliable professionals for every need.',
      'stats': ['Verified\nProfessionals', 'Quality\nService', 'Save Time\n& Effort', 'Satisfaction\nGuaranteed'],
      'statIcons': [Icons.verified_user, Icons.star, Icons.access_time, Icons.thumb_up],
      'bgColor': Color(0xFF1B4332),
    },
    {
      'tag': 'HOME REPAIRS',
      'title': 'Expert Repair',
      'highlight': 'At Your Doorstep',
      'subtitle': 'Skilled technicians ready to fix plumbing, electrical, and more.',
      'stats': ['Licensed\nExperts', 'Fast\nResponse', 'Affordable\nRates', '5-Star\nRatings'],
      'statIcons': [Icons.construction, Icons.bolt, Icons.attach_money, Icons.grade],
      'bgColor': Color(0xFF1A237E),
    },
    {
      'tag': 'CLEANING',
      'title': 'Spotless Homes',
      'highlight': 'Every Single Time',
      'subtitle': 'Professional cleaning services for homes, offices, and commercial spaces.',
      'stats': ['Eco\nFriendly', 'Deep\nClean', 'Flexible\nSchedule', '100%\nSafe'],
      'statIcons': [Icons.eco, Icons.cleaning_services, Icons.calendar_month, Icons.security],
      'bgColor': Color(0xFF004D40),
    },
  ];

  final List<Map<String, dynamic>> _featuredItems = [
    {
      'price': '\$1,199',
      'title': 'Samsung Galaxy S24 Ultra Excelle...',
      'category': 'Buy & Sell',
      'location': 'Toronto, Manitoba',
      'time': '5 day ago',
      'isFeatured': true,
      'hasPrice': true,
      'icon': Icons.phone_android,
    },
    {
      'price': '',
      'title': 'Restaurant Manager Needed',
      'category': 'Jobs',
      'location': 'Toronto, Manitoba',
      'time': '5 day ago',
      'isFeatured': true,
      'hasPrice': false,
      'icon': Icons.person,
    },
    {
      'price': '\$450',
      'title': 'iPhone 14 Pro Max 256GB',
      'category': 'Buy & Sell',
      'location': 'Vancouver, BC',
      'time': '2 day ago',
      'isFeatured': true,
      'hasPrice': true,
      'icon': Icons.phone_iphone,
    },
  ];

  final List<Map<String, dynamic>> _recentItems = [
    {
      'price': '\$1,199',
      'title': 'Samsung Galaxy S24 Ultra Excelle...',
      'category': 'Buy & Sell',
      'location': 'Toronto, Manitoba',
      'time': '5 day ago',
      'isFeatured': false,
      'hasPrice': true,
      'icon': Icons.phone_android,
    },
    {
      'price': '',
      'title': 'Shop Vancouver',
      'category': 'Business',
      'location': 'Toronto, Manitoba',
      'time': '5 day ago',
      'isFeatured': true,
      'hasPrice': false,
      'icon': Icons.storefront,
    },
    {
      'price': '\$250',
      'title': 'MacBook Air M2 Like New',
      'category': 'Buy & Sell',
      'location': 'Calgary, Alberta',
      'time': '1 day ago',
      'isFeatured': false,
      'hasPrice': true,
      'icon': Icons.laptop_mac,
    },
    {
      'price': '',
      'title': 'Halal Butcher Shop',
      'category': 'Business',
      'location': 'Winnipeg, Manitoba',
      'time': '3 day ago',
      'isFeatured': true,
      'hasPrice': false,
      'icon': Icons.storefront,
    },
  ];

  final List<Map<String, dynamic>> _categoryList = [
    {
      'icon': Icons.shopping_bag_outlined,
      'label': 'Buy & Sell',
      'subtitle': 'Your Local Marketplace',
    },
    {
      'icon': Icons.work_outline,
      'label': 'Jobs',
      'subtitle': 'Find your next career opportunity',
    },
    {
      'icon': Icons.business_outlined,
      'label': 'Business Directory',
      'subtitle': 'Discover local businesses & service',
    },
    {
      'icon': Icons.build_outlined,
      'label': 'Services',
      'subtitle': 'Professional services near you',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildBannerCarousel(),
              const SizedBox(height: 20),
              _buildFeaturedListings(),
              const SizedBox(height: 20),
              _buildCategoriesList(),
              const SizedBox(height: 20),
              _buildRecentListings(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: navyBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.handyman, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'WASEL ',
                      style: TextStyle(
                        color: lightGreen,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextSpan(
                      text: 'CANADA',
                      style: TextStyle(
                        color: navyBlue,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              Get.to(NotificationScreen());
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:   Icon(Icons.notifications_outlined, color: navyBlue, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Location Row ─────────────────────────────────────────
  Widget _buildLocationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: const [
          Icon(Icons.location_on_outlined, color: Colors.black87, size: 18),
          SizedBox(width: 4),
          Text(
            'Thompson, Manitoba',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Icon(Icons.chevron_right, color: Colors.black54, size: 18),
        ],
      ),
    );
  }

  // ─── Search Bar ───────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationRow(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'What are you looking for?',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: navyBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.tune, color: Colors.white, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Banner Carousel ──────────────────────────────────────
  Widget _buildBannerCarousel() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 200,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentBannerIndex = index);
            },
          ),
          items: _banners.map((banner) => _buildBannerItem(banner)).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
                (index) => GestureDetector(
              onTap: () => _carouselController.animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentBannerIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentBannerIndex == index ? lightGreen : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(Map<String, dynamic> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: banner['bgColor'] as Color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: lightGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: lightGreen.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, color: lightGreen, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        banner['tag'] as String,
                        style: const TextStyle(
                          color: lightGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner['title'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                Text(
                  banner['highlight'] as String,
                  style: const TextStyle(color: lightGreen, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  banner['subtitle'] as String,
                  style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                        (i) => Column(
                      children: [
                        Icon((banner['statIcons'] as List<IconData>)[i], color: Colors.white, size: 16),
                        const SizedBox(height: 2),
                        Text(
                          (banner['stats'] as List<String>)[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section Title ────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          const Spacer(),
          const Text(
            'See All',
            style: TextStyle(fontSize: 13, color: navyBlue, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ─── Featured Listings ────────────────────────────────────
  Widget _buildFeaturedListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Featured Listings'),
        SizedBox(
          height: 230,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _featuredItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildListingCard(_featuredItems[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildListingCard(Map<String, dynamic> item) {
    return Container(
      width: 165,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(
                    item['icon'] as IconData,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              if (item['isFeatured'] as bool)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentYellow,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 10),
                        SizedBox(width: 3),
                        Text(
                          'Featured',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['time'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item['hasPrice'] as bool)
                  Text(
                    item['price'] as String,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                Text(
                  item['title'] as String,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item['category'] as String,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        item['location'] as String,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        overflow: TextOverflow.ellipsis,
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

  // ─── Categories List ──────────────────────────────────────
  Widget _buildCategoriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Categories'),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categoryList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cat = _categoryList[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: navyBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(cat['icon'] as IconData, color: navyBlue, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['label'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cat['subtitle'] as String,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── Recent Listings ──────────────────────────────────────
  Widget _buildRecentListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Recent Listings'),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _recentItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) => _buildListingCard(_recentItems[index]),
        ),
      ],
    );
  }
}