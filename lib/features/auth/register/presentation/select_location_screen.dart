import 'package:abojude_flutter/helpers/all_routes.dart';
import 'package:abojude_flutter/helpers/navigation_service.dart';
import 'package:abojude_flutter/helpers/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  String? _selectedProvince;
  String? _selectedCity;
  bool _showValidationError = false;

  final List<String> _provinces = [
    'Alberta',
    'British Columbia',
    'Manitoba',
    'New Brunswick',
    'Newfoundland and Labrador',
    'Nova Scotia',
    'Ontario',
    'Prince Edward Island',
    'Quebec',
    'Saskatchewan',
    'Northwest Territories',
    'Nunavut',
    'Yukon',
  ];

  final Map<String, List<String>> _citiesMap = {
    'Alberta': [
      'Calgary',
      'Edmonton',
      'Red Deer',
      'Lethbridge',
      'Medicine Hat',
      'Wood Buffalo',
    ],
    'British Columbia': [
      'Vancouver',
      'Surrey',
      'Burnaby',
      'Richmond',
      'Victoria',
      'Kelowna',
      'Coquitlam',
    ],
    'Manitoba': [
      'Winnipeg',
      'Brandon',
      'Steinbach',
      'Thompson',
      'Portage la Prairie',
    ],
    'New Brunswick': [
      'Moncton',
      'Saint John',
      'Fredericton',
      'Dieppe',
      'Miramichi',
    ],
    'Newfoundland and Labrador': [
      'St. John\'s',
      'Mount Pearl',
      'Corner Brook',
      'Conception Bay South',
    ],
    'Nova Scotia': ['Halifax', 'Sydney', 'Truro', 'New Glasgow', 'Glace Bay'],
    'Ontario': [
      'Toronto',
      'Ottawa',
      'Mississauga',
      'Brampton',
      'Hamilton',
      'London',
      'Markham',
      'Vaughan',
      'Kitchener',
      'Windsor',
    ],
    'Prince Edward Island': [
      'Charlottetown',
      'Summerside',
      'Stratford',
      'Cornwall',
    ],
    'Quebec': [
      'Montreal',
      'Quebec City',
      'Laval',
      'Gatineau',
      'Longueuil',
      'Sherbrooke',
      'Saguenay',
      'Levis',
    ],
    'Saskatchewan': [
      'Saskatoon',
      'Regina',
      'Prince Albert',
      'Moose Jaw',
      'Swift Current',
    ],
    'Northwest Territories': [
      'Yellowknife',
      'Inuvik',
      'Hay River',
      'Fort Smith',
    ],
    'Nunavut': ['Iqaluit', 'Rankin Inlet', 'Arviat', 'Baker Lake'],
    'Yukon': ['Whitehorse', 'Dawson City', 'Watson Lake'],
  };

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
                        SizedBox(height: 20.h),
                        // --------------- Centered Icon ---------------
                        Center(
                          child: Container(
                            width: 80.w,
                            height: 80.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEEF2F6),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/location.svg',
                                width: 36.w,
                                height: 36.w,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF03045E),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // --------------- Title ---------------
                        Center(
                          child: Text(
                            'Select Your Location',
                            style: GoogleFonts.inter(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // --------------- Subtitle ---------------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'Choose your province and city to personalize listings and recommendations.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: const Color(0xFF6B7280),
                              height: 1.4,
                            ),
                          ),
                        ),
                        SizedBox(height: 36.h),

                        // --------------- Province Field Label ---------------
                        Text(
                          'Province/Territory',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // --------------- Province Dropdown ---------------
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(canvasColor: Colors.white),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 4.h,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: provinceError
                                      ? Colors.red
                                      : const Color(0xFFE5E7EB),
                                  width: provinceError ? 1.5 : 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: provinceError
                                      ? Colors.red
                                      : const Color(0xFF03045E),
                                  width: 1.5,
                                ),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12.w),
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
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedProvince,
                                hint: Text(
                                  'Select province',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  color: const Color(0xFF1F2937),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: const Color(0xFF9CA3AF),
                                  size: 24.w,
                                ),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                items: _provinces.map((String province) {
                                  return DropdownMenuItem<String>(
                                    value: province,
                                    child: Text(
                                      province,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.sp,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedProvince = value;
                                    _selectedCity = null;
                                    _showValidationError = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // --------------- City Field Label ---------------
                        Text(
                          'City',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF374151),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        // --------------- City Dropdown ---------------
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(canvasColor: Colors.white),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 4.h,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: cityError
                                      ? Colors.red
                                      : const Color(0xFFE5E7EB),
                                  width: cityError ? 1.5 : 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(
                                  color: cityError
                                      ? Colors.red
                                      : const Color(0xFF03045E),
                                  width: 1.5,
                                ),
                              ),
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
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCity,
                                hint: Text(
                                  _selectedProvince == null
                                      ? 'Select province first'
                                      : 'Select city',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  color: const Color(0xFF1F2937),
                                ),
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: const Color(0xFF9CA3AF),
                                  size: 24.w,
                                ),
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                items: _selectedProvince == null
                                    ? null
                                    : _citiesMap[_selectedProvince]!.map((
                                        String city,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: Text(
                                            city,
                                            style: GoogleFonts.inter(
                                              fontSize: 15.sp,
                                              color: const Color(0xFF1F2937),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                onChanged: _selectedProvince == null
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedCity = value;
                                          _showValidationError = false;
                                        });
                                      },
                              ),
                            ),
                          ),
                        ),

                        // --------------- Selected Location Success Card ---------------
                        if (_selectedProvince != null &&
                            _selectedCity != null) ...[
                          SizedBox(height: 16.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF9F4),
                              border: Border.all(
                                color: const Color(0xFFC2ECD9),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD1F2E5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/location.svg',
                                      width: 18.w,
                                      height: 18.w,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF1B8E5A),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$_selectedCity, $_selectedProvince',
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF1B8E5A),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Your location has been selected',
                                        style: GoogleFonts.inter(
                                          fontSize: 13.sp,
                                          color: const Color(0xFF6B7280),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const Spacer(),
                        SizedBox(height: 40.h),

                        // --------------- Continue Button ---------------
                        GestureDetector(
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
                          child: Container(
                            width: double.infinity,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF03045E),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                'Continue',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // --------------- Settings note ---------------
                        Center(
                          child: Text(
                            'You can change your location anytime from Settings',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: const Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
