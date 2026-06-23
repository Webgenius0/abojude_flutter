import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';

class BusinessPhotosGallery extends StatelessWidget {
  final List<File> galleryImages;

  const BusinessPhotosGallery({super.key, required this.galleryImages});

  @override
  Widget build(BuildContext context) {
    if (galleryImages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        const Divider(color: Color(0xFFE5E7EB)),
        SizedBox(height: 12.h),
        Text(
          "Photos Gallery",
          style: TextFontStyle.textStyle15IbmPlexSansW600,
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.0,
          ),
          itemCount: galleryImages.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                galleryImages[index],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ],
    );
  }
}
