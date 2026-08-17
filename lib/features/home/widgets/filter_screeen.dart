import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:abojude_flutter/networks/api_acess.dart';
import 'package:abojude_flutter/features/home/model/get_category_list_model.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';
import 'package:get/get.dart';

class FilterOptions {
  String category;
  String? province;
  String? city;
  double? minPrice;
  double? maxPrice;
  String sortBy;

  FilterOptions({
    this.category = 'All',
    this.province,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.sortBy = 'Featured',
  });

  FilterOptions copyWith({
    String? category,
    String? province,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    bool clearProvince = false,
    bool clearCity = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
  }) {
    return FilterOptions(
      category: category ?? this.category,
      province: clearProvince ? null : (province ?? this.province),
      city: clearCity ? null : (city ?? this.city),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

// Show Filter Bottom Sheet
void showFilterBottomSheet(
  BuildContext context, {
  required FilterOptions currentFilters,
  required ValueChanged<FilterOptions> onApply,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        FilterBottomSheet(currentFilters: currentFilters, onApply: onApply),
  );
}

class FilterBottomSheet extends StatefulWidget {
  final FilterOptions currentFilters;
  final ValueChanged<FilterOptions> onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterOptions _filters;

  final List<String> _sortOptions = [
    'Featured',
    'Newest First',
    'Oldest First',
    'Price: Low to High',
    'Price: High to Low',
  ];

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters.copyWith();
    if (_filters.minPrice != null) {
      _minPriceController.text = _filters.minPrice!.toStringAsFixed(0);
    }
    if (_filters.maxPrice != null) {
      _maxPriceController.text = _filters.maxPrice!.toStringAsFixed(0);
    }
    getCategoryListRxObj.getCategoryListRx();
    getProvinceRxObj.getProvinceRx();
    if (_filters.province != null) {
      getCityRxObj.getCityRx(_filters.province!);
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _filters = FilterOptions();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  bool _isFiltering = false;

  void _applyFilters() async {
    final min = double.tryParse(_minPriceController.text);
    final max = double.tryParse(_maxPriceController.text);

    final applied = _filters.copyWith(
      minPrice: min,
      maxPrice: max,
      clearMinPrice: _minPriceController.text.isEmpty,
      clearMaxPrice: _maxPriceController.text.isEmpty,
    );

    setState(() {
      _isFiltering = true;
    });

    try {
      List<String>? categorySlugs;
      if (applied.category != 'All' && applied.category.isNotEmpty) {
        if (applied.category == 'Buy & Sell') {
          categorySlugs = ['buy-sell'];
        } else if (applied.category == 'Jobs') {
          categorySlugs = ['jobs'];
        } else if (applied.category == 'Business Directory') {
          categorySlugs = ['business-directory'];
        } else if (applied.category == 'Services') {
          categorySlugs = ['services'];
        } else {
          categorySlugs = [
            applied.category
                .toLowerCase()
                .replaceAll(' ', '-')
                .replaceAll('&', 'and'),
          ];
        }
      }

      String? sortByVal;
      if (applied.sortBy == 'Featured') {
        sortByVal = 'featured';
      } else if (applied.sortBy == 'Newest First') {
        sortByVal = 'newest';
      } else if (applied.sortBy == 'Oldest First') {
        sortByVal = 'oldest';
      } else if (applied.sortBy == 'Price: Low to High') {
        sortByVal = 'price_low_high';
      } else if (applied.sortBy == 'Price: High to Low') {
        sortByVal = 'price_high_low';
      }

      if (categorySlugs == null &&
          applied.province == null &&
          applied.city == null &&
          applied.minPrice == null &&
          applied.maxPrice == null &&
          sortByVal == null) {
        await getRecentPostListRxObj.getRecentPostListRx();
      } else {
        await getRecentPostListRxObj.filterRecentPostListRx(
          categorySlugs: categorySlugs,
          province: applied.province,
          city: applied.city,
          minPrice: applied.minPrice?.toInt(),
          maxPrice: applied.maxPrice?.toInt(),
          sortBy: sortByVal,
        );
      }

      widget.onApply(applied);
      _clearAll();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to apply filters: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFiltering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(height: 24),
                  _buildCategorySection(),
                  const Divider(height: 28),
                  _buildProvinceSection(),
                  const SizedBox(height: 16),
                  _buildCitySection(),
                  const Divider(height: 28),
                  _buildPriceRangeSection(),
                  const Divider(height: 28),
                  _buildSortBySection(),
                  const SizedBox(height: 24),
                  SafeArea(child: _buildApplyButton()),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFD1D5DB),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filters'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _clearAll,
              child: Text(
                'Clear All'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
              ),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                size: 20,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return StreamBuilder<CategoryListModel>(
      stream: getCategoryListRxObj.getCategoryListData,
      builder: (context, snapshot) {
        final List<String> categories = ['All'];
        if (snapshot.hasData && snapshot.data?.data != null) {
          categories.addAll(
            snapshot.data!.data!
                .map((c) => c.name ?? '')
                .where((n) => n.isNotEmpty),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Category'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final selected = _filters.category == cat;
                return GestureDetector(
                  onTap: () => setState(
                    () => _filters = _filters.copyWith(category: cat),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF1A3A6B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF1A3A6B)
                            : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF374151),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProvinceSection() {
    return StreamBuilder<GetProvinceModel>(
      stream: getProvinceRxObj.getProvinceData,
      builder: (context, snapshot) {
        final List<String> provinces = [];
        if (snapshot.hasData && snapshot.data?.data != null) {
          provinces.addAll(snapshot.data!.data!);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Province'),
            const SizedBox(height: 10),
            _buildDropdown(
              value: _filters.province,
              hint: 'Select province',
              prefixIcon: Icons.map_outlined,
              items: provinces,
              onChanged: (val) => setState(() {
                _filters = _filters.copyWith(province: val, clearCity: true);
                if (val != null) {
                  getCityRxObj.getCityRx(val);
                }
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCitySection() {
    final enabled = _filters.province != null;
    return StreamBuilder<GetCityModel>(
      stream: getCityRxObj.getCityData,
      builder: (context, snapshot) {
        final List<String> cities = [];
        if (snapshot.hasData && snapshot.data?.data != null && enabled) {
          cities.addAll(snapshot.data!.data!);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('City'),
            const SizedBox(height: 10),
            _buildDropdown(
              value: _filters.city,
              hint: enabled ? 'Select city'.tr : 'Select province first'.tr,
              prefixIcon: Icons.navigation_outlined,
              items: cities,
              enabled: enabled,
              onChanged: enabled
                  ? (val) =>
                        setState(() => _filters = _filters.copyWith(city: val))
                  : null,
            ),
          ],
        );
      },
    );
  }

  // ==================== FIXED DROPDOWN ====================
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData prefixIcon,
    required List<String> items,
    bool enabled = true,
    ValueChanged<String?>? onChanged,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: enabled ? Colors.white : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: (value != null && items.contains(value)) ? value : null,
            isExpanded: true,
            dropdownColor: Colors.white, // ← Fixed black background
            menuMaxHeight: 300,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF9CA3AF),
              size: 20,
            ),
            hint: Row(
              children: [
                const SizedBox(width: 4),
                Icon(prefixIcon, size: 18, color: const Color(0xFF9CA3AF)),
                const SizedBox(width: 10),
                Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
            onChanged: enabled ? onChanged : null,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Price Range'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPriceField(
                controller: _minPriceController,
                hint: 'Min \$'.tr,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPriceField(
                controller: _maxPriceController,
                hint: 'Max \$'.tr,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSortBySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Sort By'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sortOptions.map((opt) {
            final selected = _filters.sortBy == opt;
            return GestureDetector(
              onTap: () =>
                  setState(() => _filters = _filters.copyWith(sortBy: opt)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF1A3A6B) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF1A3A6B)
                        : const Color(0xFFD1D5DB),
                  ),
                ),
                child: Text(
                  opt.tr,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.white : const Color(0xFF374151),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isFiltering ? () {} : _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A3A6B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isFiltering) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              _isFiltering ? 'Filtering...'.tr : 'Apply Filters'.tr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text.tr,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF111827),
      ),
    );
  }
}
