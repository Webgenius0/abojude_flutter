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
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';
import 'package:abojude_flutter/constants/app_constants.dart';
import 'package:abojude_flutter/helpers/di.dart';

class SelectLocationScreen extends StatefulWidget {
  final bool isGuest;
  const SelectLocationScreen({super.key, this.isGuest = false});

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
                          builder: (context, provinceSnapshot) {
                            if (provinceSnapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !provinceSnapshot.hasData) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF03045E),
                                  ),
                                ),
                              );
                            }
                            if (provinceSnapshot.hasError) {
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

                            final provinceModel = provinceSnapshot.data;
                            if (provinceModel == null ||
                                provinceModel.data == null ||
                                provinceModel.data!.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF03045E),
                                  ),
                                ),
                              );
                            }

                            final List<String> provinceNames =
                                provinceModel.data!;

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
                                    if (value != null) {
                                      getCityRxObj.getCityRx(value);
                                    }
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
                                if (_selectedProvince == null)
                                  LocationDropdownField(
                                    label: 'City',
                                    value: null,
                                    hintText: 'Select province first',
                                    items: null,
                                    onChanged: null,
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
                                  )
                                else
                                  StreamBuilder<GetCityModel>(
                                    stream: getCityRxObj.getCityData,
                                    builder: (context, citySnapshot) {
                                      if (citySnapshot.connectionState ==
                                              ConnectionState.waiting &&
                                          !citySnapshot.hasData) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF03045E),
                                            ),
                                          ),
                                        );
                                      }
                                      if (citySnapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            'Failed to load cities',
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      }

                                      final cityModel = citySnapshot.data;
                                      final List<String> cityNames =
                                          cityModel?.data ?? [];

                                      return LocationDropdownField(
                                        label: 'City',
                                        value: _selectedCity,
                                        hintText: 'Select city',
                                        items: cityNames,
                                        onChanged: (value) {
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
                                      );
                                    },
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
                        ValueListenableBuilder<bool>(
                          valueListenable: widget.isGuest
                              ? selectLocationForGuestRxObj.isLoading
                              : selectLocationForAuthUserRxObj.isLoading,
                          builder: (context, isLoading, child) {
                            return LocationContinueButton(
                              isLoading: isLoading,
                              onTap: () async {
                                if (_selectedProvince == null ||
                                    _selectedCity == null) {
                                  setState(() {
                                    _showValidationError = true;
                                  });
                                  ToastUtil.showShortToast(
                                    'Please select both province and city',
                                  );
                                } else {
                                  bool success = false;
                                  if (widget.isGuest) {
                                    final String? guestToken = appData.read(kKeyAccessToken);
                                    if (guestToken == null || guestToken.isEmpty) {
                                      ToastUtil.showShortToast("Guest token is invalid or missing");
                                      return;
                                    }
                                    success = await selectLocationForGuestRxObj
                                        .selectLocationForGuestRx(
                                      guestToken: guestToken,
                                      province: _selectedProvince!,
                                      city: _selectedCity!,
                                    );
                                  } else {
                                    success = await selectLocationForAuthUserRxObj
                                        .selectLocationForAuthUserRx(
                                      province: _selectedProvince!,
                                      city: _selectedCity!,
                                    );
                                  }

                                  if (success) {
                                    appData.write(kKeyIsLoggedIn, true);
                                    appData.write(kKeySelectedLocation, true);
                                    NavigationService.navigateToUntilReplacement(
                                      Routes.navigationMenu,
                                    );
                                  }
                                }
                              },
                            );
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
