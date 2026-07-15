import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const LocationContinueButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFF03045E),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // --------------- Settings note ---------------
        Center(
          child: Text(
            'You can change your location anytime from Settings',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: const Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
