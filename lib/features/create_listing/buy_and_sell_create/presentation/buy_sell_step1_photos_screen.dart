import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_step_header.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_button.dart';

class BuySellStep1PhotosScreen extends StatefulWidget {
  const BuySellStep1PhotosScreen({super.key});

  @override
  State<BuySellStep1PhotosScreen> createState() => _BuySellStep1PhotosScreenState();
}

class _BuySellStep1PhotosScreenState extends State<BuySellStep1PhotosScreen> {
  final BuySellListingModel _model = BuySellListingModel();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (_model.images.length >= 5) {
      ToastUtil.showShortToast("You can only add up to 5 photos.");
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _model.images.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _model.images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BuySellStepHeader(currentStep: 1, title: "Photos"),
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
                      "Add up to 5 photos on your product. The first photo will be the main thumbnail.",
                      style: TextFontStyle.textStyle14IbmPlexSansW400,
                    ),
                    SizedBox(height: 24.h),
                    // Photo grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _model.images.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _model.images.length) {
                          // "Add Photo" button box
                          if (_model.images.length >= 5) {
                            return const SizedBox.shrink();
                          }
                          return GestureDetector(
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
                                      size: 28.w,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "Add Photo",
                                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // Display selected image
                        final file = _model.images[index];
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
                            // Badge indicating main/thumbnail for the 1st photo
                            if (index == 0)
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1D3B71),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    "Main",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            // Delete button
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close, color: Colors.red, size: 16.w),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "${_model.images.length} / 5 photos added",
                      style: TextFontStyle.textStyle14IbmPlexSansW400,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: BuySellButton(
                text: "Continue",
                onTap: () {
                  if (_model.images.isEmpty) {
                    ToastUtil.showShortToast("Please add at least one photo.");
                    return;
                  }
                  NavigationService.navigateTo(
                    Routes.buySellStep2Details,
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
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

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
