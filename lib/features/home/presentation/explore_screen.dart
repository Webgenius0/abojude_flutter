import 'package:abojude_flutter/features/explore_deatils_screen/business_screen.dart';
import 'package:abojude_flutter/features/home/presentation/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


import '../../explore_deatils_screen/job_screen.dart';
import '../../explore_deatils_screen/services_screen.dart';
import '../widget/filter_screeen.dart';

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
}

// ─── Sample Data ─────────────────────────────────────────────────────────────

final List<Listing> _allListings = [
  Listing(
    id: '1',
    title: 'Samsung Galaxy S24 Ultra Excelle...',
    price: '\$1,199',
    category: 'Buy & Sell',
    location: 'Toronto, Manitoba',
    timeAgo: '5 day ago',
    imageUrl:
        'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400',
    isFeatured: false,
  ),
  Listing(
    id: '2',
    title: 'Shop Vancouver',
    category: 'Business',
    location: 'Toronto, Manitoba',
    timeAgo: '5 day ago',
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    isFeatured: false,
  ),
  Listing(
    id: '3',
    title: 'Restaurant Manager Needed',
    category: 'Jobs',
    location: 'Toronto, Manitoba',
    timeAgo: '3 minutes ago',
    imageUrl:
        'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
    isFeatured: false,
  ),
  Listing(
    id: '4',
    title: 'Professional Cleaning Services',
    category: 'Services',
    location: 'Toronto, Manitoba',
    timeAgo: '21 hours ago',
    imageUrl:
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
    isFeatured: true,
  ),
  Listing(
    id: '5',
    title: 'Halal Butcher Shop Vancouver',
    category: 'Business',
    location: 'Vancouver, BC',
    timeAgo: '4 day ago',
    imageUrl:
        'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400',
    isFeatured: true,
  ),
  Listing(
    id: '6',
    title: 'iPhone 15 Pro Max - Like New',
    price: '\$999',
    category: 'Buy & Sell',
    location: 'Calgary, Alberta',
    timeAgo: '1 hour ago',
    imageUrl:
        'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400',
    isFeatured: false,
  ),
  Listing(
    id: '7',
    title: 'Software Developer Needed',
    category: 'Jobs',
    location: 'Toronto, Ontario',
    timeAgo: '2 hours ago',
    imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400',
    isFeatured: true,
  ),
  Listing(
    id: '8',
    title: 'Furniture - Sofa Set',
    price: '\$450',
    category: 'Buy & Sell',
    location: 'Ottawa, Ontario',
    timeAgo: '3 days ago',
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
    isFeatured: false,
  ),
];

// ─── Explore Screen ───────────────────────────────────────────────────────────

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  ListingCategory _selectedCategory = ListingCategory.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Listing> _listings = List.from(_allListings);
  static const Color navyBlue = Color(0xFF1B2D6B);
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  void _applyFilters() {
    _listings = _allListings.where((listing) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          listing.title.toLowerCase().contains(_searchQuery) ||
          listing.category.toLowerCase().contains(_searchQuery) ||
          listing.location.toLowerCase().contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == ListingCategory.all ||
          (_selectedCategory == ListingCategory.buyAndSell &&
              listing.category == 'Buy & Sell') ||
          (_selectedCategory == ListingCategory.jobs &&
              listing.category == 'Jobs') ||
          (_selectedCategory == ListingCategory.business &&
              listing.category == 'Business') ||
          (_selectedCategory == ListingCategory.services &&
              listing.category == 'Services');

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _selectCategory(ListingCategory category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      final index = _listings.indexWhere((l) => l.id == id);
      if (index != -1) {
        _listings[index].isFavorited = !_listings[index].isFavorited;
        // Also update in allListings
        final allIndex = _allListings.indexWhere((l) => l.id == id);
        if (allIndex != -1) {
          _allListings[allIndex].isFavorited = _listings[index].isFavorited;
        }
      }
    });
  }

  FilterOptions _activeFilters = FilterOptions();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryTabs(),
            _buildResultCount(),
            Expanded(child: _buildListingsGrid()),
          ],
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
          SizedBox(width: 10),
          GestureDetector(
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
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color:  navyBlue,
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
                _selectCategory(cat.$1); // Only keep category selection
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A56DB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A56DB)
                        : const Color(0xFFD1D5DB),
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

  Widget _buildResultCount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        '${_listings.length} listing found',
        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildListingsGrid() {
    if (_listings.isEmpty) {
      return Center(
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
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _listings.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final category = _listings[index].category;

            switch (category) {
              case 'Buy & Sell':
                Get.to(() => const ProductDetailsScreen());
                break;

              case 'Business':
                Get.to(() => const BusinessScreen());
                break;

              case 'Jobs':
                Get.to(() => const JobScreen());
                break;

              case 'Services':
                Get.to(() => const ServicesScreen());
                break;

              default:
                Get.to(() => const BusinessScreen());
            }
          },
          child: _ListingCard(
            listing: _listings[index],
            onFavoriteToggle: () => _toggleFavorite(_listings[index].id),
          ),
        );
      },
    );
  }
}
// ─── Listing Card ─────────────────────────────────────────────────────────────

class _ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onFavoriteToggle;

  const _ListingCard({required this.listing, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImage(), _buildDetails()],
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: SizedBox(
            height: 130,
            width: double.infinity,
            child: Image.network(
              listing.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE5E7EB),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 36,
                ),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFE5E7EB),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
        ),
        // Time badge
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
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
                    color: Colors.black.withOpacity(0.1),
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
