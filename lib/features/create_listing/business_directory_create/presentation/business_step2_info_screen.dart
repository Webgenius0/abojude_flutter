import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_step_header.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_button.dart';

class BusinessStep2InfoScreen extends StatefulWidget {
  final BusinessListingModel model;

  const BusinessStep2InfoScreen({super.key, required this.model});

  @override
  State<BusinessStep2InfoScreen> createState() =>
      _BusinessStep2InfoScreenState();
}

class _BusinessStep2InfoScreenState extends State<BusinessStep2InfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model.businessName);
    _categoryController = TextEditingController(
      text: widget.model.businessCategory,
    );
    _descriptionController = TextEditingController(
      text: widget.model.description,
    );
    _websiteController = TextEditingController(text: widget.model.website);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _editDayHours(String day) async {
    // If the day is currently toggled off, we turn it on first when configuring
    if (!widget.model.businessHours[day]!.isOpen) {
      setState(() {
        widget.model.businessHours[day]!.isOpen = true;
      });
    }

    final result = await NavigationService.navigateTo(
      Routes.businessHoursSetter,
      arguments: {'dayName': day, 'hours': widget.model.businessHours[day]!},
    );

    if (result != null && result is BusinessDayHours) {
      setState(() {
        widget.model.businessHours[day] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BusinessStepHeader(currentStep: 2, title: "Business Info"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Business Name Field
                      _buildLabel("Business Name", isRequired: true),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _nameController,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration(
                          "Enter business name",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your business name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Business Category Field
                      _buildLabel("Business Category", isRequired: false),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _categoryController,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration(
                          "Enter business category",
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Description Field
                      _buildLabel("Description", isRequired: true),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 3,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration(
                          "Tell customers about your business, services, and what makes you unique...",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a description";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Website Field (Optional)
                      _buildLabel("Website (Optional)", isRequired: false),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _websiteController,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration(
                          "https://yourbusiness.ca",
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Business Hours Section
                      Text(
                        "Business Hours",
                        style: TextFontStyle.textStyle16IbmPlexSansW600
                            .copyWith(fontSize: 15.sp),
                      ),
                      SizedBox(height: 12.h),

                      // Business Hours List Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: days.length,
                          separatorBuilder: (context, index) => const Divider(
                            color: Color(0xFFE5E7EB),
                            height: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (context, index) {
                            final day = days[index];
                            final dayHours = widget.model.businessHours[day]!;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                children: [
                                  // Switch
                                  CupertinoSwitch(
                                    value: dayHours.isOpen,
                                    activeTrackColor: const Color(0xFF10B981),
                                    onChanged: (value) {
                                      setState(() {
                                        dayHours.isOpen = value;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 12.w),

                                  // Day Name (clickable to configure time)
                                  Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _editDayHours(day),
                                      child: Row(
                                        children: [
                                          Text(
                                            day,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF1F2937),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            dayHours.isOpen
                                                ? "${dayHours.openingTime} - ${dayHours.closingTime}"
                                                : "Closed",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: dayHours.isOpen
                                                  ? const Color(0xFF6B7280)
                                                  : const Color(0xFF9CA3AF),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          if (dayHours.isOpen)
                                            Icon(
                                              Icons.chevron_right_rounded,
                                              size: 16.w,
                                              color: const Color(0xFF9CA3AF),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Bottom Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: BusinessButton(
                  text: "Continue",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.model.businessName = _nameController.text.trim();
                      widget.model.businessCategory = _categoryController.text
                          .trim();
                      widget.model.description = _descriptionController.text
                          .trim();
                      widget.model.website = _websiteController.text.trim();

                      NavigationService.navigateTo(
                        Routes.businessStep3Gallery,
                        arguments: widget.model,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String labelText, {bool isRequired = true}) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
          fontSize: 14.sp,
        ),
        children: isRequired
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : null,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
        color: const Color(0xFF9CA3AF),
      ),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
