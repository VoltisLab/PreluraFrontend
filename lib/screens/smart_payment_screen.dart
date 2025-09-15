import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../widgets/platform_widgets.dart';
import '../widgets/smart_card_input.dart';
import '../utils/card_utils.dart';

class SmartPaymentScreen extends StatefulWidget {
  final double? amount;
  final String? currency;
  final VoidCallback? onPaymentComplete;

  const SmartPaymentScreen({
    super.key,
    this.amount,
    this.currency = 'USD',
    this.onPaymentComplete,
  });

  @override
  State<SmartPaymentScreen> createState() => _SmartPaymentScreenState();
}

class _SmartPaymentScreenState extends State<SmartPaymentScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  late AnimationController _cardAnimationController;
  late AnimationController _processingController;
  late Animation<double> _cardFlipAnimation;
  late Animation<double> _processingAnimation;

  CardType _currentCardType = CardType.unknown;
  bool _isProcessing = false;
  bool _showCardBack = false;
  bool _saveCard = false;

  @override
  void initState() {
    super.initState();
    
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _processingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardFlipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeInOut,
    ));

    _processingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _processingController,
      curve: Curves.easeInOut,
    ));

    // Auto-flip card when CVV field is focused
    _cvvController.addListener(() {
      if (_cvvController.text.isNotEmpty && !_showCardBack) {
        _flipCard(true);
      } else if (_cvvController.text.isEmpty && _showCardBack) {
        _flipCard(false);
      }
    });
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _processingController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _flipCard(bool showBack) {
    setState(() => _showCardBack = showBack);
    if (showBack) {
      _cardAnimationController.forward();
    } else {
      _cardAnimationController.reverse();
    }
    HapticFeedback.lightImpact();
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    _processingController.repeat();
    HapticFeedback.heavyImpact();

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      _processingController.stop();
      
      // Show success animation
      PlatformWidgets.showSnackBar(
        context,
        message: 'Payment processed successfully!',
        type: SnackBarType.success,
      );

      // Wait a moment then complete
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (widget.onPaymentComplete != null) {
        widget.onPaymentComplete!();
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _processingController.stop();
      PlatformWidgets.showSnackBar(
        context,
        message: 'Payment failed. Please try again.',
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _scanCard() async {
    HapticFeedback.selectionClick();
    
    // Show scanning animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CardScanningDialog(),
    );

    // Simulate card scanning
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pop(context);
      
      // Fill in demo card data
      _cardNumberController.text = '4111 1111 1111 1111';
      _expiryController.text = '12/25';
      _cardHolderController.text = 'JOHN DOE';
      
      PlatformWidgets.showSnackBar(
        context,
        message: 'Card scanned successfully!',
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PlatformWidgets.appBar(
        title: 'Payment Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _scanCard,
            tooltip: 'Scan Card',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount display
                      if (widget.amount != null) ...[
                        _buildAmountCard(),
                        const SizedBox(height: 24),
                      ],

                      // 3D Credit Card
                      _buildCreditCard(),
                      const SizedBox(height: 32),

                      // Card scanning hint
                      _buildScanHint(),
                      const SizedBox(height: 24),

                      // Card holder name
                      _buildCardHolderField(),
                      const SizedBox(height: 20),

                      // Card number
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
                      const SizedBox(height: 20),

                      // Expiry and CVV
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                _flipCard(hasFocus);
                              },
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Save card option
                      _buildSaveCardOption(),
                      const SizedBox(height: 24),

                      // Security info
                      _buildSecurityInfo(),
                    ],
                  ),
                ),
              ),
            ),

            // Payment button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: PlatformWidgets.primaryButton(
                text: widget.amount != null 
                    ? 'Pay ${widget.currency} ${widget.amount?.toStringAsFixed(2)}'
                    : 'Add Payment Method',
                onPressed: _isProcessing ? null : _processPayment,
                isLoading: _isProcessing,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.currency} ${widget.amount?.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard() {
    return Center(
      child: AnimatedBuilder(
        animation: _cardFlipAnimation,
        builder: (context, child) {
          final isShowingFront = _cardFlipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_cardFlipAnimation.value * math.pi),
            child: isShowingFront
                ? _buildCardFront()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildCardBack(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _currentCardType != CardType.unknown
              ? [
                  CardUtils.getCardInfo(_currentCardType)?.color ?? AppColors.primary,
                  (CardUtils.getCardInfo(_currentCardType)?.color ?? AppColors.primary).withOpacity(0.7),
                ]
              : [AppColors.textSecondary, AppColors.textSecondary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DEBIT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_currentCardType != CardType.unknown)
                  CardUtils.getCardIcon(_currentCardType, size: 32),
              ],
            ),
            const Spacer(),
            Text(
              _cardNumberController.text.isEmpty
                  ? '•••• •••• •••• ••••'
                  : _cardNumberController.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CARDHOLDER',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _cardHolderController.text.isEmpty
                          ? 'YOUR NAME'
                          : _cardHolderController.text.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXPIRES',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _expiryController.text.isEmpty
                          ? 'MM/YY'
                          : _expiryController.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _currentCardType != CardType.unknown
              ? [
                  CardUtils.getCardInfo(_currentCardType)?.color ?? AppColors.primary,
                  (CardUtils.getCardInfo(_currentCardType)?.color ?? AppColors.primary).withOpacity(0.7),
                ]
              : [AppColors.textSecondary, AppColors.textSecondary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _cvvController.text.isEmpty ? 'CVV' : _cvvController.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanHint() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.camera_alt,
            color: AppColors.info,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Tap the camera icon to scan your card automatically',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.info,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardHolderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cardholder Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _cardHolderController,
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the cardholder name';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter name as shown on card',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textSecondary,
            ),
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
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveCardOption() {
    return Row(
      children: [
        Checkbox(
          value: _saveCard,
          onChanged: (value) {
            setState(() => _saveCard = value ?? false);
            HapticFeedback.selectionClick();
          },
          activeColor: AppColors.primary,
        ),
        const Expanded(
          child: Text(
            'Save this card for future purchases',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Your payment information is encrypted and secure',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardScanningDialog extends StatefulWidget {
  const CardScanningDialog({super.key});

  @override
  State<CardScanningDialog> createState() => _CardScanningDialogState();
}

class _CardScanningDialogState extends State<CardScanningDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_animation.value * 0.1),
                  child: Icon(
                    Icons.camera_alt,
                    size: 60,
                    color: AppColors.primary.withOpacity(0.5 + (_animation.value * 0.5)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Scanning Card...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hold your card steady in the camera view',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
