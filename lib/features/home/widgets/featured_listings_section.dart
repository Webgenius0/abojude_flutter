import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:abojude_flutter/features/home/model/get_featured_listings_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'listing_card.dart';
import 'package:get/get.dart';

class FeaturedListingsSection extends StatefulWidget {
  final Function(Datum item)? onFavoriteToggle;

  const FeaturedListingsSection({super.key, this.onFavoriteToggle});

  @override
  State<FeaturedListingsSection> createState() =>
      _FeaturedListingsSectionState();
}

class _FeaturedListingsSectionState extends State<FeaturedListingsSection> {
  bool _showAllFeatured = false;

  static const Color navyBlue = Color(0xFF1B2D6B);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GetFeaturedListingsModel>(
      stream: getFeaturedListingsRxObj.getFeaturedListingsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return _buildShimmerLoading();
        }

        final featuredModel = snapshot.data;
        final items = featuredModel?.data ?? [];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final bool canToggle = items.length > 3;
        final int count = _showAllFeatured
            ? items.length
            : (items.length > 3 ? 3 : items.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'Featured Listings',
              seeAllText: _showAllFeatured ? 'See Less' : 'See All',
              onTapSeeAll: canToggle
                  ? () {
                      setState(() {
                        _showAllFeatured = !_showAllFeatured;
                      });
                    }
                  : null,
            ),
            SizedBox(
              height: 230,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: count,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
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
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Featured Listings'),
        SizedBox(
          height: 230,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => Container(
                width: 165,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
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
            title.tr,
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
                  seeAllText.tr,
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
