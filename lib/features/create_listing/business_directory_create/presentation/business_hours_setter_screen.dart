import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_button.dart';

class BusinessHoursSetterScreen extends StatefulWidget {
  final String dayName;
  final BusinessDayHours hours;

  const BusinessHoursSetterScreen({
    super.key,
    required this.dayName,
    required this.hours,
  });

  @override
  State<BusinessHoursSetterScreen> createState() => _BusinessHoursSetterScreenState();
}

class _BusinessHoursSetterScreenState extends State<BusinessHoursSetterScreen> {
  late String _openingTime;
  late String _closingTime;

  final List<String> _timesList = [
    "12:00 AM", "12:30 AM", "01:00 AM", "01:30 AM", "02:00 AM", "02:30 AM",
    "03:00 AM", "03:30 AM", "04:00 AM", "04:30 AM", "05:00 AM", "05:30 AM",
    "06:00 AM", "06:30 AM", "07:00 AM", "07:30 AM", "08:00 AM", "08:30 AM",
    "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM",
    "12:00 PM", "12:30 PM", "01:00 PM", "01:30 PM", "02:00 PM", "02:30 PM",
    "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM",
    "06:00 PM", "06:30 PM", "07:00 PM", "07:30 PM", "08:00 PM", "08:30 PM",
    "09:00 PM", "09:30 PM", "10:00 PM", "10:30 PM", "11:00 PM", "11:30 PM"
  ];

  @override
  void initState() {
    super.initState();
    // Fallback to defaults if values are not in the list
    _openingTime = _timesList.contains(widget.hours.openingTime)
        ? widget.hours.openingTime
        : "10:00 AM";
    _closingTime = _timesList.contains(widget.hours.closingTime)
        ? widget.hours.closingTime
        : "07:00 PM";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36.w,
                height: 36.w,
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
          ),
        ),
        title: Text(
          widget.dayName,
          style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
            fontSize: 18.sp,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Set your business hours here. Head to your calendar if you need to adjust hours for a single day.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Opening Hours dropdown
                    _buildLabel("Opening Hours"),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      initialValue: _openingTime,
                      dropdownColor: Colors.white,
                      decoration: _buildInputDecoration(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF9CA3AF),
                      ),
                      items: _timesList.map((String time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(
                            time,
                            style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                              color: AppColor.c2E3227,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _openingTime = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Closing Time dropdown
                    _buildLabel("Closing Time"),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      initialValue: _closingTime,
                      dropdownColor: Colors.white,
                      decoration: _buildInputDecoration(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF9CA3AF),
                      ),
                      items: _timesList.map((String time) {
                        return DropdownMenuItem<String>(
                          value: time,
                          child: Text(
                            time,
                            style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                              color: AppColor.c2E3227,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _closingTime = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: BusinessButton(
                text: "Save",
                onTap: () {
                  Navigator.pop(
                    context,
                    BusinessDayHours(
                      isOpen: true,
                      openingTime: _openingTime,
                      closingTime: _closingTime,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String labelText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        labelText,
        style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
          fontSize: 14.sp,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFF1D3B71), width: 1.5),
      ),
    );
  }
}
