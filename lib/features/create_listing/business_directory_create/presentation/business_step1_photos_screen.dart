import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_step_header.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_button.dart';

class BusinessStep1PhotosScreen extends StatefulWidget {
  const BusinessStep1PhotosScreen({super.key});

  @override
  State<BusinessStep1PhotosScreen> createState() =>
      _BusinessStep1PhotosScreenState();
}

class _BusinessStep1PhotosScreenState extends State<BusinessStep1PhotosScreen> {
  final BusinessListingModel _model = BusinessListingModel();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickCoverImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _model.coverImage = File(image.path);
      });
    }
  }

  Future<void> _pickLogo() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _model.logo = File(image.path);
      });
    }
  }

  void _removeCoverImage() {
    setState(() {
      _model.coverImage = null;
    });
  }

  void _removeLogo() {
    setState(() {
      _model.logo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BusinessStepHeader(currentStep: 1, title: "Images"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload a cover image and your business logo.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF6B7280),
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Cover Image section
                    _buildLabel("Cover Image"),
                    SizedBox(height: 8.h),
                    _model.coverImage != null
                        ? Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  image: DecorationImage(
                                    image: FileImage(_model.coverImage!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: _removeCoverImage,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: _pickCoverImage,
                            child: CustomPaint(
                              painter: DashedBorderPainter(
                                color: const Color(0xFFD1D5DB),
                                borderRadius: 12.r,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: const Color(0xFF1D3B71),
                                        size: 24.w,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "Upload Cover Image",
                                      style: TextStyle(
                                        color: const Color(0xFF1F2937),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Recommended: 1200 × 400px",
                                      style: TextStyle(
                                        color: const Color(0xFF9CA3AF),
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 24.h),

                    // Business Logo section
                    _buildLabel("Business Logo"),
                    SizedBox(height: 8.h),
                    _model.logo != null
                        ? Stack(
                            children: [
                              Container(
                                width: 140.w,
                                height: 140.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                  image: DecorationImage(
                                    image: FileImage(_model.logo!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: _removeLogo,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: _pickLogo,
                            child: CustomPaint(
                              painter: DashedBorderPainter(
                                color: const Color(0xFFD1D5DB),
                                borderRadius: 12.r,
                              ),
                              child: Container(
                                width: 140.w,
                                height: 140.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(10.r),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: const Color(0xFF1D3B71),
                                        size: 24.w,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "Add Logo",
                                      style: TextStyle(
                                        color: const Color(0xFF1F2937),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 12.h),
                    Text(
                      "Square format recommended. Minimum 200 × 200px. PNG or JPG.",
                      style: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: BusinessButton(
                text: "Continue",
                onTap: () {
                  if (_model.coverImage == null) {
                    ToastUtil.showShortToast("Please upload a cover image.");
                    return;
                  }
                  if (_model.logo == null) {
                    ToastUtil.showShortToast("Please upload a business logo.");
                    return;
                  }
                  NavigationService.navigateTo(
                    Routes.businessStep2Info,
                    arguments: _model,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String labelText) {
    return RichText(
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
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final len = dashLength;
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + len),
          Offset.zero,
        );
        distance += len + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.borderRadius != borderRadius;
}
