import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutWaselCanadaScreen extends StatelessWidget {
  const AboutWaselCanadaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70.w,
          leading: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                  size: 26,
                ),
              ),
            ),
          ),
          title: Text(
            'About Wasel Canada',
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Logo Branding Header box
              _buildLogoBanner(),

              SizedBox(height: 12.h),
              // Version info
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // 2. Main Description paragraphs
              _buildBodyText(
                "Wasel Canada is a modern community marketplace designed to help Arabic-speaking communities across Canada connect, buy, sell, find jobs, discover local businesses, and access trusted services — all in one place.",
              ),
              SizedBox(height: 14.h),
              _buildBodyText(
                "Whether you're a newcomer, a long-time resident, a business owner, or a service provider, Wasel Canada makes it easier to connect with your local community and find what you need.",
              ),
              SizedBox(height: 24.h),

              // 3. Our Mission
              _buildSectionHeader('Our Mission'),
              _buildBodyText(
                "Our mission is to empower Arabic-speaking communities throughout Canada by providing a trusted, user-friendly platform that brings people, businesses, opportunities, and services together.\n\nWe aim to simplify everyday life by helping users discover local opportunities while supporting community growth and meaningful connections.",
              ),
              SizedBox(height: 24.h),

              // 4. What We Offer
              _buildSectionHeader('What We Offer'),
              _buildBulletItem('Buy & Sell', 'Find great deals on new and used items, or easily list products for sale within your local community.'),
              _buildBulletItem('Jobs', 'Explore employment opportunities from local businesses and employers across Canada.'),
              _buildBulletItem('Business Directory', 'Connect with trusted businesses, restaurants, shops, and professional services within your area.'),
              _buildBulletItem('Services', 'Find skilled service providers for home services, maintenance, cleaning, transportation, and more.'),
              SizedBox(height: 24.h),

              // 5. Who We Serve
              _buildSectionHeader('Who We Serve'),
              _buildBodyText("Wasel Canada is built for:"),
              SizedBox(height: 8.h),
              _buildSimpleBullet('Arabic-speaking individuals and families'),
              _buildSimpleBullet('New immigrants and newcomers to Canada'),
              _buildSimpleBullet('Job seekers and employers'),
              _buildSimpleBullet('Small business owners and entrepreneurs'),
              _buildSimpleBullet('Service providers and local professionals'),
              _buildSimpleBullet('Community members looking to connect and grow'),
              SizedBox(height: 8.h),
              _buildBodyText(
                "Our platform welcomes everyone while maintaining a strong focus on supporting Canada's diverse Arabic-speaking communities.",
              ),
              SizedBox(height: 24.h),

              // 6. Our Values
              _buildSectionHeader('Our Values'),
              _buildBulletItem('Trust', 'We promote a safe and reliable marketplace experience for all users.'),
              _buildBulletItem('Community', 'We believe strong communities are built through meaningful local connections.'),
              _buildBulletItem('Transparency', 'We encourage honest communication between buyers, sellers, businesses, and service providers.'),
              _buildBulletItem('Accessibility', 'We strive to make information, opportunities, and services easy to access for everyone.'),
              SizedBox(height: 24.h),

              // 7. Our Vision
              _buildSectionHeader('Our Vision'),
              _buildBodyText(
                "To become the leading community marketplace for Arabic-speaking communities across Canada, helping people connect with opportunities, businesses, services, and each other — all in one trusted platform.",
              ),

              SizedBox(height: 48.h),
              // Footer Quote
              Center(
                child: Text(
                  'Wasel Canada Everything You Need in One Place',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0F3D7A),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5EF), // light mint green background matching Image 4
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Logo symbol (Stylized W shape in green with red maple leaf)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Stylized Green Wave logo "W"
                  Icon(
                    Icons.waves_rounded,
                    color: const Color(0xFF2B8A3E),
                    size: 56.sp,
                  ),
                  // Red maple leaf or star representing Canada inside logo
                  Positioned(
                    bottom: 12.h,
                    child: Container(
                      width: 14.r,
                      height: 14.r,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(Icons.star, color: Colors.white, size: 8.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Arabic Brand text
          Text(
            'واصل كندا',
            style: GoogleFonts.cairo(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0C3C78),
              height: 1.1,
            ),
          ),
          SizedBox(height: 4.h),

          // English Brand text
          Text(
            'WASEL CANADA',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2B8A3E),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  Widget _buildBulletItem(String title, String desc) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5.h),
            width: 6.r,
            height: 6.r,
            decoration: const BoxDecoration(
              color: Color(0xFF2B8A3E),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 14.sp, color: Colors.grey[600], height: 1.5),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF0F3D7A),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
