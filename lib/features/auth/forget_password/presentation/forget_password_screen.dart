import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            child: Form(
              key: _formKey,
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
                    'Forgot Password',
                    style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // --------------- Subtitle ---------------
                  Text(
                    'Enter your email to reset your password and get back to making change',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // --------------- Email Input Field ---------------
                  _buildInputField(
                    label: 'Email address',
                    hintText: 'your@email.com',
                    prefixIconPath: 'assets/icons/email.svg',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 28.h),

                  // --------------- Continue Button ---------------
                  ValueListenableBuilder<bool>(
                    valueListenable: forgetPasswordRxObj.isLoading,
                    builder: (context, isLoading, child) {
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await forgetPasswordRxObj.forgetPasswordRx(
                                    email: _emailController.text.trim(),
                                  );
                                  if (success) {
                                    NavigationService.navigateTo(
                                      Routes.forgetPasswordVerifyOtpScreen,
                                      arguments: _emailController.text.trim(),
                                    );
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
                                    'Continue',
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
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required String prefixIconPath,
    TextEditingController? controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
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
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              color: const Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 15.sp,
                color: const Color(0xFF9CA3AF),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: SvgPicture.asset(
                  prefixIconPath,
                  width: 15.w,
                  height: 15.w,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF9CA3AF),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: Color(0xFF03045E),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}