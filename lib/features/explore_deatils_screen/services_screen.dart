import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abojude_flutter/features/home/presentation/product_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class ServiceItem {
  final String id;
  final String title;
  final String category;
  final String rate;
  final String location;
  final String timeAgo;
  final String imageUrl;
  final bool isFeatured;
  bool isFavorited;

  ServiceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.rate,
    required this.location,
    required this.timeAgo,
    required this.imageUrl,
    this.isFeatured = false,
    this.isFavorited = false,
  });
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<ServiceItem> _allItems = [
    ServiceItem(
      id: 's1',
      title: 'Professional Cleaning Services',
      category: 'Cleaning',
      rate: '\$25/hour',
      location: 'Toronto, MB',
      timeAgo: '21 hours ago',
      imageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
      isFeatured: true,
    ),
    ServiceItem(
      id: 's2',
      title: 'Certified Plumbing & Heating',
      category: 'Plumbing',
      rate: 'Contact for Quote',
      location: 'Vancouver, BC',
      timeAgo: '2 days ago',
      imageUrl: 'https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=400',
      isFeatured: true,
    ),
    ServiceItem(
      id: 's3',
      title: 'Complete Home Care Services',
      category: 'Caregiving',
      rate: '\$30/hour',
      location: 'Calgary, AB',
      timeAgo: '1 day ago',
      imageUrl: 'https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?w=400',
    ),
    ServiceItem(
      id: 's4',
      title: 'Professional Auto Detailing',
      category: 'Automotive',
      rate: 'From \$99',
      location: 'Ottawa, ON',
      timeAgo: '3 days ago',
      imageUrl: 'https://images.unsplash.com/photo-1607860108855-64acf2078ed9?w=400',
    ),
    ServiceItem(
      id: 's5',
      title: 'Math & Science Home Tutoring',
      category: 'Education',
      rate: '\$40/hour',
      location: 'Montreal, QC',
      timeAgo: '4 days ago',
      imageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400',
    ),
    ServiceItem(
      id: 's6',
      title: 'Digital Marketing & SEO Services',
      category: 'Marketing',
      rate: 'Free Consultation',
      location: 'Remote',
      timeAgo: '1 week ago',
      imageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400',
    ),
  ];

  List<ServiceItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_allItems);
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
      _filteredItems = _allItems.where((item) {
        return item.title.toLowerCase().contains(_searchQuery) ||
            item.category.toLowerCase().contains(_searchQuery) ||
            item.location.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      final index = _allItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _allItems[index].isFavorited = !_allItems[index].isFavorited;
        // Sync with filtered list
        final filteredIndex = _filteredItems.indexWhere((item) => item.id == id);
        if (filteredIndex != -1) {
          _filteredItems[filteredIndex].isFavorited = _allItems[index].isFavorited;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Services Directory',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildResultsHeader(),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search Services...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500], size: 18),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        '${_filteredItems.length} services found',
        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
      ),
    );
  }

  Widget _buildGrid() {
    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No services found',
              style: TextStyle(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w500),
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
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        return GestureDetector(
          onTap: () => Get.to(() => const ProductDetailsScreen()),
          child: Container(
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
                _buildCardImage(item),
                _buildCardDetails(item),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardImage(ServiceItem item) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: SizedBox(
            height: 130,
            width: double.infinity,
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE5E7EB),
                child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 36),
              ),
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFE5E7EB),
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
            ),
          ),
        ),
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
              item.timeAgo,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        if (item.isFeatured)
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
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => _toggleFavorite(item.id),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
              ),
              child: Icon(
                item.isFavorited ? Icons.favorite : Icons.favorite_border,
                size: 16,
                color: item.isFavorited ? Colors.red : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardDetails(ServiceItem item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.rate,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2D6B),
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    item.location,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
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
