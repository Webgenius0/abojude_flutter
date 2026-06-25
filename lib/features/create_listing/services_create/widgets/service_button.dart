import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSubmit;

  const ServiceButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSubmit = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: isSubmit ? const Color(0xFF1B8E5A) : const Color(0xFF1D3B71),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextFontStyle.textStyle16InterW600.copyWith(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
