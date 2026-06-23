import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_step_header.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/widgets/job_button.dart';

class JobStep2InfoScreen extends StatefulWidget {
  final JobListingModel model;

  const JobStep2InfoScreen({super.key, required this.model});

  @override
  State<JobStep2InfoScreen> createState() => _JobStep2InfoScreenState();
}

class _JobStep2InfoScreenState extends State<JobStep2InfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _companyController;
  late final TextEditingController _descriptionController;
  late String _selectedJobType;

  final List<String> _jobTypes = ["Full-Time", "Part-Time", "Contract", "Remote", "Temporary"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.model.title);
    _companyController = TextEditingController(text: widget.model.companyName);
    _descriptionController = TextEditingController(text: widget.model.description);
    _selectedJobType = widget.model.jobType.isNotEmpty ? widget.model.jobType : "Full-Time";
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const JobStepHeader(currentStep: 2, title: "Job Info"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Title Field
                      _buildLabel("Job Title"),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("Enter job title"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a job title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Company Name Field
                      _buildLabel("Company Name"),
                      TextFormField(
                        controller: _companyController,
                        textInputAction: TextInputAction.next,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("Enter company name"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a company name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Description Field
                      _buildLabel("Job Description"),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 3,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration(
                          "Describe the role, requirements, and responsibilities...",
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please describe the job role";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Job Type Section
                      _buildLabel("Job Type"),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 10.h,
                        children: _jobTypes.map((type) {
                          final isSelected = _selectedJobType == type;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedJobType = type;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF1D3B71) : const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF1D3B71) : const Color(0xFFE5E7EB),
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF4B5563),
                                  fontSize: 13.sp,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: JobButton(
                  text: "Continue",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.model.title = _titleController.text.trim();
                      widget.model.companyName = _companyController.text.trim();
                      widget.model.description = _descriptionController.text.trim();
                      widget.model.jobType = _selectedJobType;

                      NavigationService.navigateTo(
                        Routes.jobStep3Location,
                        arguments: widget.model,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String labelText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
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
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
        color: const Color(0xFF9CA3AF),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xFF1D3B71), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
