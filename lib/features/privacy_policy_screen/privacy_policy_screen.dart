import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Bottom border under the app bar matching the screenshot line
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade100,
            height: 1.0,
          ),
        ),
        leadingWidth: 72,
        leading: Padding(
          padding: const Size.fromHeight(kToolbarHeight) > const Size.fromHeight(0)
              ? const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0)
              : EdgeInsets.zero,
          child: Transform.scale(
            scale: 0.9,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: IconButton(
                icon:   Icon(Icons.arrow_back_ios_new, size: 10.sp, color: Colors.black87),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: November 2024',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: 'Information We Collect',
              content: 'We collect information you provide directly to us, such as when you create an account, post a listing, or contact us for support. This includes your name, email address, phone number, and location.',
            ),

            _buildSection(
              title: 'How We Use Your Information',
              content: 'We use the information we collect to provide, maintain, and improve our services, to process transactions, send notifications, and to communicate with you about products, services, and events.',
            ),

            _buildSection(
              title: 'Information Sharing',
              content: 'We do not share your personal information with third parties except as described in this policy. We may share information with service providers who assist us in operating our platform.',
            ),

            _buildSection(
              title: 'Data Security',
              content: 'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
            ),

            _buildSection(
              title: 'Your Rights',
              content: 'You have the right to access, update, or delete your personal information. You can do this through your account settings or by contacting our support team.',
            ),

            _buildSection(
              title: 'Location Data',
              content: 'We collect location information to provide location-based services such as showing listings near you. You can control location permissions through your device settings.',
            ),

            _buildSection(
              title: 'Contact Us',
              content: 'If you have questions about this Privacy Policy, please contact us at [app email address]',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}