import 'package:abojude_flutter/features/profile/model/get_profile_model.dart';
import 'package:abojude_flutter/features/auth/register/presentation/select_location_screen.dart';
import 'package:abojude_flutter/features/home/presentation/search_products_screen.dart';
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
import 'package:abojude_flutter/features/home/model/add_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:abojude_flutter/helpers/di.dart';
import 'package:abojude_flutter/constants/app_constants.dart';

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
    getFeaturedListingsRxObj.getFeaturedListingsRx();
    adsListRxObj.getAdsListRx();

    final bool isGuest = appData.read(kKeyIsExploring) ?? false;
    if (!isGuest) {
      getProfileRxObj.getProfile();
    }
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
    final bool isGuest = appData.read(kKeyIsExploring) ?? false;

    Widget buildRow(String locationText) {
      return GestureDetector(
        onTap: () {
          Get.to(() => SelectLocationScreen(isGuest: isGuest));
        },
        child: Container(
          color: Colors.transparent, // expand tap area
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.black87,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                locationText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54, size: 18),
            ],
          ),
        ),
      );
    }

    if (isGuest) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: buildRow('Guest User'),
      );
    }

    return StreamBuilder<GetProfileModel>(
      stream: getProfileRxObj.getProfileData,
      builder: (context, snapshot) {
        String locationText = 'Thompson, Manitoba';
        if (snapshot.hasData && snapshot.data?.data != null) {
          final profile = snapshot.data!.data!;
          final city = profile.city ?? '';
          final province = profile.province ?? '';
          if (city.isNotEmpty && province.isNotEmpty) {
            locationText = '$city, $province';
          } else if (city.isNotEmpty) {
            locationText = city;
          } else if (province.isNotEmpty) {
            locationText = province;
          }
        }
        return buildRow(locationText);
      },
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
                    Get.to(() => const SearchProductsScreen());
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
                      readOnly: true,
                      enabled: false,
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

  // ─── Banner Carousel ──────────────────────────────────────
  Widget _buildBannerCarousel() {
    return StreamBuilder<AddListModel>(
      stream: adsListRxObj.getAdsListData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 215,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final adsModel = snapshot.data;
        final ads = adsModel?.data ?? [];

        if (ads.isEmpty) {
          return const SizedBox.shrink();
        }

        if (_currentBannerIndex >= ads.length) {
          _currentBannerIndex = 0;
        }

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
              items: ads.map((banner) => _buildBannerItem(banner)).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                ads.length,
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
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Widget _buildBannerItem(Datum banner) {
    final formattedUrl = _formatImageUrl(banner.media);
    return GestureDetector(
      onTap: () {
        if (banner.backLink != null && banner.backLink!.trim().isNotEmpty) {
          _launchUrl(banner.backLink!.trim());
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.grey[200],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            children: [
              Positioned.fill(
                child: formattedUrl != null && formattedUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: formattedUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/bannerImage.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : Image.asset(
                        'assets/images/bannerImage.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
              if (banner.title != null && banner.title!.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Text(
                      banner.title!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
