import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_step_header.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_button.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class BusinessStep5ContactScreen extends StatefulWidget {
  final BusinessListingModel model;

  const BusinessStep5ContactScreen({super.key, required this.model});

  @override
  State<BusinessStep5ContactScreen> createState() =>
      _BusinessStep5ContactScreenState();
}

class _BusinessStep5ContactScreenState
    extends State<BusinessStep5ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsAppController;
  late final TextEditingController _emailController;
  late bool _enableInAppChat;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.model.phoneNumber);
    _whatsAppController = TextEditingController(
      text: widget.model.whatsAppNumber,
    );
    _emailController = TextEditingController(text: widget.model.emailAddress);
    _enableInAppChat = widget.model.enableInAppChat;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _whatsAppController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BusinessStepHeader(
        currentStep: 5,
        title: "Contact Information".tr,
      ),
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
                      Text(
                        "Configure how customers can contact your business. Add at least one contact channel.".tr,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: const Color(0xFF6B7280)),
                      ),
                      SizedBox(height: 24.h),

                      // Phone Number Field
                      _buildLabel("Phone Number".tr),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration("+1 (555) 000-0000"),
                      ),
                      SizedBox(height: 20.h),

                      // WhatsApp Number Field
                      _buildLabel("WhatsApp Number".tr),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _whatsAppController,
                        keyboardType: TextInputType.phone,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration("+1 (555) 000-0000"),
                      ),
                      SizedBox(height: 20.h),

                      // Email Address Field
                      _buildLabel("Email Address".tr),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: _buildInputDecoration(
                          "info@yourbusiness.ca",
                        ),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final emailRegExp = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegExp.hasMatch(value.trim())) {
                              return "Please enter a valid email address".tr;
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      // In-app Chat configuration block
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Enable In-App Chat".tr,
                                    style: TextStyle(
                                      color: const Color(0xFF1F2937),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Allow users to send messages directly through the app.".tr,
                                    style: TextStyle(
                                      color: const Color(0xFF6B7280),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoSwitch(
                              value: _enableInAppChat,
                              activeTrackColor: const Color(0xFF1D3B71),
                              onChanged: (value) {
                                setState(() {
                                  _enableInAppChat = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: ValueListenableBuilder<bool>(
                  valueListenable: createBusinessRxObj.isLoading,
                  builder: (context, isLoading, child) {
                    return BusinessButton(
                      text: isLoading ? "Submitting...".tr : "Continue".tr,
                      onTap: isLoading
                          ? () {}
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final phone = _phoneController.text.trim();
                                final whatsapp = _whatsAppController.text.trim();
                                final email = _emailController.text.trim();

                                if (phone.isEmpty &&
                                    whatsapp.isEmpty &&
                                    email.isEmpty &&
                                    !_enableInAppChat) {
                                  ToastUtil.showShortToast(
                                    "Please configure at least one active contact channel.".tr,
                                  );
                                  return;
                                }

                                widget.model.phoneNumber = phone;
                                widget.model.whatsAppNumber = whatsapp;
                                widget.model.emailAddress = email;
                                widget.model.enableInAppChat = _enableInAppChat;

                                createBusinessRxObj
                                    .createBusiness(model: widget.model)
                                    .then((res) {
                                  ToastUtil.showShortToast(
                                    res.message ?? "Listing drafted successfully".tr,
                                  );
                                  NavigationService.navigateTo(
                                    Routes.businessStep6Review,
                                    arguments: widget.model,
                                  );
                                }).catchError((e) {
                                  ToastUtil.showShortToast(
                                    "Failed to draft listing.".tr,
                                  );
                                });
                              }
                            },
                    );
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
      child: Text(
        labelText.tr,
        style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
          fontSize: 14.sp,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint.tr,
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
