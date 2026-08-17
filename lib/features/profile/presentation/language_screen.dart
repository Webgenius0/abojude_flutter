import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../helpers/di.dart';
import '../../../constants/app_constants.dart';
import '../../../networks/dio/dio.dart';
import '../../../networks/api_acess.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguageCode = 'en';

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode = appData.read(kKeyLanguage) ?? 'en';
  }

  void _saveChanges() async {
    final bool success = await setLanguageRxObj.setLanguageRx(
      locale: _selectedLanguageCode,
    );

    if (success) {
      await appData.write(kKeyLanguage, _selectedLanguageCode);
      Get.updateLocale(Locale(_selectedLanguageCode));
      DioSingleton.instance.updateLanguage(_selectedLanguageCode);
      Navigator.pop(context);
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    // Title
                    Text(
                      'Language Settings'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Description
                    Text(
                      'Choose the language used throughout the application.'.tr,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // English Option Card
                    _buildLanguageCard(
                      langCode: 'en',
                      title: 'English'.tr,
                      subtitle: 'English'.tr,
                    ),
                    SizedBox(height: 16.h),

                    // Arabic Option Card
                    _buildLanguageCard(
                      langCode: 'ar',
                      title: 'Arabic'.tr,
                      subtitle: 'العربية',
                    ),

                    SizedBox(height: 32.h),
                    // Footnote
                    Center(
                      child: Text(
                        'Language changes will update the app interface instantly.'
                            .tr,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
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
                  valueListenable: setLanguageRxObj.isLoading,
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
                              'Save Changes'.tr,
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

  Widget _buildLanguageCard({
    required String langCode,
    required String title,
    required String subtitle,
  }) {
    final bool isSelected = _selectedLanguageCode == langCode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguageCode = langCode;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F3D7A)
                : const Color(0xFFF1F3F5),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0F3D7A).withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Globe Icon in a container
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0F3D7A).withOpacity(0.08)
                    : const Color(0xFFF1F3F5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.language_rounded,
                color: isSelected ? const Color(0xFF0F3D7A) : Colors.grey[400],
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Language Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFF0F3D7A)
                          : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Checkmark or None
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF0F3D7A),
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }
}
