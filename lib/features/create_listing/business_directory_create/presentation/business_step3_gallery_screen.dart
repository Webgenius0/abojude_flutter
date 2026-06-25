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

class BusinessStep3GalleryScreen extends StatefulWidget {
  final BusinessListingModel model;

  const BusinessStep3GalleryScreen({super.key, required this.model});

  @override
  State<BusinessStep3GalleryScreen> createState() =>
      _BusinessStep3GalleryScreenState();
}

class _BusinessStep3GalleryScreenState extends State<BusinessStep3GalleryScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickGalleryImage() async {
    if (widget.model.galleryImages.length >= 10) {
      ToastUtil.showShortToast("You can only add up to 10 photos.");
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.model.galleryImages.add(File(image.path));
      });
    }
  }

  void _removeGalleryImage(int index) {
    setState(() {
      widget.model.galleryImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.model.galleryImages;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BusinessStepHeader(currentStep: 3, title: "Business Gallery"),
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
                      "Showcase your business with additional photos. This step is optional.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Grid or single big box
                    images.isEmpty
                        ? GestureDetector(
                            onTap: _pickGalleryImage,
                            child: CustomPaint(
                              painter: DashedBorderPainter(
                                color: const Color(0xFFD1D5DB),
                                borderRadius: 12.r,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 180.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: const Color(0xFF1D3B71),
                                        size: 26.w,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      "Upload Business Photos",
                                      style: TextStyle(
                                        color: const Color(0xFF1F2937),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12.w,
                              mainAxisSpacing: 12.h,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: images.length + 1,
                            itemBuilder: (context, index) {
                              if (index == images.length) {
                                if (images.length >= 10) return const SizedBox.shrink();
                                return GestureDetector(
                                  onTap: _pickGalleryImage,
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
                                      child: Icon(
                                        Icons.add_a_photo_outlined,
                                        color: const Color(0xFF9CA3AF),
                                        size: 24.w,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final file = images[index];
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4.h,
                                    right: 4.w,
                                    child: GestureDetector(
                                      onTap: () => _removeGalleryImage(index),
                                      child: Container(
                                        padding: EdgeInsets.all(3.w),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                    SizedBox(height: 16.h),
                    Text(
                      "Add up to 10 photos (PNG, JPG, or WEBP), maximum 5MB per image.",
                      style: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Optional "You can skip this step" label & Continue button
            Column(
              children: [
                if (images.isEmpty) ...[
                  Text(
                    "You can skip this step",
                    style: TextStyle(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: BusinessButton(
                    text: "Continue",
                    onTap: () {
                      NavigationService.navigateTo(
                        Routes.businessStep4Location,
                        arguments: widget.model,
                      );
                    },
                  ),
                ),
              ],
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
