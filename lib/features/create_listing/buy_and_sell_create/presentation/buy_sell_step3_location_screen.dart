import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_step_header.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_button.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';

class BuySellStep3LocationScreen extends StatefulWidget {
  final BuySellListingModel model;

  const BuySellStep3LocationScreen({super.key, required this.model});

  @override
  State<BuySellStep3LocationScreen> createState() =>
      _BuySellStep3LocationScreenState();
}

class _BuySellStep3LocationScreenState
    extends State<BuySellStep3LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;

  String? _selectedProvince;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.model.address);
    _selectedProvince = widget.model.province.isNotEmpty
        ? widget.model.province
        : null;
    _selectedCity = widget.model.city.isNotEmpty ? widget.model.city : null;

    getProvinceRxObj.getProvinceRx().then((_) {
      if (_selectedProvince != null) {
        getCityRxObj.getCityRx(_selectedProvince!);
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BuySellStepHeader(currentStep: 3, title: "Location"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Province/Territory Dropdown
                      _buildLabel("Province/Territory"),
                      StreamBuilder<GetProvinceModel>(
                        stream: getProvinceRxObj.getProvinceData,
                        builder: (context, provinceSnapshot) {
                          final List<String> provinces =
                              provinceSnapshot.hasData &&
                                  provinceSnapshot.data!.data != null
                              ? provinceSnapshot.data!.data!
                              : [];

                          return DropdownButtonFormField<String>(
                            value: _selectedProvince,
                            dropdownColor: Colors.white,
                            hint: Text(
                              "Select province",
                              style: TextFontStyle.textStyle14IbmPlexSansW400
                                  .copyWith(color: const Color(0xFF9CA3AF)),
                            ),
                            decoration: _buildInputDecoration(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF9CA3AF),
                            ),
                            items: provinces.map((String prov) {
                              return DropdownMenuItem<String>(
                                value: prov,
                                child: Text(
                                  prov,
                                  style: TextFontStyle
                                      .textStyle14IbmPlexSansW400
                                      .copyWith(color: AppColor.c2E3227),
                                ),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return "Please select a province";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _selectedProvince = value;
                                _selectedCity =
                                    null; // reset city when province changes
                              });
                              if (value != null) {
                                getCityRxObj.getCityRx(value);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      // City Dropdown
                      _buildLabel("City"),
                      StreamBuilder<GetCityModel>(
                        stream: getCityRxObj.getCityData,
                        builder: (context, citySnapshot) {
                          final List<String> cities =
                              _selectedProvince != null &&
                                  citySnapshot.hasData &&
                                  citySnapshot.data!.data != null
                              ? citySnapshot.data!.data!
                              : [];

                          return DropdownButtonFormField<String>(
                            value: _selectedCity,
                            dropdownColor: Colors.white,
                            disabledHint: Text(
                              _selectedProvince == null
                                  ? "Select province first"
                                  : "Loading cities...",
                              style: TextFontStyle.textStyle14IbmPlexSansW400
                                  .copyWith(color: const Color(0xFF9CA3AF)),
                            ),
                            hint: Text(
                              "Select city",
                              style: TextFontStyle.textStyle14IbmPlexSansW400
                                  .copyWith(color: const Color(0xFF9CA3AF)),
                            ),
                            decoration: _buildInputDecoration(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF9CA3AF),
                            ),
                            items: _selectedProvince == null
                                ? null
                                : cities.map((String cty) {
                                    return DropdownMenuItem<String>(
                                      value: cty,
                                      child: Text(
                                        cty,
                                        style: TextFontStyle
                                            .textStyle14IbmPlexSansW400
                                            .copyWith(color: AppColor.c2E3227),
                                      ),
                                    );
                                  }).toList(),
                            validator: (value) {
                              if (value == null) {
                                return "Please select a city";
                              }
                              return null;
                            },
                            onChanged: _selectedProvince == null
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedCity = value;
                                    });
                                  },
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Address Field (Optional)
                      _buildLabel("Address (Optional)", isRequired: false),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 4,
                        minLines: 3,
                        style: TextFontStyle.textStyle14IbmPlexSansW400
                            .copyWith(color: AppColor.c2E3227),
                        decoration: InputDecoration(
                          hintText: "Street address or neighbourhood",
                          hintStyle: TextFontStyle.textStyle14IbmPlexSansW400
                              .copyWith(color: const Color(0xFF9CA3AF)),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF1D3B71),
                              width: 1.5,
                            ),
                          ),
                        ),
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
                      widget.model.province = _selectedProvince!;
                      widget.model.city = _selectedCity!;
                      widget.model.address = _addressController.text.trim();

                      NavigationService.navigateTo(
                        Routes.buySellStep4Contact,
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

  Widget _buildLabel(String labelText, {bool isRequired = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          text: labelText,
          style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
            fontSize: 14.sp,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      filled: true,
      fillColor: Colors.white,
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
