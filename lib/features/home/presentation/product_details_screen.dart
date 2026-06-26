import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:abojude_flutter/features/message_screeen/message_screen.dart';
import 'report_screen.dart';
import 'package:abojude_flutter/features/message_screeen/message_screeen_list.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  bool _isFavorite = false;

  final List<String> _productImages = [
    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=600',
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?q=80&w=600',
    'https://images.unsplash.com/photo-1598327105666-5b89351aff97?q=80&w=600',
  ];

  final List<Map<String, dynamic>> _relatedItems = [
    {
      'price': '\$1,199',
      'title': 'Samsung Galaxy S24 Ultra Excelle...',
      'imageUrl':
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=300',
      'category': 'Buy & Sell',
      'location': 'Toronto, Manitoba',
      'isFavorite': false,
    },
    {
      'price': '\$950',
      'title': 'iPhone 15 Pro Max 256GB Gold',
      'imageUrl':
          'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?q=80&w=300',
      'category': 'Buy & Sell',
      'location': 'Vancouver, BC',
      'isFavorite': false,
    },
  ];

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
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Listing Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              try {
                Share.share(
                  'Check out this Samsung Galaxy S24 Ultra - Excellent Condition for \$1,199 on Wasel Canada!\nLink: https://waselcanada.com/listings/samsung-s24-ultra',
                  subject: 'Samsung Galaxy S24 Ultra - Wasel Canada',
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Share failed or app rebuild required: $e',
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.black54),
            onPressed: () {
              Get.to(
                () => const ReportScreen(
                  targetName: 'Samsung Galaxy S24 Ultra - Excellent Condition',
                  isReportUser: false,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              bottom: 80,
            ), // To avoid overlap with bottom navigation
            children: [
              // 1. Image Banner Area
              Stack(
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
                    items: _productImages.map((imageUrl) {
                      return Container(
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image, size: 50),
                        ),
                      );
                    }).toList(),
                  ),
                  // Featured Listing Badge
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
                      child: Row(
                        children: const [
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
                  // Image Dots Indicator
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _productImages.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Price and Category Tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '\$1,199',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Buy & Sell',
                            style: TextStyle(
                              color: Color(0xFF1E40AF),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    const Text(
                      'Samsung Galaxy S24 Ultra -\nExcellent Condition',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Location & Time Info
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Toronto, Manitoba',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4 days ago',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Condition Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Condition: Like New',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Divider(height: 32),

                    // 3. Description Section
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selling my Samsung Galaxy S24 Ultra. Used for 3 months only. No scratches. Comes with original box and accessories. All features working perfectly. Titanium Black, 256GB.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const Divider(height: 32),

                    // 4. Seller Section
                    const Text(
                      'Seller',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF0F3D7A),
                            child: const Text(
                              'SA',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sarah Ahmed',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Toronto, Ontario',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Member since 2023',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 32),

                    // 5. Contact Information Section
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildContactTile(
                            Icons.phone_outlined,
                            Colors.green,
                            'Phone',
                            '+1-416-555-1234',
                            onTap: () async {
                              try {
                                final Uri url = Uri.parse('tel:+14165551234');
                                await launchUrl(url);
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Could not open dialer: $e',
                                );
                              }
                            },
                          ),
                          const Divider(height: 1, indent: 50),
                          _buildContactTile(
                            Icons.chat_bubble_outline,
                            Colors.amber,
                            'WhatsApp number',
                            '+1-416-555-1234',
                            onTap: () async {
                              try {
                                final Uri url = Uri.parse(
                                  'https://wa.me/14165551234',
                                );
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Could not open WhatsApp: $e',
                                );
                              }
                            },
                          ),
                          const Divider(height: 1, indent: 50),
                          _buildContactTile(
                            Icons.mail_outline,
                            Colors.blue,
                            'Email',
                            'ainour@example.com',
                            onTap: () async {
                              try {
                                final Uri url = Uri.parse(
                                  'mailto:ainour@example.com?subject=Inquiry%20about%20S24%20Ultra',
                                );
                                await launchUrl(url);
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Could not open email client: $e',
                                );
                              }
                            },
                          ),
                          const Divider(height: 1, indent: 50),
                          _buildContactTile(
                            Icons.location_on_outlined,
                            Colors.orange,
                            'Address',
                            '1450 Taylor Ave, Winnipeg, MB R3N 1Y6, Canada, Toronto, Manitoba, Scarborough, Ontario',
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 32),

                    // 6. Related Listings Section
                    const Text(
                      'Related Listings',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SafeArea(
                      child: SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _relatedItems.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return _buildRelatedCard(_relatedItems[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 7. Sticky Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(
                            () => MessageScreen(
                              chat: ChatMessage(
                                id: 'sarah_ahmed',
                                name: 'Sarah Ahmed',
                                initials: 'SA',
                                lastMessage:
                                    'Hi, is the Samsung Galaxy S24 Ultra still available?',
                                time: 'Just now',
                                isOnline: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF072A6C),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/message-02.png',
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Send Message',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildBottomIconButton(
                      'assets/icons/phone.png', // ← Your image path
                      Colors.green[50]!,
                      Colors.green,
                      onPressed: () async {
                        try {
                          final Uri url = Uri.parse('tel:+14165551234');
                          await launchUrl(url);
                        } catch (e) {
                          Get.snackbar(
                            'Error',
                            'Could not open phone dialer: $e',
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildBottomIconButton(
                      'assets/icons/whatsapp.png', // ← Change to your actual image path
                      Colors.green.shade50,
                      Colors.green,
                      onPressed: () async {
                        try {
                          final Uri url = Uri.parse(
                            'https://wa.me/14165551200',
                          );
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } catch (e) {
                          Get.snackbar('Error', 'Could not open WhatsApp: $e');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Contact Row Builder Helper
  Widget _buildContactTile(
    IconData icon,
    Color iconColor,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: iconColor.withOpacity(0.1),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  // Related Product Card Builder Helper
  Widget _buildRelatedCard(Map<String, dynamic> item) {
    final bool isFav = item['isFavorite'] as bool? ?? false;
    return Container(
      width: 160,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Image.network(
                  item['imageUrl'] as String,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      item['isFavorite'] = !isFav;
                    });
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 14,
                      color: isFav ? Colors.red : Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  color: Colors.black38,
                  child: const Text(
                    '5 days ago',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['price'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['title'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      item['category'] as String,
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 10,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item['location'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Circular Action Button Helper
  Widget _buildBottomIconButton(
    String iconPath, // Changed to image path
    Color bgColor,
    Color iconColor, { // Will be used as tint color for the image
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            height: 24,
            width: 24,
            color: iconColor, // Tint the image
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.phone, // Fallback
              color: iconColor,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
