import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CreateListingOptionCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CreateListingOptionCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFF3F4F6),
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000), // black with 0.015 opacity (4/255)
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left icon container with soft background
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF1D3B71),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextFontStyle.textStyle16IbmPlexSansW600,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextFontStyle.textStyle14IbmPlexSansW400,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            // Trailing arrow icon in circular background
            Container(
              width: 32.w,
              height: 32.w,
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FA),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right,
                size: 18.w,
                color: const Color(0xFF1D3B71),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
