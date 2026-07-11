import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordVerifyOtpScreen extends StatefulWidget {
  final String email;
  const ForgetPasswordVerifyOtpScreen({super.key, required this.email});

  @override
  State<ForgetPasswordVerifyOtpScreen> createState() =>
      _ForgetPasswordVerifyOtpScreenState();
}

class _ForgetPasswordVerifyOtpScreenState
    extends State<ForgetPasswordVerifyOtpScreen> {
  final _otp1Controller = TextEditingController();
  final _otp2Controller = TextEditingController();
  final _otp3Controller = TextEditingController();
  final _otp4Controller = TextEditingController();

  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();

  bool _hasError = false;

  @override
  void dispose() {
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
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
                  'OTP Verification',
                  style: GoogleFonts.inter(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),

                SizedBox(height: 8.h),

                // --------------- Subtitle ---------------
                Text.rich(
                  TextSpan(
                    text:
                        'To ensure the safety and reliability of our community, please enter the 4-digit OTP sent to ',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF1B8E5A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // --------------- OTP Input Fields Row ---------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpBox(
                      controller: _otp1Controller,
                      focusNode: _focusNode1,
                      nextFocusNode: _focusNode2,
                    ),
                    _buildOtpBox(
                      controller: _otp2Controller,
                      focusNode: _focusNode2,
                      nextFocusNode: _focusNode3,
                      previousFocusNode: _focusNode1,
                    ),
                    _buildOtpBox(
                      controller: _otp3Controller,
                      focusNode: _focusNode3,
                      nextFocusNode: _focusNode4,
                      previousFocusNode: _focusNode2,
                    ),
                    _buildOtpBox(
                      controller: _otp4Controller,
                      focusNode: _focusNode4,
                      previousFocusNode: _focusNode3,
                    ),
                  ],
                ),

                SizedBox(height: 36.h),

                // --------------- Verify Button ---------------
                ValueListenableBuilder<bool>(
                  valueListenable: forgetPasswordVerifyOtpRxObj.isLoading,
                  builder: (context, isLoading, child) {
                    return GestureDetector(
                      onTap: isLoading
                          ? null
                          : () async {
                              final otp =
                                  _otp1Controller.text +
                                  _otp2Controller.text +
                                  _otp3Controller.text +
                                  _otp4Controller.text;
                              if (otp.length < 4) {
                                setState(() {
                                  _hasError = true;
                                });
                                ToastUtil.showShortToast(
                                  'Please enter the complete 4-digit OTP code',
                                );
                              } else {
                                setState(() {
                                  _hasError = false;
                                });
                                final success =
                                    await forgetPasswordVerifyOtpRxObj
                                        .forgetPasswordVerifyOtpRx(
                                          email: widget.email,
                                          otp: otp,
                                        );
                                if (success) {
                                  NavigationService.navigateTo(
                                    Routes.setNewPassword,
                                    arguments: {
                                      "email": widget.email,
                                      "otp": otp,
                                    },
                                  );
                                } else {
                                  setState(() {
                                    _hasError = true;
                                  });
                                }
                              }
                            },
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
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Verify',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 32.h),

                // --------------- Resend Code Footer ---------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: resendOtpRxObj.isLoading,
                      builder: (context, isLoading, child) {
                        return isLoading
                            ? SizedBox(
                                width: 14.w,
                                height: 14.w,
                                child: const CircularProgressIndicator(
                                  color: Color(0xFF1B8E5A),
                                  strokeWidth: 2,
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await resendOtpRxObj.resendOtpRx(
                                    email: widget.email,
                                    type: 'forgot-password',
                                  );
                                },
                                child: Text(
                                  'Resend',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF1B8E5A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    FocusNode? previousFocusNode,
  }) {
    final bool isNotEmpty = controller.text.isNotEmpty;

    return SizedBox(
      width: 58.w,
      height: 58.w,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.inter(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isNotEmpty
              ? const Color(0xFFEEF2F6)
              : const Color(0xFFF9FAFB),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: _hasError
                  ? Colors.red
                  : (isNotEmpty
                        ? const Color(0xFF03045E)
                        : const Color(0xFFE5E7EB)),
              width: isNotEmpty ? 1.2 : 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(
              color: _hasError ? Colors.red : const Color(0xFF1F2937),
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (_hasError) {
            setState(() {
              _hasError = false;
            });
          }
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          } else if (value.isEmpty && previousFocusNode != null) {
            previousFocusNode.requestFocus();
          }
        },
      ),
    );
  }
}
