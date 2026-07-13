import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    changePasswordRxObj.clean();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final success = await changePasswordRxObj.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70.w,
          leading: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF1F3F5),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.black87,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      // Title
                      Text(
                        'Change Password',
                        style: GoogleFonts.inter(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Description
                      Text(
                        'Protect your account by updating your password. Enter your current password and set a new one to keep your account safe.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Current Password
                      _buildLabel('Current Password'),
                      _buildPasswordField(
                        controller: _currentPasswordController,
                        hintText: 'Enter your current password',
                        obscureText: _obscureCurrent,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureCurrent = !_obscureCurrent;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The current password field is required.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // New Password
                      _buildLabel('New Password'),
                      _buildPasswordField(
                        controller: _newPasswordController,
                        hintText: 'Enter your new password',
                        obscureText: _obscureNew,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The new password field is required.';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Confirm Password
                      _buildLabel('Confirm Password'),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        hintText: 'Enter your confirm password',
                        obscureText: _obscureConfirm,
                        onToggleVisibility: () {
                          setState(() {
                            _obscureConfirm = !_obscureConfirm;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'The confirm password field is required.';
                          }
                          if (value != _newPasswordController.text) {
                            return 'The confirm password field must match new password.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Save Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ValueListenableBuilder<bool>(
                  valueListenable: changePasswordRxObj.isLoading,
                  builder: (context, isLoading, child) {
                    return ElevatedButton(
                      onPressed: isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3D7A),
                        disabledBackgroundColor: const Color(
                          0xFF0F3D7A,
                        ).withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
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
                              'Save Changes',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: Colors.grey[400],
          size: 20.sp,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.grey[400],
            size: 20.sp,
          ),
          onPressed: onToggleVisibility,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF0F3D7A)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
      ),
    );
  }
}
