import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── Filter Model ─────────────────────────────────────────────────────────────

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

// ─── Show Filter Bottom Sheet (call this from your screen) ───────────────────

void showFilterBottomSheet(
    BuildContext context, {
      required FilterOptions currentFilters,
      required ValueChanged<FilterOptions> onApply,
    }) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => FilterBottomSheet(
      currentFilters: currentFilters,
      onApply: onApply,
    ),
  );
}

// ─── Filter Bottom Sheet Widget ───────────────────────────────────────────────

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

  final List<String> _categories = [
    'All',
    'Buy & Sell',
    'Jobs',
    'Services',
    'Business Directory',
  ];

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
  ];

  final Map<String, List<String>> _citiesByProvince = {
    'Alberta': ['Calgary', 'Edmonton', 'Red Deer', 'Lethbridge'],
    'British Columbia': ['Vancouver', 'Victoria', 'Kelowna', 'Surrey'],
    'Manitoba': ['Winnipeg', 'Brandon', 'Steinbach'],
    'New Brunswick': ['Moncton', 'Saint John', 'Fredericton'],
    'Newfoundland and Labrador': ["St. John's", 'Corner Brook'],
    'Nova Scotia': ['Halifax', 'Sydney', 'Truro'],
    'Ontario': ['Toronto', 'Ottawa', 'Mississauga', 'Hamilton', 'London'],
    'Prince Edward Island': ['Charlottetown', 'Summerside'],
    'Quebec': ['Montreal', 'Quebec City', 'Laval', 'Gatineau'],
    'Saskatchewan': ['Saskatoon', 'Regina', 'Prince Albert'],
  };

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

  void _applyFilters() {
    final min = double.tryParse(_minPriceController.text);
    final max = double.tryParse(_maxPriceController.text);
    final applied = _filters.copyWith(
      minPrice: min,
      maxPrice: max,
      clearMinPrice: _minPriceController.text.isEmpty,
      clearMaxPrice: _maxPriceController.text.isEmpty,
    );
    widget.onApply(applied);
    Navigator.of(context).pop();
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
                  _buildApplyButton(),
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
        const Text(
          'Filters',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _clearAll,
              child: const Text(
                'Clear All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
              ),
            ),
            const SizedBox(width: 14),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, size: 20, color: Color(0xFF374151)),
            ),
          ],
        ),
      ],
    );
  }

  // ── Category ───────────────────────────────────────────────────────────────

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Category'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((cat) {
            final selected = _filters.category == cat;
            return GestureDetector(
              onTap: () => setState(() => _filters = _filters.copyWith(category: cat)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

  // ── Province ───────────────────────────────────────────────────────────────

  Widget _buildProvinceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Province'),
        const SizedBox(height: 10),
        _buildDropdown(
          value: _filters.province,
          hint: 'Select province',
          prefixIcon: Icons.map_outlined,
          items: _provinces,
          onChanged: (val) => setState(() {
            _filters = _filters.copyWith(
              province: val,
              clearCity: true,
            );
          }),
        ),
      ],
    );
  }

  // ── City ───────────────────────────────────────────────────────────────────

  Widget _buildCitySection() {
    final cities = _filters.province != null
        ? (_citiesByProvince[_filters.province] ?? [])
        : <String>[];
    final enabled = _filters.province != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('City'),
        const SizedBox(height: 10),
        _buildDropdown(
          value: _filters.city,
          hint: enabled ? 'Select city' : 'Select province first',
          prefixIcon: Icons.navigation_outlined,
          items: cities,
          enabled: enabled,
          onChanged: enabled
              ? (val) => setState(() => _filters = _filters.copyWith(city: val))
              : null,
        ),
      ],
    );
  }

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
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF9CA3AF), size: 20),
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
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF111827),
            ),
            onChanged: enabled ? onChanged : null,
            items: items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  // ── Price Range ────────────────────────────────────────────────────────────

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
                hint: 'Min \$',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPriceField(
                controller: _maxPriceController,
                hint: 'Max \$',
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
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  // ── Sort By ────────────────────────────────────────────────────────────────

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
              onTap: () => setState(() => _filters = _filters.copyWith(sortBy: opt)),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                  opt,
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

  // ── Apply Button ───────────────────────────────────────────────────────────

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A3A6B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Apply Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF111827),
      ),
    );
  }
}