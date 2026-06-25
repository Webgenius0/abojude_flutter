import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuySellStepHeader extends StatelessWidget implements PreferredSizeWidget {
  final int currentStep;
  final String title;

  const BuySellStepHeader({
    super.key,
    required this.currentStep,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 20.w,
        right: 20.w,
        bottom: 12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button & Category Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: const Color(0xFF1F2937),
                        size: 20.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy & Sell',
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: const Color(0xFF797A7C),
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        title,
                        style: TextFontStyle.textStyle22IbmPlexSansW600.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Step counter badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '$currentStep of 5',
                  style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
                    fontSize: 14.sp,
                    color: const Color(0xFF1D3B71),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Stepper bar with 5 segments (representing 5 steps)
          Row(
            children: List.generate(5, (index) {
              final isActive = index < currentStep;
              return Expanded(
                child: Container(
                  height: 4.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF1D3B71) : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
