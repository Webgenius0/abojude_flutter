import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_step_header.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/widgets/buy_sell_button.dart';

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

  final Map<String, List<String>> _provinceToCities = {
    "Ontario": ["Toronto", "Ottawa", "Mississauga", "Hamilton", "London"],
    "Quebec": ["Montreal", "Quebec City", "Laval", "Gatineau", "Sherbrooke"],
    "British Columbia": [
      "Vancouver",
      "Victoria",
      "Surrey",
      "Burnaby",
      "Richmond",
    ],
    "Alberta": ["Calgary", "Edmonton", "Red Deer", "Lethbridge", "St. Albert"],
    "Manitoba": [
      "Winnipeg",
      "Brandon",
      "Steinbach",
      "Portage la Prairie",
      "Thompson",
    ],
    "Saskatchewan": [
      "Saskatoon",
      "Regina",
      "Prince Albert",
      "Moose Jaw",
      "Swift Current",
    ],
    "Nova Scotia": ["Halifax", "Sydney", "Dartmouth", "Truro", "New Glasgow"],
    "New Brunswick": [
      "Moncton",
      "Saint John",
      "Fredericton",
      "Dieppe",
      "Miramichi",
    ],
    "Newfoundland and Labrador": [
      "St. John's",
      "Mount Pearl",
      "Corner Brook",
      "Conception Bay South",
    ],
    "Prince Edward Island": [
      "Charlottetown",
      "Summerside",
      "Stratford",
      "Cornwall",
    ],
  };

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.model.address);
    if (widget.model.province.isNotEmpty &&
        _provinceToCities.containsKey(widget.model.province)) {
      _selectedProvince = widget.model.province;
      if (widget.model.city.isNotEmpty &&
          _provinceToCities[_selectedProvince]!.contains(widget.model.city)) {
        _selectedCity = widget.model.city;
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> provinces = _provinceToCities.keys.toList();
    final List<String> cities = _selectedProvince != null
        ? _provinceToCities[_selectedProvince]!
        : [];

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
                      DropdownButtonFormField<String>(
                        initialValue: _selectedProvince,
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
                              style: TextFontStyle.textStyle14IbmPlexSansW400
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
                        },
                      ),
                      SizedBox(height: 20.h),

                      // City Dropdown
                      _buildLabel("City"),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        dropdownColor: Colors.white,
                        disabledHint: Text(
                          "Select province first",
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
