import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String hintText;
  final List<String>? items;
  final ValueChanged<String?>? onChanged;
  final Widget prefixIcon;
  final bool hasError;

  const LocationDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
    required this.prefixIcon,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 6.h),
        Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.white),
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 4.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xFFE5E7EB),
                  width: hasError ? 1.5 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : const Color(0xFF03045E),
                  width: 1.5,
                ),
              ),
              prefixIcon: prefixIcon,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  hintText,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  color: const Color(0xFF1F2937),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: const Color(0xFF9CA3AF),
                  size: 24.w,
                ),
                isExpanded: true,
                dropdownColor: Colors.white,
                items: items?.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
