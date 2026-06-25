import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessImageCarousel extends StatefulWidget {
  final List<dynamic> images;

  const BusinessImageCarousel({super.key, required this.images});

  @override
  State<BusinessImageCarousel> createState() => _BusinessImageCarouselState();
}

class _BusinessImageCarouselState extends State<BusinessImageCarousel> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCarouselImageWidget(dynamic img) {
    if (img is File) {
      return Image.file(img, fit: BoxFit.cover, width: double.infinity);
    } else if (img is String) {
      if (img.startsWith('http')) {
        return Image.network(img, fit: BoxFit.cover, width: double.infinity);
      } else {
        return Image.asset(img, fit: BoxFit.cover, width: double.infinity);
      }
    }
    return Container(color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 200.h,
        color: const Color(0xFFF3F4F6),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 48.w,
            color: const Color(0xFF9CA3AF),
          ),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 200.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return _buildCarouselImageWidget(widget.images[index]);
            },
          ),
        ),
        if (widget.images.length > 1)
          Positioned(
            bottom: 12.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) {
                  final isActive = index == _currentImageIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: isActive ? 12.w : 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF1B8E5A)
                          : const Color(0x99FFFFFF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
