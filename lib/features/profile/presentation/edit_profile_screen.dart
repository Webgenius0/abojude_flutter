import 'dart:io';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/features/auth/register/widgets/location_dropdown.dart';
import 'package:abojude_flutter/features/profile/model/get_profile_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  /// Pass the current profile data so we can pre-fill all fields.
  final Data? profileData;

  const EditProfileScreen({super.key, this.profileData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Province / City dropdown state
  String? _selectedProvince;
  String? _selectedCity;
  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();

    final data = widget.profileData;

    // Pre-fill name
    _nameController = TextEditingController(text: data?.name ?? '');

    // Pre-fill province & city selections
    _selectedProvince = (data?.province?.isNotEmpty == true)
        ? data!.province
        : null;
    _selectedCity = (data?.city?.isNotEmpty == true) ? data!.city : null;

    // Fetch province list
    getProvinceRxObj.getProvinceRx();

    // If there is a pre-selected province, also load cities for it
    if (_selectedProvince != null) {
      getCityRxObj.getCityRx(_selectedProvince!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // Pick profile picture
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _saveChanges() async {
    if (_selectedProvince == null || _selectedCity == null) {
      setState(() => _showValidationError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both province and city'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final success = await editProfileRxObj.editProfileRx(
        name: _nameController.text.trim(),
        province: _selectedProvince,
        city: _selectedCity,
        avatar: _imageFile,
      );

      if (!mounted) return;

      if (success) {
        await getProfileRxObj.getProfile();
        if (!mounted) return;
        Navigator.pop(context);
      }
    }
  }

  /// Returns the avatar initials from the user's name.
  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bool provinceError =
        _showValidationError && _selectedProvince == null;
    final bool cityError = _showValidationError && _selectedCity == null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 70.w,
          leading: Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF1F3F5),
                    width: 1.5,
                  ),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                // Title
                Text(
                  'Edit Profile',
                  style: GoogleFonts.inter(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                // Description
                Text(
                  'Keep your profile up to date by modifying your information.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 32.h),

                // --------------- Avatar Picker ---------------
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 54.r,
                          backgroundColor: const Color(0xFFE9ECEF),
                          // Priority: local picked image > network avatar URL > initials
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!) as ImageProvider
                              : (widget.profileData?.avatar != null &&
                                    widget.profileData!.avatar!.isNotEmpty)
                              ? NetworkImage(widget.profileData!.avatar!)
                                    as ImageProvider
                              : null,
                          child:
                              (_imageFile == null &&
                                  (widget.profileData?.avatar == null ||
                                      widget.profileData!.avatar!.isEmpty))
                              ? Text(
                                  _getInitials(widget.profileData?.name),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF0F3D7A),
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4.w,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F3D7A),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 36.h),

                // --------------- Full Name ---------------
                _buildLabel('Full Name'),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Enter your full name',
                  icon: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: SvgPicture.asset(
                      'assets/icons/person.svg',
                      width: 20.w,
                      height: 20.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF9CA3AF),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),

                // --------------- Province Dropdown (API-driven) ---------------
                StreamBuilder<GetProvinceModel>(
                  stream: getProvinceRxObj.getProvinceData,
                  builder: (context, provinceSnapshot) {
                    // Loading state
                    if (provinceSnapshot.connectionState ==
                            ConnectionState.waiting &&
                        !provinceSnapshot.hasData) {
                      return _buildLoadingDropdown('Province/Territory');
                    }

                    // Error state
                    if (provinceSnapshot.hasError &&
                        !provinceSnapshot.hasData) {
                      return _buildErrorDropdown('Province/Territory');
                    }

                    final provinceModel = provinceSnapshot.data;
                    // Deduplicate to avoid DropdownButton assertion
                    final List<String> provinceNames =
                        (provinceModel?.data ?? []).toSet().toList();

                    // If the pre-selected province is not in the list, clear it
                    if (_selectedProvince != null &&
                        !provinceNames.contains(_selectedProvince)) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _selectedProvince = null);
                      });
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Province dropdown
                        LocationDropdownField(
                          label: 'Province/Territory',
                          value: provinceNames.contains(_selectedProvince)
                              ? _selectedProvince
                              : null,
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

                        // City dropdown
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
                                return _buildLoadingDropdown('City');
                              }

                              final cityModel = citySnapshot.data;
                              // Deduplicate to avoid DropdownButton assertion
                              final List<String> cityNames =
                                  (cityModel?.data ?? []).toSet().toList();

                              // If the pre-selected city is not in the list, clear it
                              if (_selectedCity != null &&
                                  !cityNames.contains(_selectedCity)) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted) {
                                    setState(() => _selectedCity = null);
                                  }
                                });
                              }

                              return LocationDropdownField(
                                label: 'City',
                                value: cityNames.contains(_selectedCity)
                                    ? _selectedCity
                                    : null,
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

                SizedBox(height: 48.h),

                // --------------- Save Button ---------------
                ValueListenableBuilder<bool>(
                  valueListenable: editProfileRxObj.isLoading,
                  builder: (context, isLoading, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3D7A),
                          disabledBackgroundColor: const Color(
                            0xFF0F3D7A,
                          ).withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26.r),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save Changes',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 36.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------
  // Helper widgets
  // ----------------------------------------------------------------

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Widget icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 15.sp, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
        prefixIcon: icon,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF0F3D7A)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
      ),
    );
  }

  /// Shown while the province/city list is loading.
  Widget _buildLoadingDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF0F3D7A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Shown when loading the province/city list fails.
  Widget _buildErrorDropdown(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.shade300),
          ),
          child: Center(
            child: Text(
              'Failed to load — tap to retry',
              style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
