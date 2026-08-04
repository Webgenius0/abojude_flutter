import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:abojude_flutter/features/message_screeen/message_screen.dart';
import 'report_screen.dart';
import 'package:abojude_flutter/features/message_screeen/message_screeen_list.dart';
import 'package:abojude_flutter/features/home/model/get_post_details_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int? postId;

  const ProductDetailsScreen({super.key, this.postId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool _isFavorite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.postId != null) {
      _fetchPostDetails(widget.postId!);
    }
  }

  Future<void> _fetchPostDetails(int id) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      await getPostDetailsRxObj.getPostDetailsRx(id);
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  // Contact launching helpers
  Future<void> _launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Future<void> _launchWhatsApp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final Uri uri = Uri.parse("https://wa.me/$cleanPhone");
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Inquiry from Wasel Canada'},
    );
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Listing Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.black54,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black54),
            onPressed: () {
              Share.share(
                'Check out this listing on Wasel Canada!',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.outlined_flag, color: Colors.black54),
            onPressed: () {
              Get.to(
                () => const ReportScreen(
                  targetName: 'Product Listing',
                  isReportUser: false,
                ),
              );
            },
          ),
        ],
      ),
      body: widget.postId != null
          ? StreamBuilder<GetPostDetailsModel>(
              stream: getPostDetailsRxObj.getPostDetailsData,
              builder: (context, snapshot) {
                if (_isLoading ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerDetails();
                }

                final details = snapshot.data?.data;
                return RefreshIndicator(
                  onRefresh: () => _fetchPostDetails(widget.postId!),
                  color: const Color(0xFF1B2D6B),
                  child: Stack(
                    children: [
                      ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 90),
                        children: [
                          _buildImageBanner(details),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPriceAndCategory(details),
                                const SizedBox(height: 12),
                                _buildTitleAndLocation(details),
                                const SizedBox(height: 16),
                                _buildDescription(details),
                                const SizedBox(height: 16),
                                _buildItemOverview(details),
                                const SizedBox(height: 16),
                                _buildSellerInfo(details),
                                const SizedBox(height: 16),
                                _buildContactInfo(details),
                                const SizedBox(height: 16),
                                _buildRelatedItems(details?.relatedPosts),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildBottomActionBar(details),
                    ],
                  ),
                );
              },
            )
          : Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(bottom: 90),
                  children: [
                    _buildImageBanner(null),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPriceAndCategory(null),
                          const SizedBox(height: 12),
                          _buildTitleAndLocation(null),
                          const SizedBox(height: 16),
                          _buildDescription(null),
                          const SizedBox(height: 16),
                          _buildItemOverview(null),
                          const SizedBox(height: 16),
                          _buildSellerInfo(null),
                          const SizedBox(height: 16),
                          _buildContactInfo(null),
                          const SizedBox(height: 16),
                          _buildRelatedItems(null),
                        ],
                      ),
                    ),
                  ],
                ),
                _buildBottomActionBar(null),
              ],
            ),
    );
  }

  Widget _buildShimmerDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 220,
                  height: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBanner(PostDetailsData? details) {
    List<String> imagesList = [];
    if (details?.images != null && details!.images!.isNotEmpty) {
      imagesList = details.images!
          .map((img) => _formatImageUrl(img) ?? img)
          .toList();
    } else if (details?.thumbnail != null && details!.thumbnail!.isNotEmpty) {
      final formatted = _formatImageUrl(details.thumbnail);
      if (formatted != null) imagesList = [formatted];
    }

    if (imagesList.isEmpty) {
      return Container(
        height: 220,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }

    final isFeatured = details?.isFeatured ?? false;

    return Stack(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1.0,
            autoPlay: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: imagesList.map((imageUrl) {
            return Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            );
          }).toList(),
        ),
        if (isFeatured)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.orange[700],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text(
                    'Featured Listing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (imagesList.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imagesList.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? const Color(0xFF10B981)
                        : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndCategory(PostDetailsData? details) {
    final category = details?.categoryName ?? 'Buy & Sell';
    String priceStr = details?.price ?? '\$1,199';
    if (!priceStr.startsWith('£') && !priceStr.startsWith('\$')) {
      priceStr = '£$priceStr';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          priceStr,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E40AF),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Color(0xFF1E40AF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndLocation(PostDetailsData? details) {
    final title = details?.title ?? 'Product Title';
    final location = (details?.city != null || details?.province != null)
        ? "${details?.city ?? ''}${details?.city != null && details?.province != null ? ', ' : ''}${details?.province ?? ''}"
        : 'Toronto, Manitoba';
    final timeAgo = details?.timeAgo ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              location,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (timeAgo.isNotEmpty) ...[
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                timeAgo,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(PostDetailsData? details) {
    final description = details?.description ??
        'No description available for this listing.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildItemOverview(PostDetailsData? details) {
    final specs = details?.specifications ?? {};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Item Overview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildOverviewRow(
            'Category',
            details?.categoryName ?? 'Buy & Sell',
          ),
          if (specs.isNotEmpty)
            ...specs.entries.map(
              (e) => _buildOverviewRow(e.key, e.value.toString()),
            )
          else ...[
            _buildOverviewRow('Condition', 'Like New / Excellent'),
            _buildOverviewRow('Location', '${details?.city ?? 'Toronto'}, ${details?.province ?? 'Manitoba'}'),
          ],
        ],
      ),
    );
  }

  Widget _buildOverviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo(PostDetailsData? details) {
    final name = details?.user?.name ?? 'Sara Khali';
    final avatar = _formatImageUrl(details?.user?.avatar);
    final location = (details?.city != null || details?.province != null)
        ? "${details?.city ?? ''}${details?.city != null && details?.province != null ? ', ' : ''}${details?.province ?? ''}"
        : 'Toronto, Ontario';

    final initials = name.trim().isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join().toUpperCase()
        : 'SK';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (avatar != null && avatar.isNotEmpty)
            CachedNetworkImage(
              imageUrl: avatar,
              imageBuilder: (context, provider) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: provider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFE5E7EB),
                  shape: BoxShape.circle,
                ),
              ),
              errorWidget: (context, url, err) => CircleAvatar(
                backgroundColor: const Color(0xFF1B2D6B),
                child: Text(
                  initials,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            )
          else
            CircleAvatar(
              backgroundColor: const Color(0xFF1B2D6B),
              child: Text(
                initials,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                location,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(PostDetailsData? details) {
    final phone = details?.phone ?? details?.user?.phone ?? '+1-416-555-1234';
    final whatsapp = details?.whatsapp ?? phone;
    final email = details?.email ?? details?.user?.email ?? 'contact@example.com';
    final location = (details?.city != null || details?.province != null)
        ? "${details?.city ?? ''}${details?.city != null && details?.province != null ? ', ' : ''}${details?.province ?? ''}"
        : 'Downtown Toronto, Ontario';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildContactTile(
            icon: Icons.call_outlined,
            iconColor: const Color(0xFF059669),
            bgColor: const Color(0xFFECFDF5),
            title: 'Phone',
            value: phone,
            onTap: () => _launchPhone(phone),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          _buildContactTile(
            icon: Icons.chat_bubble_outline_outlined,
            iconColor: const Color(0xFF10B981),
            bgColor: const Color(0xFFECFDF5),
            title: "What's app number",
            value: whatsapp,
            onTap: () => _launchWhatsApp(whatsapp),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          _buildContactTile(
            icon: Icons.mail_outline,
            iconColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFEFF6FF),
            title: 'Email',
            value: email,
            onTap: () => _launchEmail(email),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          _buildContactTile(
            icon: Icons.location_on_outlined,
            iconColor: const Color(0xFFEA580C),
            bgColor: const Color(0xFFFFF7ED),
            title: 'Address',
            value: location,
            onTap: () => _launchUrl('https://maps.google.com/?q=$location'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedItems(List<RelatedPost>? relatedPosts) {
    if (relatedPosts == null || relatedPosts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Related Listings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: relatedPosts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = relatedPosts[index];
              final formattedThumb = _formatImageUrl(item.thumbnail);

              return Container(
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: formattedThumb != null
                            ? CachedNetworkImage(
                                imageUrl: formattedThumb,
                                fit: BoxFit.cover,
                              )
                            : Container(color: Colors.grey[200]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.price != null ? '\$${item.price}' : '',
                            style: const TextStyle(
                              color: Color(0xFF1E40AF),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.title ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(PostDetailsData? details) {
    final name = details?.user?.name ?? 'Sara Khali';

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              Get.to(
                () => MessageScreen(
                  chat: ChatMessage(
                    id: details?.id?.toString() ?? '1',
                    name: name,
                    initials: name.trim().isNotEmpty
                        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join().toUpperCase()
                        : 'SK',
                    lastMessage: 'Inquiry regarding product listing',
                    time: 'Just now',
                    isOnline: true,
                    avatarUrl: _formatImageUrl(details?.user?.avatar),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            label: const Text(
              'Message Seller',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2D6B),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
