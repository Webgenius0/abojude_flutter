import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    setNewPasswordRxObj.clean();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 327.w,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --------------- Checkmark Icon ---------------
                    Container(
                      width: 90.w,
                      height: 90.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2F6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF03045E),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 36.w,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // --------------- Title ---------------
                    Text(
                      'Password Updated!',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // --------------- Subtitle ---------------
                    Text(
                      'Your password has been changed.\nYou’re all set to log in now.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // --------------- Login Now Button ---------------
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        NavigationService.navigateToUntilReplacement(
                          Routes.loginScreen,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF03045E),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(
                          child: Text(
                            'Login Now',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                    'New Password',
                    style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // --------------- Subtitle ---------------
                  Text(
                    'Create a new password to continue your journey with Wasel Canada',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: const Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // --------------- New Password Input Field ---------------
                  _buildInputField(
                    label: 'New Password',
                    hintText: 'Enter your new password',
                    prefixIconPath: 'assets/icons/password.svg',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 20.w,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // --------------- Confirm Password Input Field ---------------
                  _buildInputField(
                    label: 'Confirm Password',
                    hintText: 'Enter your confirm password',
                    prefixIconPath: 'assets/icons/password.svg',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 20.w,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please repeat your new password';
                      }
                      if (value != _passwordController.text) {
                        return 'The password field confirmation does not match.';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 28.h),

                  // --------------- Continue Button ---------------
                  ValueListenableBuilder<bool>(
                    valueListenable: setNewPasswordRxObj.isLoading,
                    builder: (context, isLoading, child) {
                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final args = ModalRoute.of(context)
                                      ?.settings
                                      .arguments as Map<String, dynamic>?;
                                  final email = args?['email'] ?? '';
                                  final token = args?['otp'] ?? '';

                                  final success = await setNewPasswordRxObj.setNewPassword(
                                    email: email,
                                    password: _passwordController.text,
                                    passwordConfirmation: _confirmPasswordController.text,
                                    token: token,
                                  );

                                  if (success) {
                                    _showSuccessDialog(context);
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
    bool obscureText = false,
    Widget? suffixIcon,
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
            obscureText: obscureText,
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
              suffixIcon: suffixIcon,
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
