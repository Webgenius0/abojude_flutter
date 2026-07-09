import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------- Back Button ---------------
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Icon(
              Icons.chevron_left,
              color: const Color(0xFF1F2937),
              size: 24.w,
            ),
          ),
        ),

        SizedBox(height: 24.h),

        // --------------- Title ---------------
        Text(
          'Create Account',
          style: GoogleFonts.inter(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),

        SizedBox(height: 8.h),

        // --------------- Subtitle ---------------
        Text(
          'Join the community and start exploring local opportunities.',
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            color: const Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
