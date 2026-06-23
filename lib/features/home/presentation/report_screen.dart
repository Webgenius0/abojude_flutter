import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportScreen extends StatefulWidget {
  final String targetName;
  final bool isReportUser;

  const ReportScreen({
    Key? key,
    required this.targetName,
    this.isReportUser = false,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _selectedOption;
  final TextEditingController _otherTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Listing report options and descriptions
  final List<Map<String, String>> _listingOptions = [
    {
      'title': 'Spam or Misleading Listing',
      'description': 'This listing appears to be repetitive, misleading, irrelevant, or created primarily to attract attention without providing legitimate value.',
    },
    {
      'title': 'Fraud or Scam',
      'description': 'This listing may be attempting to deceive users, request money dishonestly, or promote fraudulent products, services, or opportunities.',
    },
    {
      'title': 'Wrong Category',
      'description': 'The listing is posted in an incorrect category, making it harder to find or violating category guidelines.',
    },
    {
      'title': 'Inappropriate or Offensive Content',
      'description': 'This listing contains offensive language, adult content, hate speech, violent material, or other content that violates community standards.',
    },
    {
      'title': 'Prohibited or Illegal Item',
      'description': 'The listing promotes restricted, prohibited, counterfeit, or illegal products, services, or activities.',
    },
    {
      'title': 'Duplicate Listing',
      'description': 'The same listing has been posted multiple times, creating unnecessary duplication within the platform.',
    },
    {
      'title': 'Other',
      'description': 'Please provide any additional information that may help us understand and review this report more effectively.',
    },
  ];

  // User report options and descriptions
  final List<Map<String, String>> _userOptions = [
    {
      'title': 'Spam or Misleading Behavior',
      'description': 'This user appears to be repetitive, misleading, or sending unsolicited/promotional messages without legitimate intent.',
    },
    {
      'title': 'Fraud or Scam',
      'description': 'This user may be attempting to deceive other users, request money dishonestly, or promote fraudulent activities.',
    },
    {
      'title': 'Inappropriate or Offensive Behavior',
      'description': 'This user sends messages containing offensive language, harassment, hate speech, or other content violating community standards.',
    },
    {
      'title': 'Prohibited or Illegal Activities',
      'description': 'This user promotes restricted, prohibited, counterfeit, or illegal products, services, or activities.',
    },
    {
      'title': 'Other',
      'description': 'Please provide any additional information that may help us understand and review this report more effectively.',
    },
  ];

  @override
  void dispose() {
    _otherTextController.dispose();
    super.dispose();
  }

  // Handle report submission with mock API loading delay
  void _submitReport() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a reason for reporting.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedOption == 'Other') {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    // Mock API request delay
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Report submitted successfully. Thank you!',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );

      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.isReportUser ? _userOptions : _listingOptions;
    final titleText = widget.isReportUser ? 'Report this user' : 'Report this listing';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70.w,
        leading: Center(
          child: GestureDetector(
            onTap: () => Get.back(),
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
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large Header Title
                      Text(
                        titleText,
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.isReportUser
                            ? 'Please select the reason for reporting user "${widget.targetName}":'
                            : 'Please select the reason for reporting listing "${widget.targetName}":',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Radio Option Cards List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final optionTitle = option['title']!;
                          final description = option['description']!;
                          final isSelected = _selectedOption == optionTitle;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedOption = optionTitle;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Custom styled radio circle to match mockup exactly
                                      Container(
                                        width: 22.r,
                                        height: 22.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF0F3D7A)
                                                : const Color(0xFFD1D5DB),
                                            width: isSelected ? 6.r : 2.r,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 14.w),
                                      Expanded(
                                        child: Text(
                                          optionTitle,
                                          style: GoogleFonts.inter(
                                            fontSize: 15.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? const Color(0xFF1F2937)
                                                : const Color(0xFF374151),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                child: isSelected
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          left: 36.w,
                                          bottom: 16.h,
                                          right: 8.w,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              description,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                color: const Color(0xFF6B7280),
                                                height: 1.4,
                                              ),
                                            ),
                                            if (optionTitle == 'Other') ...[
                                              SizedBox(height: 16.h),
                                              Text(
                                                'Tell us more',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF374151),
                                                ),
                                              ),
                                              SizedBox(height: 8.h),
                                              TextFormField(
                                                controller: _otherTextController,
                                                maxLines: 4,
                                                style: GoogleFonts.inter(
                                                  fontSize: 13.sp,
                                                  color: Colors.black87,
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'Enter details here...',
                                                  hintStyle: GoogleFonts.inter(
                                                    fontSize: 13.sp,
                                                    color: const Color(0xFF9CA3AF),
                                                  ),
                                                  contentPadding: EdgeInsets.symmetric(
                                                    horizontal: 14.w,
                                                    vertical: 12.h,
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.r),
                                                    borderSide: const BorderSide(
                                                      color: Color(0xFFE5E7EB),
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.r),
                                                    borderSide: const BorderSide(
                                                      color: Color(0xFFE5E7EB),
                                                    ),
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.r),
                                                    borderSide: const BorderSide(
                                                      color: Color(0xFF0F3D7A),
                                                    ),
                                                  ),
                                                  errorStyle: GoogleFonts.inter(
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null || value.trim().isEmpty) {
                                                    return 'Please enter some details';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              const Divider(height: 1, color: Color(0xFFF1F3F5)),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Fixed action buttons at the bottom
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Submit Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F3D7A),
                        minimumSize: Size(double.infinity, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isSubmitting ? null : _submitReport,
                      child: _isSubmitting
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Submit Report',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                    ),
                    SizedBox(height: 10.h),
                    // Cancel Button
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 44.h),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF4B5563),
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
