import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../widgets/platform_widgets.dart';
import '../data/country_codes.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final CountryCode countryCode;
  final VoidCallback? onVerificationComplete;
  final bool isFromProfile;

  const PhoneVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.countryCode,
    this.onVerificationComplete,
    this.isFromProfile = false,
  });

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _timer;
  int _resendTimer = 60;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _isResending = false;
  String _verificationCode = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
    _startResendTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _onCodeChanged(String value, int index) {
    setState(() {
      _verificationCode = _controllers.map((c) => c.text).join();
    });

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all fields are filled
    if (_verificationCode.length == 6) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    if (_verificationCode.length != 6) {
      PlatformWidgets.showSnackBar(
        context,
        message: 'Please enter the complete verification code',
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => _isVerifying = true);
    HapticFeedback.lightImpact();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // For demo purposes, accept any 6-digit code
      if (_verificationCode == '123456' || _verificationCode.length == 6) {
        HapticFeedback.heavyImpact();
        
        PlatformWidgets.showSnackBar(
          context,
          message: 'Phone number verified successfully!',
          type: SnackBarType.success,
        );

        // Wait a moment for the success message
        await Future.delayed(const Duration(milliseconds: 500));

        if (widget.onVerificationComplete != null) {
          widget.onVerificationComplete!();
        }

        if (widget.isFromProfile) {
          Navigator.pop(context, true); // Return success
        } else {
          // Navigate to next onboarding step or home
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        throw Exception('Invalid verification code');
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      PlatformWidgets.showSnackBar(
        context,
        message: 'Invalid verification code. Please try again.',
        type: SnackBarType.error,
      );
      
      // Clear the code and focus first field
      _clearCode();
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() => _verificationCode = '');
    _focusNodes[0].requestFocus();
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);
    HapticFeedback.selectionClick();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      PlatformWidgets.showSnackBar(
        context,
        message: 'Verification code sent successfully!',
        type: SnackBarType.success,
      );

      _startResendTimer();
    } catch (e) {
      PlatformWidgets.showSnackBar(
        context,
        message: 'Failed to resend code. Please try again.',
        type: SnackBarType.error,
      );
    } finally {
      setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PlatformWidgets.appBar(
        title: 'Verify Phone Number',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Phone icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone_android,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Title
                        const Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Description
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(
                                text: 'We\'ve sent a 6-digit verification code to\n',
                              ),
                              TextSpan(
                                text: '${widget.countryCode.dialCode} ${widget.phoneNumber}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Code input fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 45,
                              height: 55,
                              child: TextFormField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.divider,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: AppColors.divider.withOpacity(0.5),
                                      width: 2,
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
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) => _onCodeChanged(value, index),
                              ),
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Resend code section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Didn\'t receive the code? ',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (_canResend)
                              TextButton(
                                onPressed: _isResending ? null : _resendCode,
                                child: _isResending
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primary,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Resend',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                              )
                            else
                              Text(
                                'Resend in ${_resendTimer}s',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Demo hint
                        Container(
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
                                Icons.info_outline,
                                color: AppColors.info,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Demo: Use code 123456 or any 6-digit code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Verify button
                  PlatformWidgets.primaryButton(
                    text: 'Verify Phone Number',
                    onPressed: _verificationCode.length == 6 && !_isVerifying
                        ? _verifyCode
                        : null,
                    isLoading: _isVerifying,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
