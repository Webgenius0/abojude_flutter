import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/filter_screeen.dart';
import '../widgets/categories_section.dart';
import '../widgets/featured_listings_section.dart';
import '../widgets/recent_listings_section.dart';
import 'notificatosn_screen.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  static const Color navyBlue = Color(0xFF1B2D6B);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color bgGrey = Color(0xFFF5F5F5);

  final List<Map<String, dynamic>> _banners = [
    {
      'tag': 'TRUSTED SERVICES',
      'title': 'Find Trusted',
      'highlight': 'Services Near You',
      'subtitle':
          'From home repairs to cleaning, connect with reliable professionals for every need.',
      'stats': [
        'Verified\nProfessionals',
        'Quality\nService',
        'Save Time\n& Effort',
        'Satisfaction\nGuaranteed',
      ],
      'statIcons': [
        Icons.verified_user,
        Icons.star,
        Icons.access_time,
        Icons.thumb_up,
      ],
      'bgColor': Color(0xFF1B4332),
    },
    {
      'tag': 'HOME REPAIRS',
      'title': 'Expert Repair',
      'highlight': 'At Your Doorstep',
      'subtitle':
          'Skilled technicians ready to fix plumbing, electrical, and more.',
      'stats': [
        'Licensed\nExperts',
        'Fast\nResponse',
        'Affordable\nRates',
        '5-Star\nRatings',
      ],
      'statIcons': [
        Icons.construction,
        Icons.bolt,
        Icons.attach_money,
        Icons.grade,
      ],
      'bgColor': Color(0xFF1A237E),
    },
    {
      'tag': 'CLEANING',
      'title': 'Spotless Homes',
      'highlight': 'Every Single Time',
      'subtitle':
          'Professional cleaning services for homes, offices, and commercial spaces.',
      'stats': [
        'Eco\nFriendly',
        'Deep\nClean',
        'Flexible\nSchedule',
        '100%\nSafe',
      ],
      'statIcons': [
        Icons.eco,
        Icons.cleaning_services,
        Icons.calendar_month,
        Icons.security,
      ],
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
      'imageUrl':
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500&auto=format&fit=crop&q=80',
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
      'imageUrl':
          'https://images.unsplash.com/photo-1552664730-d307ca884978?w=500&auto=format&fit=crop&q=80',
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
      'imageUrl':
          'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?w=500&auto=format&fit=crop&q=80',
    },
    {
      'price': '',
      'title': 'Professional Cleaning Services',
      'category': 'Services',
      'location': 'Toronto, Manitoba',
      'time': '21 hours ago',
      'isFeatured': true,
      'hasPrice': false,
      'icon': Icons.cleaning_services,
      'imageUrl':
          'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=500&auto=format&fit=crop&q=80',
    },
    {
      'price': '\$800',
      'title': 'Sony PlayStation 5 Slim Edition',
      'category': 'Buy & Sell',
      'location': 'Montreal, Quebec',
      'time': '1 day ago',
      'isFeatured': true,
      'hasPrice': true,
      'icon': Icons.sports_esports,
      'imageUrl':
          'https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=500&auto=format&fit=crop&q=80',
    },
    {
      'price': '',
      'title': 'Software Developer Internship',
      'category': 'Jobs',
      'location': 'Ottawa, Ontario',
      'time': '3 days ago',
      'isFeatured': true,
      'hasPrice': false,
      'icon': Icons.code,
      'imageUrl':
          'https://images.unsplash.com/photo-1607799279861-4dd421887fb3?w=500&auto=format&fit=crop&q=80',
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
      'imageUrl':
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500&auto=format&fit=crop&q=80',
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
      'imageUrl':
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=500&auto=format&fit=crop&q=80',
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
      'imageUrl':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&auto=format&fit=crop&q=80',
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
      'imageUrl':
          'https://images.unsplash.com/photo-1607349913338-fca6f7fc42d0?w=500&auto=format&fit=crop&q=80',
    },
    {
      'price': '\$35',
      'title': 'Premium Ergonomic Office Chair',
      'category': 'Buy & Sell',
      'location': 'Edmonton, Alberta',
      'time': '4 hours ago',
      'isFeatured': false,
      'hasPrice': true,
      'icon': Icons.chair,
      'imageUrl':
          'https://images.unsplash.com/photo-1505797149-43b0069ec26b?w=500&auto=format&fit=crop&q=80',
    },
    {
      'price': '',
      'title': 'Arabic Tutor for Children',
      'category': 'Services',
      'location': 'Halifax, Nova Scotia',
      'time': '2 days ago',
      'isFeatured': false,
      'hasPrice': false,
      'icon': Icons.school,
      'imageUrl':
          'https://images.unsplash.com/photo-1577896851231-70ef18881754?w=500&auto=format&fit=crop&q=80',
    },
  ];

  late List<Map<String, dynamic>> _filteredFeaturedItems;
  late List<Map<String, dynamic>> _filteredRecentItems;

  @override
  void initState() {
    super.initState();
    _filteredFeaturedItems = List.from(_featuredItems);
    _filteredRecentItems = List.from(_recentItems);
    getCategoryListRxObj.getCategoryListRx();
    getRecentPostListRxObj.getRecentPostListRx();
  }

  void _applyFilters() {
    setState(() {
      _filteredFeaturedItems = _featuredItems.where((item) {
        final category = item['category'] as String? ?? '';
        final matchesCategory =
            _activeFilters.category == 'All' ||
            (category.toLowerCase() == _activeFilters.category.toLowerCase()) ||
            (_activeFilters.category == 'Business Directory' &&
                category == 'Business');

        final location = (item['location'] as String? ?? '').toLowerCase();
        final matchesProvince =
            _activeFilters.province == null ||
            location.contains(_activeFilters.province!.toLowerCase());
        final matchesCity =
            _activeFilters.city == null ||
            location.contains(_activeFilters.city!.toLowerCase());

        // Price filter if item has price
        bool matchesPrice = true;
        if (item['hasPrice'] as bool? ?? false) {
          final priceStr = (item['price'] as String? ?? '').replaceAll(
            RegExp(r'[^\d.]'),
            '',
          );
          final price = double.tryParse(priceStr);
          if (price != null) {
            if (_activeFilters.minPrice != null &&
                price < _activeFilters.minPrice!) {
              matchesPrice = false;
            }
            if (_activeFilters.maxPrice != null &&
                price > _activeFilters.maxPrice!) {
              matchesPrice = false;
            }
          }
        }

        return matchesCategory &&
            matchesProvince &&
            matchesCity &&
            matchesPrice;
      }).toList();

      _filteredRecentItems = _recentItems.where((item) {
        final category = item['category'] as String? ?? '';
        final matchesCategory =
            _activeFilters.category == 'All' ||
            (category.toLowerCase() == _activeFilters.category.toLowerCase()) ||
            (_activeFilters.category == 'Business Directory' &&
                category == 'Business');

        final location = (item['location'] as String? ?? '').toLowerCase();
        final matchesProvince =
            _activeFilters.province == null ||
            location.contains(_activeFilters.province!.toLowerCase());
        final matchesCity =
            _activeFilters.city == null ||
            location.contains(_activeFilters.city!.toLowerCase());

        // Price filter if item has price
        bool matchesPrice = true;
        if (item['hasPrice'] as bool? ?? false) {
          final priceStr = (item['price'] as String? ?? '').replaceAll(
            RegExp(r'[^\d.]'),
            '',
          );
          final price = double.tryParse(priceStr);
          if (price != null) {
            if (_activeFilters.minPrice != null &&
                price < _activeFilters.minPrice!) {
              matchesPrice = false;
            }
            if (_activeFilters.maxPrice != null &&
                price > _activeFilters.maxPrice!) {
              matchesPrice = false;
            }
          }
        }

        return matchesCategory &&
            matchesProvince &&
            matchesCity &&
            matchesPrice;
      }).toList();

      // Sort logic based on sortBy
      if (_activeFilters.sortBy == 'Price: Low to High') {
        _filteredFeaturedItems.sort((a, b) => _comparePrice(a, b));
        _filteredRecentItems.sort((a, b) => _comparePrice(a, b));
      } else if (_activeFilters.sortBy == 'Price: High to Low') {
        _filteredFeaturedItems.sort((a, b) => _comparePrice(b, a));
        _filteredRecentItems.sort((a, b) => _comparePrice(b, a));
      }
    });
  }

  int _comparePrice(Map<String, dynamic> a, Map<String, dynamic> b) {
    final priceAStr = (a['price'] as String? ?? '').replaceAll(
      RegExp(r'[^\d.]'),
      '',
    );
    final priceBStr = (b['price'] as String? ?? '').replaceAll(
      RegExp(r'[^\d.]'),
      '',
    );
    final priceA = double.tryParse(priceAStr) ?? 0.0;
    final priceB = double.tryParse(priceBStr) ?? 0.0;
    return priceA.compareTo(priceB);
  }

  FilterOptions _activeFilters = FilterOptions();
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
              FeaturedListingsSection(
                featuredItems: _filteredFeaturedItems,
                onFavoriteToggle: (item) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              const CategoriesSection(),
              const SizedBox(height: 20),
              RecentListingsSection(
                onFavoriteToggle: (item) {
                  setState(() {});
                },
              ),
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
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/Logos.png'),
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              const SizedBox(width: 8),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'WASEL ',
                      style: TextStyle(
                        color: Color(0xFF278738),
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
            onTap: () {
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
              child: Icon(
                Icons.notifications_outlined,
                color: navyBlue,
                size: 22,
              ),
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
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
                child: GestureDetector(
                  onTap: () {
                    showFilterBottomSheet(
                      context,
                      currentFilters: _activeFilters,
                      onApply: (filters) {
                        setState(() {
                          _activeFilters = filters;
                          _applyFilters(); // your existing filter method
                        });
                      },
                    );
                  },
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
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 22,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showFilterBottomSheet(
                    context,
                    currentFilters: _activeFilters,
                    onApply: (filters) {
                      setState(() {
                        _activeFilters = filters;
                        _applyFilters();
                      });
                    },
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: navyBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 22),
                ),
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
            height: 215,
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
                  color: _currentBannerIndex == index
                      ? lightGreen
                      : Colors.grey.shade300,
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
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        // color: banner['bgColor'] as Color,
        image: DecorationImage(
          image: AssetImage('assets/images/bannerImage.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      // child: Stack(
      //   children: [
      //     Positioned(
      //       right: -20,
      //       top: -20,
      //       child: Container(
      //         width: 120,
      //         height: 120,
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(0.05),
      //           shape: BoxShape.circle,
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       right: 20,
      //       bottom: -30,
      //       child: Container(
      //         width: 80,
      //         height: 80,
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(0.05),
      //           shape: BoxShape.circle,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Container(
      //             padding: const EdgeInsets.symmetric(
      //               horizontal: 10,
      //               vertical: 4,
      //             ),
      //             decoration: BoxDecoration(
      //               color: lightGreen.withOpacity(0.2),
      //               borderRadius: BorderRadius.circular(20),
      //               border: Border.all(color: lightGreen.withOpacity(0.5)),
      //             ),
      //             child: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 const Icon(Icons.verified, color: lightGreen, size: 12),
      //                 const SizedBox(width: 4),
      //                 Text(
      //                   banner['tag'] as String,
      //                   style: const TextStyle(
      //                     color: lightGreen,
      //                     fontSize: 10,
      //                     fontWeight: FontWeight.w600,
      //                     letterSpacing: 0.5,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           const SizedBox(height: 8),
      //           Text(
      //             banner['title'] as String,
      //             style: const TextStyle(
      //               color: Colors.white,
      //               fontSize: 18,
      //               fontWeight: FontWeight.w800,
      //             ),
      //           ),
      //           Text(
      //             banner['highlight'] as String,
      //             style: const TextStyle(
      //               color: lightGreen,
      //               fontSize: 18,
      //               fontWeight: FontWeight.w800,
      //             ),
      //           ),
      //           const SizedBox(height: 4),
      //           Text(
      //             banner['subtitle'] as String,
      //             style: TextStyle(
      //               color: Colors.white.withOpacity(0.75),
      //               fontSize: 10,
      //             ),
      //             maxLines: 2,
      //             overflow: TextOverflow.ellipsis,
      //           ),
      //           const SizedBox(height: 10),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: List.generate(
      //               4,
      //               (i) => Column(
      //                 children: [
      //                   Icon(
      //                     (banner['statIcons'] as List<IconData>)[i],
      //                     color: Colors.white,
      //                     size: 16,
      //                   ),
      //                   const SizedBox(height: 2),
      //                   Text(
      //                     (banner['stats'] as List<String>)[i],
      //                     textAlign: TextAlign.center,
      //                     style: TextStyle(
      //                       color: Colors.white.withOpacity(0.85),
      //                       fontSize: 8,
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
