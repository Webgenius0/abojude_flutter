import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Bottom subtle border beneath the header
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade100,
            height: 1.0,
          ),
        ),
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: const Text(
          'Terms of Service',
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
              title: 'Acceptance of Terms',
              content: 'By accessing and using Wasel Canada, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.',
            ),

            _buildSection(
              title: 'User Accounts',
              content: 'You are responsible for maintaining the confidentiality of your account credentials. You agree to immediately notify us of any unauthorized use of your account.',
            ),

            _buildSection(
              title: 'Content Standards',
              content: 'All listings and content posted on Wasel Canada must be accurate, legal, and not misleading. We reserve the right to remove any content that violates our policies.',
            ),

            _buildSection(
              title: 'Prohibited Activities',
              content: 'Users may not use Wasel Canada for fraudulent activities, spam, harassment, or posting illegal items. Violations may result in immediate account suspension.',
            ),

            _buildSection(
              title: 'Marketplace Rules',
              content: 'Buyers and sellers are responsible for their transactions. Wasel Canada is a platform connecting users and is not responsible for the quality or legality of items listed.',
            ),

            _buildSection(
              title: 'Privacy',
              content: 'Your use of Wasel Canada is also governed by our Privacy Policy, which is incorporated into these terms by reference.',
            ),

            _buildSection(
              title: 'Limitation of Liability',
              content: 'Wasel Canada shall not be liable for any indirect, incidental, special, or consequential damages resulting from your use of our service.',
            ),

            _buildSection(
              title: 'Changes to Terms',
              content: 'We reserve the right to modify these terms at any time. Continued use of the platform after changes constitutes acceptance of the new terms.',
            ),

            _buildSection(
              title: 'Contact',
              content: 'For questions about these Terms, contact us at [appemail@gmail.com]',
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