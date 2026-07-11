import 'package:flutter/material.dart';
import 'listing_card.dart';

class FeaturedListingsSection extends StatefulWidget {
  final List<Map<String, dynamic>> featuredItems;
  final Function(Map<String, dynamic> item)? onFavoriteToggle;

  const FeaturedListingsSection({
    super.key,
    required this.featuredItems,
    this.onFavoriteToggle,
  });

  @override
  State<FeaturedListingsSection> createState() => _FeaturedListingsSectionState();
}

class _FeaturedListingsSectionState extends State<FeaturedListingsSection> {
  bool _showAllFeatured = false;

  static const Color navyBlue = Color(0xFF1B2D6B);

  @override
  Widget build(BuildContext context) {
    
    final int count = _showAllFeatured
        ? widget.featuredItems.length
        : (widget.featuredItems.length > 3
            ? 3
            : widget.featuredItems.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Featured Listings',
          seeAllText: _showAllFeatured ? 'See Less' : 'See All',
          onTapSeeAll: () {
            setState(() {
              _showAllFeatured = !_showAllFeatured;
            });
          },
        ),
        SizedBox(
          height: 230,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: count,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = widget.featuredItems[index];
              return ListingCard(
                item: item,
                onFavoriteToggle: () {
                  widget.onFavoriteToggle?.call(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title, {
    VoidCallback? onTapSeeAll,
    String seeAllText = 'See All',
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          if (onTapSeeAll != null)
            GestureDetector(
              onTap: onTapSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  seeAllText,
                  style: const TextStyle(
                    fontSize: 13,
                    color: navyBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
