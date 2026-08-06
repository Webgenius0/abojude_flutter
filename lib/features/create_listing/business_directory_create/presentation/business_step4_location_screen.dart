import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/assets_helper/app_colors.dart';
import 'package:abojude_flutter/assets_helper/app_fonts.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_listing_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_step_header.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/widgets/business_button.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';

class BusinessStep4LocationScreen extends StatefulWidget {
  final BusinessListingModel model;

  const BusinessStep4LocationScreen({super.key, required this.model});

  @override
  State<BusinessStep4LocationScreen> createState() =>
      _BusinessStep4LocationScreenState();
}

class _BusinessStep4LocationScreenState
    extends State<BusinessStep4LocationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;

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
    _cityController = TextEditingController(text: _selectedCity ?? "");

    getProvinceRxObj.getProvinceRx().then((_) {
      if (_selectedProvince != null) {
        getCityRxObj.getCityRx(_selectedProvince!);
      }
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BusinessStepHeader(currentStep: 4, title: "Location"),
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
                                _selectedCity = null;
                                _cityController.text = "";
                              });
                              if (value != null) {
                                getCityRxObj.getCityRx(value);
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20.h),

                      // City Selector
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

                          return GestureDetector(
                            onTap: _selectedProvince == null
                                ? null
                                : () {
                                    _showCitySearchBottomSheet(context, cities);
                                  },
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _cityController,
                                style: TextFontStyle.textStyle14IbmPlexSansW400
                                    .copyWith(color: AppColor.c2E3227),
                                decoration: _buildInputDecoration().copyWith(
                                  hintText: _selectedProvince == null
                                      ? "Select province first"
                                      : "Select city",
                                  hintStyle: TextFontStyle
                                      .textStyle14IbmPlexSansW400
                                      .copyWith(color: const Color(0xFF9CA3AF)),
                                  suffixIcon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                                validator: (value) {
                                  if (_selectedCity == null ||
                                      _selectedCity!.isEmpty) {
                                    return "Please select a city";
                                  }
                                  return null;
                                },
                              ),
                            ),
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
                child: BusinessButton(
                  text: "Continue",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.model.province = _selectedProvince!;
                      widget.model.city = _selectedCity!;
                      widget.model.address = _addressController.text.trim();

                      NavigationService.navigateTo(
                        Routes.businessStep5Contact,
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

  void _showCitySearchBottomSheet(BuildContext context, List<String> cities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return _CitySearchBottomSheet(
          cities: cities,
          initialSelectedCity: _selectedCity,
          onCitySelected: (city) {
            setState(() {
              _selectedCity = city;
              _cityController.text = city;
            });
          },
        );
      },
    );
  }
}

class _CitySearchBottomSheet extends StatefulWidget {
  final List<String> cities;
  final String? initialSelectedCity;
  final ValueChanged<String> onCitySelected;

  const _CitySearchBottomSheet({
    required this.cities,
    required this.initialSelectedCity,
    required this.onCitySelected,
  });

  @override
  State<_CitySearchBottomSheet> createState() => _CitySearchBottomSheetState();
}

class _CitySearchBottomSheetState extends State<_CitySearchBottomSheet> {
  late List<String> _filteredCities;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _filteredCities = widget.cities;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredCities = widget.cities;
      } else {
        _filteredCities = widget.cities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(
        top: 16.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Select City",
            style: TextFontStyle.textStyle16IbmPlexSansW600.copyWith(
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _searchController,
            onChanged: _filterCities,
            autofocus: true,
            style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
              color: AppColor.c2E3227,
            ),
            decoration: InputDecoration(
              hintText: "Search city...",
              hintStyle: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                color: const Color(0xFF9CA3AF),
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
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
          SizedBox(height: 16.h),
          Expanded(
            child: _filteredCities.isEmpty
                ? Center(
                    child: Text(
                      "No cities found",
                      style: TextFontStyle.textStyle14IbmPlexSansW400.copyWith(
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredCities.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Color(0xFFF3F4F6), height: 1),
                    itemBuilder: (context, index) {
                      final city = _filteredCities[index];
                      final isSelected = city == widget.initialSelectedCity;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          city,
                          style: TextFontStyle.textStyle14IbmPlexSansW400
                              .copyWith(
                                color: isSelected
                                    ? const Color(0xFF1D3B71)
                                    : AppColor.c2E3227,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Color(0xFF1D3B71))
                            : null,
                        onTap: () {
                          widget.onCitySelected(city);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
