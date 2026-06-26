import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';

class BusinessSellerCard extends StatelessWidget {
  final String name;
  final String location;
  final String memberSince;
  final String initials;

  const BusinessSellerCard({
    super.key,
    required this.name,
    required this.location,
    required this.memberSince,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Seller",
          style: TextFontStyle.textStyle15IbmPlexSansW600,
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: const Color(0xFF1D3B71),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextFontStyle.textStyle14IbmPlexSansW600,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    location,
                    style: TextFontStyle.textStyle12IbmPlexSansW400Grey,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    memberSince,
                    style: TextFontStyle.textStyle12IbmPlexSansW400Grey
                        .copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
