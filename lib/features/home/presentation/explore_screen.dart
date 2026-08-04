import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:abojude_flutter/features/explore_deatils_screen/business_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/job_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/services_screen.dart';
import 'package:abojude_flutter/features/home/presentation/product_details_screen.dart';
import 'package:abojude_flutter/features/home/model/get_explore_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import '../widgets/filter_screeen.dart';

// ─── Data Models ────────────────────────────────────────────────────────────

enum ListingCategory { all, buyAndSell, business, jobs, services }

class Listing {
  final String id;
  final String title;
  final String? price;
  final String category;
  final String location;
  final String timeAgo;
  final String imageUrl;
  final bool isFeatured;
  bool isFavorited;

  Listing({
    required this.id,
    required this.title,
    this.price,
    required this.category,
    required this.location,
    required this.timeAgo,
    required this.imageUrl,
    this.isFeatured = false,
    this.isFavorited = false,
  });

  factory Listing.fromDatum(Datum datum) {
    return Listing(
      id: datum.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: datum.title ?? '',
      price: datum.price != null && datum.price.toString().isNotEmpty
          ? (datum.price.toString().startsWith('£') || datum.price.toString().startsWith('\$')
              ? datum.price.toString()
              : '£${datum.price}')
          : null,
      category: datum.categoryName ?? '',
      location: "${datum.city ?? ''}${datum.city != null && datum.province != null ? ', ' : ''}${datum.province ?? ''}",
      timeAgo: datum.timeAgo ?? '',
      imageUrl: datum.thumbnail ?? '',
      isFeatured: datum.isFeatured ?? false,
      isFavorited: datum.isWish ?? false,
    );
  }
}

// ─── Explore Screen ───────────────────────────────────────────────────────────

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  ListingCategory _selectedCategory = ListingCategory.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  FilterOptions _activeFilters = FilterOptions();
  bool _isLoading = true;

  static const Color navyBlue = Color(0xFF1B2D6B);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _searchController.addListener(_onSearchChanged);
    _fetchExploreList();
  }

  Future<void> _fetchExploreList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    List<String>? categorySlugs;
    if (_selectedCategory == ListingCategory.buyAndSell) {
      categorySlugs = ['buy-and-sell'];
    } else if (_selectedCategory == ListingCategory.business) {
      categorySlugs = ['business'];
    } else if (_selectedCategory == ListingCategory.jobs) {
      categorySlugs = ['jobs'];
    } else if (_selectedCategory == ListingCategory.services) {
      categorySlugs = ['services'];
    } else if (_activeFilters.category != 'All' && _activeFilters.category.isNotEmpty) {
      categorySlugs = [_activeFilters.category.toLowerCase().replaceAll(' ', '-').replaceAll('&', 'and')];
    }

    try {
      await getExploreRxObj.getExploreRx(
        categorySlugs: categorySlugs,
        province: _activeFilters.province,
        city: _activeFilters.city,
        minPrice: _activeFilters.minPrice?.toInt(),
        maxPrice: _activeFilters.maxPrice?.toInt(),
        sortBy: _activeFilters.sortBy != 'Featured' ? _activeFilters.sortBy : null,
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (_searchQuery != query) {
      setState(() {
        _searchQuery = query;
      });
      _fetchExploreList();
    }
  }

  void _selectCategory(ListingCategory category) {
    if (_selectedCategory != category) {
      setState(() {
        _selectedCategory = category;
      });
      _fetchExploreList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchExploreList,
          color: navyBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryTabs(),
              Expanded(
                child: StreamBuilder<GetExploreModel>(
                  stream: getExploreRxObj.getExploreData,
                  builder: (context, snapshot) {
                    if (_isLoading ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerGrid();
                    }

                    final rawItems = snapshot.data?.data ?? [];
                    final List<Listing> listings =
                        rawItems.map((d) => Listing.fromDatum(d)).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultCount(listings.length),
                        Expanded(
                          child: _buildListingsGrid(listings),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        'Explore',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111111),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'What are you looking for?',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.grey[500],
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
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
                  });
                  _fetchExploreList();
                },
              );
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: navyBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = [
      (ListingCategory.all, 'All'),
      (ListingCategory.buyAndSell, 'Buy & Sell'),
      (ListingCategory.business, 'Business'),
      (ListingCategory.jobs, 'Jobs'),
      (ListingCategory.services, 'Services'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                _selectCategory(cat.$1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? navyBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? navyBlue : const Color(0xFFD1D5DB),
                  ),
                ),
                child: Text(
                  cat.$2,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultCount(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        '$count ${count == 1 ? 'listing' : 'listings'} found',
        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
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
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListingsGrid(List<Listing> listings) {
    if (listings.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'No listings found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try a different search or category',
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      );
    }
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final item = listings[index];
        final double start = (index * 0.05).clamp(0.0, 0.7);
        final double end = (start + 0.3).clamp(0.3, 1.0);

        final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        );

        final slideAnim = Tween<Offset>(
          begin: const Offset(0.0, 0.15),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        );

        return FadeTransition(
          opacity: fadeAnim,
          child: SlideTransition(
            position: slideAnim,
            child: GestureDetector(
              onTap: () {
                final category = item.category;

                final int? postId = int.tryParse(item.id);

                if (category.toLowerCase().contains('buy') ||
                    category.toLowerCase().contains('sell')) {
                  Get.to(() => ProductDetailsScreen(postId: postId));
                } else if (category.toLowerCase().contains('business')) {
                  Get.to(() => BusinessScreen(postId: postId));
                } else if (category.toLowerCase().contains('job')) {
                  Get.to(() => JobScreen(postId: postId));
                } else if (category.toLowerCase().contains('service')) {
                  Get.to(() => const ServicesScreen());
                } else {
                  Get.to(() => BusinessScreen(postId: postId));
                }
              },
              child: _ListingCard(
                listing: item,
                onFavoriteToggle: () {
                  setState(() {
                    item.isFavorited = !item.isFavorited;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Listing Card Widget with CachedNetworkImage ───────────────────────────────

class _ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onFavoriteToggle;

  const _ListingCard({
    required this.listing,
    required this.onFavoriteToggle,
  });

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          _buildDetails(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final formattedUrl = _formatImageUrl(listing.imageUrl);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: SizedBox(
            height: 130,
            width: double.infinity,
            child: formattedUrl != null && formattedUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: formattedUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 36,
                      ),
                    ),
                  )
                : Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 36,
                    ),
                  ),
          ),
        ),
        // Time badge
        if (listing.timeAgo.isNotEmpty)
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                listing.timeAgo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        // Featured badge
        if (listing.isFeatured)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.white, size: 10),
                  SizedBox(width: 3),
                  Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        // Favorite button
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                listing.isFavorited ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: listing.isFavorited
                    ? Colors.red
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (listing.price != null) ...[
              Text(
                listing.price!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A56DB),
                ),
              ),
              const SizedBox(height: 2),
            ],
            Text(
              listing.title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            if (listing.category.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  listing.category,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    listing.location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
