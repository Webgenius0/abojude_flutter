import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abojude_flutter/features/auth/register/widgets/location_header.dart';
import 'package:abojude_flutter/features/auth/register/widgets/location_dropdown.dart';
import 'package:abojude_flutter/features/auth/register/widgets/location_success_card.dart';
import 'package:abojude_flutter/features/auth/register/widgets/location_continue_button.dart';
import 'package:abojude_flutter/features/auth/register/widgets/location_data.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? _selectedProvince;
  String? _selectedCity;
  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    getProvinceRxObj.getProvinceRx();
  }

  @override
  Widget build(BuildContext context) {
    final bool provinceError =
        _showValidationError && _selectedProvince == null;
    final bool cityError = _showValidationError && _selectedCity == null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 32.h,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LocationHeader(),
                        SizedBox(height: 36.h),

                        StreamBuilder<GetProvinceModel>(
                          stream: getProvinceRxObj.getProvinceData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting &&
                                !snapshot.hasData) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF03045E),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Failed to load locations',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }

                            final model = snapshot.data;
                            if (model == null || model.data == null || model.data!.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF03045E),
                                  ),
                                ),
                              );
                            }

                            final List<String> provinceNames = model.data!;

                            final List<String>? cityNames = _selectedProvince == null
                                ? null
                                : citiesMap[_selectedProvince];

                            return Column(
                              children: [
                                // --------------- Province Dropdown ---------------
                                LocationDropdownField(
                                  label: 'Province/Territory',
                                  value: _selectedProvince,
                                  hintText: 'Select province',
                                  items: provinceNames,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProvince = value;
                                      _selectedCity = null;
                                      _showValidationError = false;
                                    });
                                  },
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: SvgPicture.asset(
                                      'assets/icons/map.svg',
                                      width: 20.w,
                                      height: 20.w,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF9CA3AF),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  hasError: provinceError,
                                ),
                                SizedBox(height: 20.h),

                                // --------------- City Dropdown ---------------
                                LocationDropdownField(
                                  label: 'City',
                                  value: _selectedCity,
                                  hintText: _selectedProvince == null
                                      ? 'Select province first'
                                      : 'Select city',
                                  items: cityNames,
                                  onChanged: _selectedProvince == null
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _selectedCity = value;
                                            _showValidationError = false;
                                          });
                                        },
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: SvgPicture.asset(
                                      'assets/icons/city.svg',
                                      width: 20.w,
                                      height: 20.w,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF9CA3AF),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  hasError: cityError,
                                ),
                              ],
                            );
                          },
                        ),

                        // --------------- Selected Location Success Card ---------------
                        if (_selectedProvince != null &&
                            _selectedCity != null) ...[
                          SizedBox(height: 16.h),
                          LocationSuccessCard(
                            province: _selectedProvince!,
                            city: _selectedCity!,
                          ),
                        ],

                        const Spacer(),
                        SizedBox(height: 40.h),

                        // --------------- Continue Button ---------------
                        LocationContinueButton(
                          onTap: () {
                            if (_selectedProvince == null ||
                                _selectedCity == null) {
                              setState(() {
                                _showValidationError = true;
                              });
                              ToastUtil.showShortToast(
                                'Please select both province and city',
                              );
                            } else {
                              ToastUtil.showShortToast(
                                'Location saved successfully!',
                              );
                              NavigationService.navigateToUntilReplacement(
                                Routes.navigationMenu,
                              );
                            }
                          },
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
