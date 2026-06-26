import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_step_header.dart';
import 'package:abojude_flutter/features/create_listing/services_create/widgets/service_button.dart';

class ServiceStep2InfoScreen extends StatefulWidget {
  final ServiceListingModel model;

  const ServiceStep2InfoScreen({super.key, required this.model});

  @override
  State<ServiceStep2InfoScreen> createState() => _ServiceStep2InfoScreenState();
}

class _ServiceStep2InfoScreenState extends State<ServiceStep2InfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _areaInputController;
  late final List<String> _serviceAreas;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.model.title);
    _descriptionController = TextEditingController(text: widget.model.description);
    _areaInputController = TextEditingController();
    _serviceAreas = List.from(widget.model.serviceAreas);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _areaInputController.dispose();
    super.dispose();
  }

  void _addArea() {
    final text = _areaInputController.text.trim();
    if (text.isEmpty) return;

    // Support comma-separated tags
    final List<String> newAreas = text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && !_serviceAreas.contains(e))
        .toList();

    if (newAreas.isNotEmpty) {
      setState(() {
        _serviceAreas.addAll(newAreas);
        _areaInputController.clear();
      });
    } else {
      _areaInputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ServiceStepHeader(currentStep: 2, title: "Service Info"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Title Field
                      _buildLabel("Service Title"),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("Enter service title"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a service title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Service Description Field
                      _buildLabel("Service Description"),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 3,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration(
                          "Describe your service, experience, and what clients can expect...",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please describe your service";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Service Areas Section
                      _buildLabel("Service Areas"),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _areaInputController,
                              textInputAction: TextInputAction.done,
                              style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                                color: AppColor.c2E3227,
                              ),
                              decoration: _buildInputDecoration("Enter your service areas"),
                              onFieldSubmitted: (_) => _addArea(),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: _addArea,
                            child: Container(
                              width: 52.h,
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1D3B71),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "List all cities and areas you serve, separated by commas.",
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Display areas chips
                      if (_serviceAreas.isNotEmpty)
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 10.h,
                          children: _serviceAreas.map((area) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: const Color(0xFFBFDBFE),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    Text(
                                      area,
                                      style: TextStyle(
                                        color: const Color(0xFF1D3B71),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _serviceAreas.remove(area);
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 14.w,
                                        color: const Color(0xFF1D3B71),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              // Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: ServiceButton(
                  text: "Continue",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (_serviceAreas.isEmpty) {
                        ToastUtil.showShortToast("Please add at least one service area.");
                        return;
                      }
                      widget.model.title = _titleController.text.trim();
                      widget.model.description = _descriptionController.text.trim();
                      widget.model.serviceAreas = _serviceAreas;

                      NavigationService.navigateTo(
                        Routes.serviceStep3Location,
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

  Widget _buildLabel(String labelText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          text: labelText,
          style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
            fontSize: 14.sp,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
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
