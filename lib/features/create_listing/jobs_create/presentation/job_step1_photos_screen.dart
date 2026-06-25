import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_step_header.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_button.dart';

class JobStep1PhotosScreen extends StatefulWidget {
  const JobStep1PhotosScreen({super.key});

  @override
  State<JobStep1PhotosScreen> createState() => _JobStep1PhotosScreenState();
}

class _JobStep1PhotosScreenState extends State<JobStep1PhotosScreen> {
  final JobListingModel _model = JobListingModel();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _model.image = File(image.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _model.image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const JobStepHeader(currentStep: 1, title: "Job Photo Thumbnail"),
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
                      "Add a photo to your job posting. This photo will be the main thumbnail.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Photo selector box
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        child: _model.image == null
                            ? GestureDetector(
                                onTap: _pickImage,
                                child: CustomPaint(
                                  painter: DashedBorderPainter(
                                    color: const Color(0xFFD1D5DB),
                                    borderRadius: 12.r,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF9FAFB),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: const Color(0xFF9CA3AF),
                                          size: 32.w,
                                        ),
                                        SizedBox(height: 10.h),
                                        Text(
                                          "Add Photo",
                                          style: TextFontStyle
                                              .textStyle14IbmPlexSansW400
                                              .copyWith(
                                                color: const Color(0xFF9CA3AF),
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                        width: 1.5,
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(_model.image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Delete button
                                  Positioned(
                                    top: 12.h,
                                    right: 12.w,
                                    child: GestureDetector(
                                      onTap: _removeImage,
                                      child: Container(
                                        padding: EdgeInsets.all(6.w),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 18.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Upload Photo (PNG, JPG, or WEBP), maximum 5MB image.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: JobButton(
                text: "Continue",
                onTap: () {
                  if (_model.image == null) {
                    ToastUtil.showShortToast("Please add a photo.");
                    return;
                  }
                  NavigationService.navigateTo(
                    Routes.jobStep2Info,
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
