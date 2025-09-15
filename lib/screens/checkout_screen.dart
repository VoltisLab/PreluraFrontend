import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../widgets/smart_card_input.dart';
import '../utils/card_utils.dart';
import 'smart_payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isProcessing = false;

  // Shipping Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'United Kingdom');

  // Payment Information
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  String _selectedShippingMethod = 'standard';
  String _selectedPaymentMethod = 'card';
  CardType _currentCardType = CardType.unknown;

  final List<Map<String, dynamic>> _shippingMethods = [
    {
      'id': 'standard',
      'name': 'Standard Delivery',
      'description': '5-7 business days',
      'price': 4.99,
      'icon': Icons.local_shipping,
    },
    {
      'id': 'express',
      'name': 'Express Delivery',
      'description': '2-3 business days',
      'price': 9.99,
      'icon': Icons.flash_on,
    },
    {
      'id': 'overnight',
      'name': 'Next Day Delivery',
      'description': 'Next business day',
      'price': 19.99,
      'icon': Icons.rocket_launch,
    },
  ];

  @override
  void initState() {
    super.initState();
    _prefillUserData();
  }

  void _prefillUserData() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.currentUser;
    
    if (user != null) {
      _firstNameController.text = user.name.split(' ').first;
      if (user.name.split(' ').length > 1) {
        _lastNameController.text = user.name.split(' ').skip(1).join(' ');
      }
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _cardHolderController.text = user.name;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _processOrder() async {
    setState(() => _isProcessing = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));
      
      // Clear cart after successful order
      if (mounted) {
        context.read<CartProvider>().clearCart();
        
        // Navigate to order success screen
        Navigator.pushReplacementNamed(
          context,
          '/order-success',
          arguments: {
            'orderId': 'WM${DateTime.now().millisecondsSinceEpoch}',
            'total': _calculateTotal(),
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  double _calculateSubtotal() {
    return context.read<CartProvider>().totalAmount;
  }

  double _calculateShipping() {
    final method = _shippingMethods.firstWhere(
      (m) => m['id'] == _selectedShippingMethod,
    );
    return method['price'].toDouble();
  }

  double _calculateTax() {
    return _calculateSubtotal() * 0.20; // 20% VAT
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateShipping() + _calculateTax();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildOrderSummary(),
                _buildShippingForm(),
                _buildPaymentForm(),
                _buildOrderReview(),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: index < _currentStep ? AppColors.primary : AppColors.divider,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...cartProvider.items.map((item) => _buildOrderItem(item)),
              const Divider(height: 32),
              _buildPriceSummary(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.product.images.first,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.vendor.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '£${(item.product.discountPrice ?? item.product.price).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Column(
      children: [
        _buildPriceRow('Subtotal', _calculateSubtotal()),
        _buildPriceRow('Shipping', _calculateShipping()),
        _buildPriceRow('VAT (20%)', _calculateTax()),
        const Divider(),
        _buildPriceRow('Total', _calculateTotal(), isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '£${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name *',
                  hint: 'Enter first name',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name *',
                  hint: 'Enter last name',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address *',
            hint: 'Enter email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number *',
            hint: 'Enter phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressController,
            label: 'Street Address *',
            hint: 'Enter street address',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City *',
                  hint: 'Enter city',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _stateController,
                  label: 'County *',
                  hint: 'County',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _zipController,
                  label: 'Postcode *',
                  hint: 'Enter postcode',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _countryController,
                  label: 'Country *',
                  hint: 'Country',
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Shipping Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._shippingMethods.map((method) => _buildShippingOption(method)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.divider.withOpacity(0.3),
      ),
    );
  }

  Widget _buildShippingOption(Map<String, dynamic> method) {
    final isSelected = _selectedShippingMethod == method['id'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedShippingMethod = method['id']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                method['icon'],
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      method['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '£${method['price'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          // Use Smart Payment Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.credit_card,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Smart Payment Entry',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Auto-detect card type, format numbers, and scan cards',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final cartProvider = context.read<CartProvider>();
                      final total = cartProvider.totalAmount + 
                          _shippingMethods.firstWhere((m) => m['id'] == _selectedShippingMethod)['price'];
                      
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SmartPaymentScreen(
                            amount: total,
                            currency: 'USD',
                            onPaymentComplete: () {
                              // Payment completed, continue with order
                              _nextStep();
                            },
                          ),
                        ),
                      );
                      
                      if (result == true) {
                        // Payment was successful, fill in dummy data for review
                        _cardNumberController.text = '•••• •••• •••• 1111';
                        _cardHolderController.text = 'CARD HOLDER';
                        _expiryController.text = '12/25';
                        _cvvController.text = '***';
                      }
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text('Enter Payment Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Alternative: Manual entry (collapsed by default)
          ExpansionTile(
            title: const Text(
              'Manual Card Entry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            children: [
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cardHolderController,
                label: 'Cardholder Name *',
                hint: 'Enter name on card',
              ),
              const SizedBox(height: 16),
              SmartCardNumberInput(
                controller: _cardNumberController,
                onCardTypeChanged: (cardType) {
                  setState(() => _currentCardType = cardType);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your card number';
                  }
                  if (!CardUtils.validateCardNumber(value)) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SmartExpiryInput(
                      controller: _expiryController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!CardUtils.validateExpiryDate(value)) {
                          return 'Invalid date';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SmartCVVInput(
                      controller: _cvvController,
                      cardType: _currentCardType,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (!CardUtils.validateCVV(value, _currentCardType)) {
                          return 'Invalid CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Secure Payment',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        'Your payment information is encrypted and secure.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderReview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Your Order',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildReviewSection('Shipping Address', [
            '${_firstNameController.text} ${_lastNameController.text}',
            _addressController.text,
            '${_cityController.text}, ${_stateController.text} ${_zipController.text}',
            _countryController.text,
          ]),
          const SizedBox(height: 16),
          _buildReviewSection('Contact Information', [
            _emailController.text,
            _phoneController.text,
          ]),
          const SizedBox(height: 16),
          _buildReviewSection('Payment Method', [
            'Card ending in ${_cardNumberController.text.length > 4 ? _cardNumberController.text.substring(_cardNumberController.text.length - 4) : "****"}',
            _cardHolderController.text,
          ]),
          const SizedBox(height: 16),
          _buildReviewSection('Shipping Method', [
            _shippingMethods.firstWhere((m) => m['id'] == _selectedShippingMethod)['name'],
            _shippingMethods.firstWhere((m) => m['id'] == _selectedShippingMethod)['description'],
          ]),
          const SizedBox(height: 24),
          _buildPriceSummary(),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : _currentStep == 3
                      ? _processOrder
                      : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep == 3 ? 'Place Order' : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
