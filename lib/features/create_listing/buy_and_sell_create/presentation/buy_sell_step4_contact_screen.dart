import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_step_header.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_button.dart';

class BuySellStep4ContactScreen extends StatefulWidget {
  final BuySellListingModel model;

  const BuySellStep4ContactScreen({super.key, required this.model});

  @override
  State<BuySellStep4ContactScreen> createState() => _BuySellStep4ContactScreenState();
}

class _BuySellStep4ContactScreenState extends State<BuySellStep4ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsAppController;
  late final TextEditingController _emailController;
  late bool _enableInAppChat;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.model.phoneNumber);
    _whatsAppController = TextEditingController(text: widget.model.whatsAppNumber);
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
      appBar: BuySellStepHeader(currentStep: 4, title: "Contact"),
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
                      Text(
                        "Choose how buyers can reach you. Enable at least one contact method.",
                        style: TextFontStyle.textStyle14IbmPlexSansW400,
                      ),
                      SizedBox(height: 24.h),

                      // Phone Number Field
                      _buildLabel("Phone Number"),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("+1 (416) 555-0123"),
                      ),
                      SizedBox(height: 20.h),

                      // WhatsApp Number Field
                      _buildLabel("What's App Number"),
                      TextFormField(
                        controller: _whatsAppController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("+1 (416) 555-0123"),
                      ),
                      SizedBox(height: 20.h),

                      // Email Field
                      _buildLabel("Email Address"),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("your@email.com"),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return "Please enter a valid email address";
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      // Enable in-App Chat Card
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFEFF4FC),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Enable in-App Chat",
                                    style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Allow buyers to message you in the app",
                                    style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoSwitch(
                              value: _enableInAppChat,
                              activeTrackColor: const Color(0xFF1D3B71),
                              onChanged: (bool value) {
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
                child: BuySellButton(
                  text: "Continue",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final phone = _phoneController.text.trim();
                      final whatsapp = _whatsAppController.text.trim();
                      final email = _emailController.text.trim();

                      if (phone.isEmpty && whatsapp.isEmpty && email.isEmpty && !_enableInAppChat) {
                        ToastUtil.showShortToast("Please provide or enable at least one contact method.");
                        return;
                      }

                      widget.model.phoneNumber = phone;
                      widget.model.whatsAppNumber = whatsapp;
                      widget.model.emailAddress = email;
                      widget.model.enableInAppChat = _enableInAppChat;

                      NavigationService.navigateTo(
                        Routes.buySellStep5Review,
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
      child: Text(
        labelText,
        style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
          fontSize: 14.sp,
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
