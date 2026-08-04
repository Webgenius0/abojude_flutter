import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:abojude_flutter/features/home/presentation/report_screen.dart';
import 'package:abojude_flutter/features/message_screeen/message_screen.dart';
import 'package:abojude_flutter/features/home/model/get_post_details_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import '../message_screeen/message_screeen_list.dart';

class JobScreen extends StatefulWidget {
  final int? postId;

  const JobScreen({super.key, this.postId});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  bool _isFavorited = false;
  int _currentImageIndex = 0;
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

    print('____________ProdudId________${widget.postId}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Listing Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? Colors.red : Colors.black54,
              size: 20.sp,
            ),
            onPressed: () => setState(() => _isFavorited = !_isFavorited),
          ),
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black54,
              size: 20,
            ),
            onPressed: () {
              Share.share(
                'Check out position: https://example.com',
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.outlined_flag,
              color: Colors.black54,
              size: 20,
            ),
            onPressed: () {
              Get.to(
                () => const ReportScreen(
                  targetName: 'Listing Position',
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
                      SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 90.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoverImage(details),
                            _buildHeaderDetails(details),
                            _buildDescription(details),
                            _buildJobSpecifications(details),
                            _buildSellerCard(details),
                            _buildContactInfo(details),
                            _buildRelatedListings(details?.relatedPosts),
                          ],
                        ),
                      ),
                      _buildBottomActionBar(details),
                    ],
                  ),
                );
              },
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 90.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCoverImage(null),
                      _buildHeaderDetails(null),
                      _buildDescription(null),
                      _buildJobSpecifications(null),
                      _buildSellerCard(null),
                      _buildContactInfo(null),
                      _buildRelatedListings(null),
                    ],
                  ),
                ),
                _buildBottomActionBar(null),
              ],
            ),
    );
  }

  Widget _buildShimmerDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: 220.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  width: 150.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage(PostDetailsData? details) {
    List<String> coverList = [];
    if (details?.images != null && details!.images!.isNotEmpty) {
      coverList = details.images!
          .map((img) => _formatImageUrl(img) ?? img)
          .toList();
    } else if (details?.thumbnail != null && details!.thumbnail!.isNotEmpty) {
      final formatted = _formatImageUrl(details.thumbnail);
      if (formatted != null) coverList = [formatted];
    }

    if (coverList.isEmpty) {
      return Container(
        height: 180.h,
        width: double.infinity,
        color: Colors.grey[200],
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 48.r,
            color: Colors.grey[400],
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 220.h,
          width: double.infinity,
          child: PageView.builder(
            itemCount: coverList.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imgUrl = coverList[index];
              return CachedNetworkImage(
                imageUrl: imgUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image, size: 48.r, color: Colors.grey[400]),
                ),
              );
            },
          ),
        ),
        // Indicators
        Positioned(
          bottom: 12.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(coverList.length, (index) {
              return Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.5),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderDetails(PostDetailsData? details) {
    final category = details?.categoryName ?? 'Jobs';
    final title = details?.title ?? 'Senior Flutter Developer';
    final location = (details?.city != null || details?.province != null)
        ? "${details?.city ?? ''}${details?.city != null && details?.province != null ? ', ' : ''}${details?.province ?? ''}"
        : 'Toronto, Manitoba';
    final timeAgo = details?.timeAgo ?? '12 hours ago';

    String? priceStr;
    if (details?.price != null && details!.price!.isNotEmpty) {
      priceStr = details.price!.startsWith('£') || details.price!.startsWith('\$')
          ? details.price!
          : '£${details.price}';
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD97706),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                location,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.access_time,
                size: 14.sp,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                timeAgo,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          if (priceStr != null) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                border: Border.all(color: const Color(0xFFA7F3D0)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 16.sp,
                    color: const Color(0xFF059669),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    priceStr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescription(PostDetailsData? details) {
    final description = details?.description ??
        'We are looking for a Senior Flutter Developer to join our team in building premium, high-performance mobile applications. The ideal candidate has experience with state management, custom animations, responsive UI layouts, and REST API integration.';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobSpecifications(PostDetailsData? details) {
    List<String> specs = ['Full-Time', 'Remote / Hybrid', '3+ Years Exp', 'Flutter & Dart'];
    if (details?.specifications != null && details!.specifications!.isNotEmpty) {
      specs = details.specifications!.entries
          .map((e) => "${e.key}: ${e.value}")
          .toList();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Specifications',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: specs.map((spec) => _buildSpecTag(spec)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecTag(String spec) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFDBEAFE)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14.sp,
            color: const Color(0xFF2563EB),
          ),
          SizedBox(width: 6.w),
          Text(
            spec,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E40AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerCard(PostDetailsData? details) {
    final name = details?.user?.name ?? 'Sarah Ahmed';
    final avatar = _formatImageUrl(details?.user?.avatar);
    final location = (details?.city != null || details?.province != null)
        ? "${details?.city ?? ''}${details?.city != null && details?.province != null ? ', ' : ''}${details?.province ?? ''}"
        : 'Toronto, Ontario';

    final initials = name.trim().isNotEmpty
        ? name.trim().split(RegExp(r'\s+')).take(2).map((e) => e[0]).join().toUpperCase()
        : 'SA';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recruiter',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                if (avatar != null && avatar.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: avatar,
                    imageBuilder: (context, provider) => Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: provider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                    ),
                    errorWidget: (context, url, err) => CircleAvatar(
                      radius: 20.r,
                      backgroundColor: const Color(0xFF1B2D6B),
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: const Color(0xFF1B2D6B),
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(PostDetailsData? details) {
    final phone = details?.phone ?? details?.user?.phone ?? '+1-416-555-1234';
    final whatsapp = details?.whatsapp ?? phone;
    final email = details?.email ?? details?.user?.email ?? 'recruiting@example.com';
    final location = (details?.city != null || details?.province != null)
        ? "${details?.city ?? ''}${details?.city != null && details?.province != null ? ', ' : ''}${details?.province ?? ''}"
        : 'Downtown Toronto, Ontario';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12.r),
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
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.sp,
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

  Widget _buildRelatedListings(List<RelatedPost>? relatedPosts) {
    if (relatedPosts == null || relatedPosts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Listings',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 220.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: relatedPosts.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final item = relatedPosts[index];
                final formattedThumb = _formatImageUrl(item.thumbnail);

                return Container(
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.r),
                        ),
                        child: SizedBox(
                          height: 100.h,
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
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              item.categoryName ?? '',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey[600],
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
      ),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
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
                        ? name
                        .trim()
                        .split(RegExp(r'\s+'))
                        .take(2)
                        .map((e) => e[0])
                        .join()
                        .toUpperCase()
                        : 'SK',
                    lastMessage: 'Inquiry regarding listing',
                    time: 'Just now',
                    isOnline: true,
                    avatarUrl: _formatImageUrl(details?.user?.avatar),
                  ),
                ),
              );
            },
            icon: Image.asset(
              'assets/icons/message-02.png',
              width: 20.w,
              height: 20.h,
              color: Colors.white, // Remove if your PNG already has the correct color
            ),
            label: Text(
              'Message',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B2D6B),
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
