import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:abojude_flutter/features/home/model/recent_post_list_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'listing_card.dart';

class RecentListingsSection extends StatefulWidget {
  final Function(Datum item)? onFavoriteToggle;

  const RecentListingsSection({
    super.key,
    this.onFavoriteToggle,
  });

  @override
  State<RecentListingsSection> createState() => _RecentListingsSectionState();
}

class _RecentListingsSectionState extends State<RecentListingsSection> {
  bool _showAllRecent = false;

  static const Color navyBlue = Color(0xFF1B2D6B);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RecentPostListModel>(
      stream: getRecentPostListRxObj.getRecentPostListData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return _buildShimmerRecentListings();
        }

        final recentPostModel = snapshot.data;
        final items = recentPostModel?.data ?? [];

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        final int count = _showAllRecent
            ? items.length
            : (items.length > 4 ? 4 : items.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              'Recent Listings',
              seeAllText: _showAllRecent ? 'See Less' : 'See All',
              onTapSeeAll: () {
                setState(() {
                  _showAllRecent = !_showAllRecent;
                });
              },
            ),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: count,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
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
          ],
        );
      },
    );
  }

  Widget _buildShimmerRecentListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Recent Listings',
          seeAllText: 'See All',
          onTapSeeAll: null,
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
