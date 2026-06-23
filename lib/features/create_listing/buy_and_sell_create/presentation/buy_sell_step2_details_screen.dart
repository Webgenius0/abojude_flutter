import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_step_header.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_button.dart';

class BuySellStep2DetailsScreen extends StatefulWidget {
  final BuySellListingModel model;

  const BuySellStep2DetailsScreen({super.key, required this.model});

  @override
  State<BuySellStep2DetailsScreen> createState() => _BuySellStep2DetailsScreenState();
}

class _BuySellStep2DetailsScreenState extends State<BuySellStep2DetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late String _selectedCondition;

  final List<String> _conditions = ["New", "Like New", "Good", "Fair", "For Parts"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.model.title);
    _descriptionController = TextEditingController(text: widget.model.description);
    _priceController = TextEditingController(text: widget.model.price);
    _selectedCondition = widget.model.condition;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BuySellStepHeader(currentStep: 2, title: "Details"),
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
                      // Title Field
                      _buildLabel("Title"),
                      TextFormField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("Enter listing title"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a listing title";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Description Field
                      _buildLabel("Description"),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        minLines: 3,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("Describe your item in detail..."),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please describe your item";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Price Field
                      _buildLabel("Price"),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                          color: AppColor.c2E3227,
                        ),
                        decoration: _buildInputDecoration("e.g. \$500"),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a price";
                          }
                          // Remove dollar signs if entered
                          final cleanVal = value.replaceAll('\$', '');
                          if (double.tryParse(cleanVal) == null) {
                            return "Please enter a valid numeric price";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Condition Section
                      _buildLabel("Condition"),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 10.h,
                        children: _conditions.map((cond) {
                          final isSelected = _selectedCondition == cond;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCondition = cond;
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
                                cond,
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
                child: BuySellButton(
                  text: "Continue",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.model.title = _titleController.text.trim();
                      widget.model.description = _descriptionController.text.trim();
                      // Format price clean
                      var priceText = _priceController.text.trim();
                      if (!priceText.startsWith('\$')) {
                        priceText = '\$$priceText';
                      }
                      widget.model.price = priceText;
                      widget.model.condition = _selectedCondition;

                      NavigationService.navigateTo(
                        Routes.buySellStep3Location,
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
