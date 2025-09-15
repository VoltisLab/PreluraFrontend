import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../widgets/country_code_picker.dart';
import '../data/country_codes.dart';

enum AddressType { home, work, other }

class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final AddressType type;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.type,
    this.isDefault = false,
  });
}

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<AddressModel> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadDemoAddresses();
  }

  void _loadDemoAddresses() {
    _addresses = [
      AddressModel(
        id: '1',
        name: 'John Doe',
        phone: '+1234567890',
        address: '123 Main Street, Apt 4B',
        city: 'London',
        state: 'England',
        postalCode: 'SW1A 1AA',
        country: 'United Kingdom',
        type: AddressType.home,
        isDefault: true,
      ),
      AddressModel(
        id: '2',
        name: 'John Doe',
        phone: '+1234567890',
        address: '456 Business Ave, Suite 200',
        city: 'Manchester',
        state: 'England',
        postalCode: 'M1 1AA',
        country: 'United Kingdom',
        type: AddressType.work,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Delivery Addresses',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: _addNewAddress,
            tooltip: 'Add Address',
          ),
        ],
      ),
      body: _addresses.isEmpty ? _buildEmptyState() : _buildAddressList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewAddress,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No addresses saved',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your delivery addresses for faster checkout',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _addNewAddress,
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Add First Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return _buildAddressCard(address);
      },
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _showAddressOptions(address);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: address.isDefault ? AppColors.primary : AppColors.divider.withOpacity(0.3),
            width: address.isDefault ? 2 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAddressTypeColor(address.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAddressTypeIcon(address.type),
                          size: 14,
                          color: _getAddressTypeColor(address.type),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getAddressTypeLabel(address.type),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getAddressTypeColor(address.type),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'DEFAULT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _editAddress(address);
                          break;
                        case 'delete':
                          _deleteAddress(address);
                          break;
                        case 'default':
                          _setAsDefault(address);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      if (!address.isDefault)
                        const PopupMenuItem(value: 'default', child: Text('Set as Default')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                address.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address.phone,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                address.address,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${address.city}, ${address.state} ${address.postalCode}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                address.country,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAddressTypeColor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return AppColors.primary;
      case AddressType.work:
        return Colors.orange;
      case AddressType.other:
        return Colors.purple;
    }
  }

  IconData _getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Icons.home;
      case AddressType.work:
        return Icons.business;
      case AddressType.other:
        return Icons.location_on;
    }
  }

  String _getAddressTypeLabel(AddressType type) {
    switch (type) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }

  void _addNewAddress() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAddressScreen(),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _addresses.add(result as AddressModel);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _editAddress(AddressModel address) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(address: address),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          final index = _addresses.indexWhere((a) => a.id == address.id);
          if (index != -1) {
            _addresses[index] = result as AddressModel;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });
  }

  void _deleteAddress(AddressModel address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?\n\n${address.name}\n${address.address}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeWhere((a) => a.id == address.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _setAsDefault(AddressModel address) {
    setState(() {
      _addresses = _addresses.map((a) => AddressModel(
        id: a.id,
        name: a.name,
        phone: a.phone,
        address: a.address,
        city: a.city,
        state: a.state,
        postalCode: a.postalCode,
        country: a.country,
        type: a.type,
        isDefault: a.id == address.id,
      )).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default address updated'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showAddressOptions(AddressModel address) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                address.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: Icons.edit,
                title: 'Edit Address',
                onTap: () {
                  Navigator.pop(context);
                  _editAddress(address);
                },
              ),
              if (!address.isDefault)
                _buildOptionTile(
                  icon: Icons.star,
                  title: 'Set as Default',
                  onTap: () {
                    Navigator.pop(context);
                    _setAsDefault(address);
                  },
                ),
              _buildOptionTile(
                icon: Icons.delete,
                title: 'Delete Address',
                onTap: () {
                  Navigator.pop(context);
                  _deleteAddress(address);
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isDestructive ? AppColors.error : AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class AddAddressScreen extends StatefulWidget {
  final AddressModel? address;
  
  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  
  CountryCode _selectedCountry = CountryCodes.countries.first;
  AddressType _selectedType = AddressType.home;
  bool _setAsDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _loadAddressData();
    }
  }

  void _loadAddressData() {
    final address = widget.address!;
    _nameController.text = address.name;
    _phoneController.text = address.phone;
    _addressController.text = address.address;
    _cityController.text = address.city;
    _stateController.text = address.state;
    _postalCodeController.text = address.postalCode;
    _selectedType = address.type;
    _setAsDefault = address.isDefault;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.address != null ? 'Edit Address' : 'Add Address',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressTypeSelector(),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter recipient name',
                      icon: Icons.person_outline,
                      validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    PhoneNumberField(
                      phoneController: _phoneController,
                      selectedCountry: _selectedCountry,
                      onCountryChanged: (country) {
                        setState(() => _selectedCountry = country);
                      },
                      label: 'Phone Number',
                      hint: 'Enter phone number',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: 'Street Address',
                      hint: 'Enter street address',
                      icon: Icons.location_on_outlined,
                      maxLines: 2,
                      validator: (value) => value?.isEmpty ?? true ? 'Address is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _cityController,
                            label: 'City',
                            hint: 'Enter city',
                            icon: Icons.location_city_outlined,
                            validator: (value) => value?.isEmpty ?? true ? 'City is required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _stateController,
                            label: 'State/Province',
                            hint: 'Enter state',
                            icon: Icons.map_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      hint: 'Enter postal code',
                      icon: Icons.markunread_mailbox_outlined,
                      validator: (value) => value?.isEmpty ?? true ? 'Postal code is required' : null,
                    ),
                    const SizedBox(height: 24),
                    CheckboxListTile(
                      title: const Text('Set as default address'),
                      subtitle: const Text('Use this address for all future orders'),
                      value: _setAsDefault,
                      onChanged: (value) {
                        setState(() {
                          _setAsDefault = value ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.address != null ? 'Update Address' : 'Save Address',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: AddressType.values.map((type) {
            final isSelected = _selectedType == type;
            return Expanded(
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedType = type;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getAddressTypeColor(type).withOpacity(0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? _getAddressTypeColor(type)
                          : AppColors.divider.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getAddressTypeIcon(type),
                        color: isSelected 
                            ? _getAddressTypeColor(type)
                            : AppColors.textSecondary,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getAddressTypeLabel(type),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected 
                              ? _getAddressTypeColor(type)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.surface,
          ),
        ),
      ],
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      await Future.delayed(const Duration(seconds: 1));

      final newAddress = AddressModel(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        postalCode: _postalCodeController.text,
        country: _selectedCountry.name,
        type: _selectedType,
        isDefault: _setAsDefault,
      );

      Navigator.pop(context, newAddress);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save address. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _getAddressTypeColor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return AppColors.primary;
      case AddressType.work:
        return Colors.orange;
      case AddressType.other:
        return Colors.purple;
    }
  }

  IconData _getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Icons.home;
      case AddressType.work:
        return Icons.business;
      case AddressType.other:
        return Icons.location_on;
    }
  }

  String _getAddressTypeLabel(AddressType type) {
    switch (type) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.other:
        return 'Other';
    }
  }
}