import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../utils/card_utils.dart';

class SmartCardNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<CardType>? onCardTypeChanged;
  final bool enabled;

  const SmartCardNumberInput({
    super.key,
    required this.controller,
    this.validator,
    this.onCardTypeChanged,
    this.enabled = true,
  });

  @override
  State<SmartCardNumberInput> createState() => _SmartCardNumberInputState();
}

class _SmartCardNumberInputState extends State<SmartCardNumberInput>
    with SingleTickerProviderStateMixin {
  CardType _currentCardType = CardType.unknown;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    widget.controller.addListener(_onCardNumberChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.controller.removeListener(_onCardNumberChanged);
    super.dispose();
  }

  void _onCardNumberChanged() {
    final cardNumber = widget.controller.text;
    final newCardType = CardUtils.detectCardType(cardNumber);
    final isValid = CardUtils.validateCardNumber(cardNumber);

    if (newCardType != _currentCardType) {
      setState(() => _currentCardType = newCardType);
      widget.onCardTypeChanged?.call(newCardType);
      
      if (newCardType != CardType.unknown) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        HapticFeedback.lightImpact();
      }
    }

    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
      if (isValid) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Card Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          validator: widget.validator,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CardNumberInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'Enter your card number',
            prefixIcon: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CardUtils.getCardIcon(_currentCardType, size: 24),
                  ),
                );
              },
            ),
            suffixIcon: _isValid
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid 
                    ? AppColors.success.withOpacity(0.5)
                    : AppColors.divider.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid ? AppColors.success : AppColors.primary,
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
        ),
        if (_currentCardType != CardType.unknown) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                CardUtils.getCardInfo(_currentCardType)?.name ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class SmartExpiryInput extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool enabled;

  const SmartExpiryInput({
    super.key,
    required this.controller,
    this.validator,
    this.enabled = true,
  });

  @override
  State<SmartExpiryInput> createState() => _SmartExpiryInputState();
}

class _SmartExpiryInputState extends State<SmartExpiryInput> {
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onExpiryChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onExpiryChanged);
    super.dispose();
  }

  void _onExpiryChanged() {
    final expiry = widget.controller.text;
    final isValid = CardUtils.validateExpiryDate(expiry);

    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
      if (isValid) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiry Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          validator: widget.validator,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ExpiryDateInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'MM/YY',
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.textSecondary,
            ),
            suffixIcon: _isValid
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid 
                    ? AppColors.success.withOpacity(0.5)
                    : AppColors.divider.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid ? AppColors.success : AppColors.primary,
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
        ),
      ],
    );
  }
}

class SmartCVVInput extends StatefulWidget {
  final TextEditingController controller;
  final CardType cardType;
  final String? Function(String?)? validator;
  final bool enabled;

  const SmartCVVInput({
    super.key,
    required this.controller,
    required this.cardType,
    this.validator,
    this.enabled = true,
  });

  @override
  State<SmartCVVInput> createState() => _SmartCVVInputState();
}

class _SmartCVVInputState extends State<SmartCVVInput> {
  bool _isValid = false;
  bool _showCVVInfo = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onCVVChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onCVVChanged);
    super.dispose();
  }

  void _onCVVChanged() {
    final cvv = widget.controller.text;
    final isValid = CardUtils.validateCVV(cvv, widget.cardType);

    if (isValid != _isValid) {
      setState(() => _isValid = isValid);
      if (isValid) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final expectedLength = widget.cardType == CardType.amex ? 4 : 3;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'CVV',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                setState(() => _showCVVInfo = !_showCVVInfo);
                HapticFeedback.selectionClick();
              },
              child: Icon(
                Icons.help_outline,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          validator: widget.validator,
          maxLength: expectedLength,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(expectedLength),
          ],
          decoration: InputDecoration(
            hintText: '•' * expectedLength,
            counterText: '',
            prefixIcon: const Icon(
              Icons.security,
              color: AppColors.textSecondary,
            ),
            suffixIcon: _isValid
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid 
                    ? AppColors.success.withOpacity(0.5)
                    : AppColors.divider.withOpacity(0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _isValid ? AppColors.success : AppColors.primary,
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
        ),
        if (_showCVVInfo) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.info,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.cardType == CardType.amex
                        ? 'For Amex cards, CVV is the 4-digit code on the front'
                        : 'CVV is the 3-digit code on the back of your card',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Input formatters
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final formatted = CardUtils.formatCardNumber(text);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final formatted = CardUtils.formatExpiryDate(text);
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
