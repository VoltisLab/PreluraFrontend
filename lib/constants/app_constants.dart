class AppConstants {
  // App Info
  static const String appName = 'Prelura';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (Mock for UI-only version)
  static const String baseUrl = 'https://api.prelura.com';
  static const String productsEndpoint = '/products';
  static const String vendorsEndpoint = '/vendors';
  static const String ordersEndpoint = '/orders';
  static const String usersEndpoint = '/users';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Image Sizes
  static const double productImageSize = 120.0;
  static const double vendorLogoSize = 80.0;
  static const double profileImageSize = 100.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  
  // User Types
  static const String userTypeCustomer = 'customer';
  static const String userTypeVendor = 'vendor';
  static const String userTypeAdmin = 'admin';
  
  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusProcessing = 'processing';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';
  
  // Payment Status
  static const String paymentStatusPending = 'pending';
  static const String paymentStatusCompleted = 'completed';
  static const String paymentStatusFailed = 'failed';
  static const String paymentStatusRefunded = 'refunded';
}
