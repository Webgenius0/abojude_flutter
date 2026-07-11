import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/business_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/job_screen.dart';
import 'package:abojude_flutter/features/explore_deatils_screen/services_screen.dart';
import 'package:abojude_flutter/features/home/presentation/product_details_screen.dart';
import 'package:abojude_flutter/features/home/model/recent_post_list_model.dart';

class ListingCard extends StatefulWidget {
  final dynamic item;
  final VoidCallback? onFavoriteToggle;

  const ListingCard({
    super.key,
    required this.item,
    this.onFavoriteToggle,
  });

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  static const Color navyBlue = Color(0xFF1B2D6B);
  static const Color accentYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    final String title = item is Map ? (item['title'] as String? ?? '') : (item.title ?? '');
    final String category = item is Map ? (item['category'] as String? ?? '') : (item.categoryName ?? '');
    final String? imageUrl = item is Map ? (item['imageUrl'] as String?) : (item.thumbnail);
    final bool isFeatured = item is Map ? (item['isFeatured'] as bool? ?? false) : (item.isFeatured ?? false);
    final String time = item is Map ? (item['time'] as String? ?? '') : (item.timeAgo ?? '');
    final bool isFavorite = item is Map ? (item['isFavorite'] as bool? ?? false) : (item.isWish ?? false);
    final bool hasPrice = item is Map ? (item['hasPrice'] as bool? ?? false) : (item.price != null && item.price.toString().isNotEmpty);
    final String priceStr = item is Map ? (item['price'] as String? ?? '') : (item.price != null ? (item.price.toString().startsWith('£') ? item.price.toString() : '£${item.price}') : '');
    final String location = item is Map ? (item['location'] as String? ?? '') : ("${item.city ?? ''}${item.city != null && item.province != null ? ', ' : ''}${item.province ?? ''}");
    final IconData icon = item is Map ? (item['icon'] as IconData? ?? Icons.image) : Icons.image;

    return GestureDetector(
      onTap: () {
        if (category == 'Buy & Sell') {
          Get.to(() => const ProductDetailsScreen());
        } else if (category == 'Business') {
          Get.to(() => const BusinessScreen());
        } else if (category == 'Jobs') {
          Get.to(() => const JobScreen());
        } else if (category == 'Services') {
          Get.to(() => const ServicesScreen());
        }
      },
      child: Container(
        width: 165,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  icon,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              icon,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          ),
                  ),
                ),
                if (isFeatured)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                if (time.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        time,
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (item is Map) {
                          item['isFavorite'] = !(item['isFavorite'] as bool? ?? false);
                        } else if (item is Datum) {
                          item.isWish = !(item.isWish ?? false);
                        }
                      });
                      widget.onFavoriteToggle?.call();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
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
                  if (hasPrice)
                    Text(
                      priceStr,
                      style: const TextStyle(
                        color: navyBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade500,
                          ),
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
      ),
    );
  }
}
