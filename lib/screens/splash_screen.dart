import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/enhanced_product_provider.dart';
import '../providers/vendor_provider.dart';
import '../services/token_service.dart';
import '../services/graphql_service.dart';
import '../models/user_model.dart';
import 'home_screen_simple.dart';
import 'auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
    
    _initializeApp();
  }


  Future<void> _initializeApp() async {
    // Wait for the first frame to complete before loading data
    await Future.delayed(Duration.zero);
    
    // Load initial data
    await Future.wait([
      context.read<EnhancedProductProvider>().loadProducts(),
      context.read<VendorProvider>().loadVendors(),
    ]);
    
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      
      // Check for stored authentication token
      final hasToken = await TokenService.hasValidToken();
      
      if (hasToken) {
        try {
          final token = await TokenService.getToken();
          if (token != null) {
            // For demo purposes, use mock authentication
            debugPrint('✅ Using mock authentication for demo');
            authProvider.mockLogin();
            
            // Navigate to home
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenSimple()),
            );
            return;
          }
        } catch (e) {
          // Token invalid, clear it
          await TokenService.clearTokens();
        }
      }
      
      // No valid token, go to sign in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.store,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Wholesalers',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'B2B Marketplace',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Loader positioned 50px above "Powered by Voltis Labs"
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 90, // 40 + 50
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      strokeWidth: 3,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 16,
            right: 16,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Powered by Voltis Labs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
