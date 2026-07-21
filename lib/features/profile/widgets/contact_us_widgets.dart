import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

class ContactAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ContactAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
              border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.black87,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class ContactHeaderSection extends StatelessWidget {
  const ContactHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Text(
          'Contact Support',
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Describe your issue clearly so our support team can assist you faster.',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey[500],
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class ContactFormTitle extends StatelessWidget {
  const ContactFormTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Support Request Form',
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class ContactFormSubtext extends StatelessWidget {
  final String text;
  const ContactFormSubtext({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, left: 4.w),
      child: Text(
        text,
        style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12.sp),
      ),
    );
  }
}

class ContactTipSubtext extends StatelessWidget {
  const ContactTipSubtext({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Tip: Include as much detail as possible about your issue. Screenshots, error messages, and step-by-step descriptions help our team resolve your issue faster.',
      style: GoogleFonts.inter(
        color: Colors.grey[400],
        fontSize: 12.sp,
        height: 1.4,
      ),
    );
  }
}

class ContactSubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const ContactSubmitButton({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: contactSupportRxObj.isLoading,
      builder: (context, isLoading, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Send Support Request',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class ContactResponseTimeCard extends StatelessWidget {
  const ContactResponseTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F3F5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: const Color(0xFF0F3D7A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              color: Color(0xFF0F3D7A),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email Support Response',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Our support team typically responds within 24-48 hours. You'll receive a response at your registered email address.",
                  style: GoogleFonts.inter(
                    fontSize: 12.5.sp,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactFormLabel extends StatelessWidget {
  final String text;
  const ContactFormLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
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
}

class ContactTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;

  const ContactTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 15.sp,
        color: readOnly ? Colors.grey[700] : Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20.sp),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF1F3F5) : const Color(0xFFF8F9FA),
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

class ContactMultiLineField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const ContactMultiLineField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.black87),
      decoration: InputDecoration(
        hintText:
            'Please describe your issue or question in detail. Include any relevant information that will help our support team assist you better...',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 14.sp,
          height: 1.4,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: EdgeInsets.all(16.r),
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

class ContactAttachmentArea extends StatelessWidget {
  final File? screenshotFile;
  final VoidCallback onPickScreenshot;
  final VoidCallback onRemoveScreenshot;

  const ContactAttachmentArea({
    super.key,
    required this.screenshotFile,
    required this.onPickScreenshot,
    required this.onRemoveScreenshot,
  });

  @override
  Widget build(BuildContext context) {
    if (screenshotFile != null) {
      return Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(11.r),
              child: Image.file(
                screenshotFile!,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4.h,
              right: 4.w,
              child: GestureDetector(
                onTap: onRemoveScreenshot,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 14.sp),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onPickScreenshot,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFFCED4DA),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              color: const Color(0xFF0F3D7A),
              size: 28.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Click to upload screenshot',
              style: GoogleFonts.inter(
                color: Colors.black87,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'PNG, JPG up to 10MB',
              style: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
