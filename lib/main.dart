import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'constants/app_colors.dart';
import 'providers/auth_provider.dart';
import 'providers/enhanced_product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/vendor_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen_simple.dart';
import 'screens/maps_screen.dart';
import 'screens/vendor_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/vendor_dashboard_screen.dart';
import 'screens/vendor_shop_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/vendor_onboarding_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/enhanced_search_screen.dart';
import 'screens/category_screen.dart';
import 'screens/order_confirmation_screen.dart';
import 'screens/personal_info_screen.dart';
import 'screens/sales_analytics_screen.dart';
import 'screens/inventory_management_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/addresses_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/terms_conditions_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/about_screen.dart';
import 'screens/vendor_dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/modern_profile_screen.dart';
import 'screens/enhanced_vendor_list_screen.dart';
import 'screens/live_chat_screen.dart';
import 'screens/email_support_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/bug_report_screen.dart';
import 'screens/send_feedback_screen.dart';
import 'screens/phone_verification_screen.dart';
import 'screens/smart_payment_screen.dart';
import 'models/product_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EnhancedProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'Prelura - Fashion Marketplace',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            secondary: AppColors.secondary,
            onSecondary: Colors.white,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
            background: AppColors.background,
            onBackground: AppColors.textPrimary,
            error: AppColors.error,
            onError: Colors.white,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w300),
            displayMedium: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            displaySmall: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            headlineLarge: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            headlineMedium: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            headlineSmall: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            titleLarge: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w500),
            titleMedium: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w500),
            titleSmall: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            bodyMedium: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            bodySmall: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w400),
            labelLarge: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w500),
            labelMedium: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w500),
            labelSmall: TextStyle(fontFamily: '.SF Pro Text', fontWeight: FontWeight.w500),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: Platform.isIOS,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: Platform.isIOS ? 0 : 2,
              shadowColor: Platform.isIOS ? Colors.transparent : Colors.black26,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            color: Colors.white, // Explicitly set to pure white
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            type: BottomNavigationBarType.fixed,
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: Colors.white,
            unselectedLabelColor: AppColors.textSecondary,
            indicator: BoxDecoration(
              color: AppColors.primary,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary.withOpacity(0.1),
            labelStyle: const TextStyle(color: AppColors.textPrimary),
            side: const BorderSide(color: AppColors.divider),
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          popupMenuTheme: const PopupMenuThemeData(
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          listTileTheme: const ListTileThemeData(
            tileColor: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreenSimple(),
          '/vendors': (context) => const EnhancedVendorListScreen(),
          '/cart': (context) => const CartScreen(),
          '/profile': (context) => const ModernProfileScreen(),
          '/supplier-dashboard': (context) => const VendorDashboardScreen(),
          '/add-product': (context) => const AddProductScreen(),
          '/sign-in': (context) => const SignInScreen(),
          '/sign-up': (context) => const SignUpScreen(),
          '/vendor-onboarding': (context) => const VendorOnboardingScreen(),
          '/messages': (context) => const MessagesScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/search': (context) => const EnhancedSearchScreen(),
          '/categories': (context) => const CategoryScreen(),
          '/order-success': (context) => const OrderSuccessScreen(),
          '/order-confirmation': (context) => const OrderSuccessScreen(),
          '/maps': (context) => const MapsScreen(),
          '/live-chat': (context) => const LiveChatScreen(),
          '/email-support': (context) => const EmailSupportScreen(),
          '/faq': (context) => const FAQScreen(),
          '/bug-report': (context) => const BugReportScreen(),
          '/send-feedback': (context) => const SendFeedbackScreen(),
          '/personal-info': (context) => const PersonalInfoScreen(),
          '/sales-analytics': (context) => const SalesAnalyticsScreen(),
          '/inventory-management': (context) => const InventoryManagementScreen(),
          '/help-center': (context) => const HelpCenterScreen(),
          '/contact-us': (context) => const ContactUsScreen(),
          '/addresses': (context) => const AddressesScreen(),
          '/wishlist': (context) => const WishlistScreen(),
          '/orders': (context) => const OrdersScreen(),
          '/terms-conditions': (context) => const TermsConditionsScreen(),
          '/privacy-policy': (context) => const PrivacyPolicyScreen(),
          '/about': (context) => const AboutScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/product-detail':
              final productId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => ProductDetailScreen(productId: productId),
              );
            case '/vendor-shop':
              final vendor = settings.arguments as VendorModel;
              return MaterialPageRoute(
                builder: (context) => VendorShopScreen(vendor: vendor),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}