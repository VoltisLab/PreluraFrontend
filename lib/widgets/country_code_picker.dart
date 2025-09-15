import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../data/country_codes.dart';

class CountryCodePicker extends StatefulWidget {
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onChanged;
  final bool enabled;

  const CountryCodePicker({
    super.key,
    required this.selectedCountry,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  void _showCountryPicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryPickerModal(
        selectedCountry: widget.selectedCountry,
        onCountrySelected: widget.onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.enabled ? _showCountryPicker : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.enabled 
                ? AppColors.divider.withOpacity(0.5)
                : AppColors.divider.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12),
          color: widget.enabled 
              ? AppColors.surface 
              : AppColors.divider.withOpacity(0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.selectedCountry.flag,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Text(
              widget.selectedCountry.dialCode,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: widget.enabled 
                    ? AppColors.textPrimary 
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: widget.enabled 
                  ? AppColors.textSecondary 
                  : AppColors.textSecondary.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CountryPickerModal extends StatefulWidget {
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onCountrySelected;

  const CountryPickerModal({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<CountryPickerModal> createState() => _CountryPickerModalState();
}

class _CountryPickerModalState extends State<CountryPickerModal> {
  final TextEditingController _searchController = TextEditingController();
  List<CountryCode> _filteredCountries = CountryCodes.countries;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = CountryCodes.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.public, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Select Country',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: 'Search countries...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.divider.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.divider.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          
          // Countries list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country.code == widget.selectedCountry.code;
                
                return InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    widget.onCountrySelected(country);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primary.withOpacity(0.1) 
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(
                          country.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected 
                                      ? FontWeight.w600 
                                      : FontWeight.normal,
                                  color: isSelected 
                                      ? AppColors.primary 
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                country.dialCode,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected 
                                      ? AppColors.primary.withOpacity(0.7)
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class PhoneNumberField extends StatefulWidget {
  final TextEditingController phoneController;
  final CountryCode selectedCountry;
  final ValueChanged<CountryCode> onCountryChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final String label;
  final String? hint;

  const PhoneNumberField({
    super.key,
    required this.phoneController,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.validator,
    this.enabled = true,
    this.label = 'Phone Number',
    this.hint,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryCodePicker(
              selectedCountry: widget.selectedCountry,
              onChanged: widget.onCountryChanged,
              enabled: widget.enabled,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: widget.phoneController,
                keyboardType: TextInputType.phone,
                validator: widget.validator,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  hintText: widget.hint ?? 'Enter phone number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.divider.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: widget.enabled 
                      ? AppColors.surface 
                      : AppColors.divider.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
