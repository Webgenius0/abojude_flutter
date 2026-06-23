import 'package:flutter/material.dart';




class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54, size: 20),
          onPressed: () {},
        ),
        title: const Text(
          'Listing Details',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 80), // To avoid overlap with bottom navigation
            children: [
              // 1. Image Banner Area
              Stack(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=600', // Placeholder for S24 Ultra
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50),
                    ),
                  ),
                  // Featured Listing Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green)),
                        const SizedBox(width: 4),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey)),
                        const SizedBox(width: 4),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey)),
                      ],
                    ),
                  )
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
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                        ),
                        Container(
                          padding:   EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Buy & Sell',
                            style: TextStyle(color: Color(0xFF1E40AF), fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    const Text(
                      'Samsung Galaxy S24 Ultra -\nExcellent Condition',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),

                    // Location & Time Info
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('Toronto, Manitoba', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('4 days ago', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Condition Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Condition: Like New',
                        style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Divider(height: 32),

                    // 3. Description Section
                    const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      'Selling my Samsung Galaxy S24 Ultra. Used for 3 months only. No scratches. Comes with original box and accessories. All features working perfectly. Titanium Black, 256GB.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4),
                    ),
                    const Divider(height: 32),

                    // 4. Seller Section
                    const Text('Seller', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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
                            child: const Text('SA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Sarah Ahmed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 2),
                              Text('Toronto, Ontario', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              Text('Member since 2023', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 32),

                    // 5. Contact Information Section
                    const Text('Contact Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _buildContactTile(Icons.phone_outlined, Colors.green, 'Phone', '+1-416-555-1234'),
                          const Divider(height: 1, indent: 50),
                          _buildContactTile(Icons.chat_bubble_outline, Colors.amber, 'WhatsApp number', '+1-416-555-1234'),
                          const Divider(height: 1, indent: 50),
                          _buildContactTile(Icons.mail_outline, Colors.blue, 'Email', 'ainour@example.com'),
                          const Divider(height: 1, indent: 50),
                          _buildContactTile(
                              Icons.location_on_outlined,
                              Colors.orange,
                              'Address',
                              '1450 Taylor Ave, Winnipeg, MB R3N 1Y6, Canada, Toronto, Manitoba, Scarborough, Ontario'
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 32),

                    // 6. Related Listings Section
                    const Text('Related Listings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 210,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildRelatedCard(),
                          const SizedBox(width: 12),
                          _buildRelatedCard(),
                        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                        label: const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF072A6C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildBottomIconButton(Icons.phone, Colors.green[50]!, Colors.green),
                    const SizedBox(width: 12),
                    _buildBottomIconButton(Icons.chat, Colors.amber[50]!, Colors.amber),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Contact Row Builder Helper
  Widget _buildContactTile(IconData icon, Color iconColor, String title, String subtitle) {
    return Padding(
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
                Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Related Product Card Builder Helper
  Widget _buildRelatedCard() {
    return SafeArea(
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(8),
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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?q=80&w=300',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, size: 14, color: Colors.grey[600]),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: Colors.black38,
                    child: const Text('5 days ago', style: TextStyle(color: Colors.white, fontSize: 8)),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('\$1,199', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E40AF), fontSize: 13)),
                  const SizedBox(height: 2),
                  const Text(
                    'Samsung Galaxy S24 Ultra Excelle...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:   EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(2)),
                    child: const Text('Buy & Sell', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 10, color: Colors.grey),
                      const SizedBox(width: 2),
                      Text('Toronto, Manitoba', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Circular Action Button Helper
  Widget _buildBottomIconButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: 20),
        onPressed: () {},
      ),
    );
  }
}