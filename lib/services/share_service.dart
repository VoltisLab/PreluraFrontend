import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product_model.dart';

class ShareService {
  static const String _appName = 'Arc Vest Marketplace';
  static const String _appUrl = 'https://arcvest.com'; // Replace with actual app URL
  
  /// Share a product with details
  static Future<void> shareProduct(ProductModel product) async {
    final String text = '''
🛍️ Check out this amazing product on $_appName!

📦 ${product.name}
💰 \$${product.finalPrice.toStringAsFixed(2)}${product.hasDiscount ? ' (${product.discountPercentage.toInt()}% OFF!)' : ''}
🏪 From ${product.vendor.name}
⭐ ${product.rating.toStringAsFixed(1)} stars

${product.description.length > 100 ? '${product.description.substring(0, 100)}...' : product.description}

Get it now on $_appName! 
$_appUrl
''';

    try {
      await Share.share(
        text,
        subject: '${product.name} - $_appName',
      );
    } catch (e) {
      // Handle sharing error silently or show error message
      print('Error sharing product: $e');
    }
  }

  /// Share a vendor/supplier
  static Future<void> shareVendor(VendorModel vendor) async {
    final String text = '''
🏪 Discover this amazing supplier on $_appName!

🏢 ${vendor.name}
📍 ${vendor.address.city}, ${vendor.address.country}
⭐ ${vendor.rating.toStringAsFixed(1)} stars (${vendor.reviewCount} reviews)
✅ ${vendor.isVerified ? 'Verified Supplier' : 'Supplier'}

${vendor.description.length > 100 ? '${vendor.description.substring(0, 100)}...' : vendor.description}

Categories: ${vendor.categories.take(3).join(', ')}${vendor.categories.length > 3 ? '...' : ''}

Find quality suppliers on $_appName!
$_appUrl
''';

    try {
      await Share.share(
        text,
        subject: '${vendor.name} - $_appName',
      );
    } catch (e) {
      print('Error sharing vendor: $e');
    }
  }

  /// Share the app itself
  static Future<void> shareApp() async {
    const String text = '''
🛍️ Discover $_appName - Your B2B Wholesale Marketplace!

✨ Features:
• Browse thousands of wholesale products
• Connect with verified suppliers worldwide
• Secure payments and fast shipping
• Interactive maps to find local vendors
• Wishlist and cart functionality

Download now and start your wholesale journey!
$_appUrl

#Wholesale #B2B #Marketplace #Business
''';

    try {
      await Share.share(
        text,
        subject: '$_appName - B2B Wholesale Marketplace',
      );
    } catch (e) {
      print('Error sharing app: $e');
    }
  }

  /// Share a custom message with optional subject
  static Future<void> shareCustom({
    required String text,
    String? subject,
    List<String>? files,
  }) async {
    try {
      if (files != null && files.isNotEmpty) {
        await Share.shareXFiles(
          files.map((path) => XFile(path)).toList(),
          text: text,
          subject: subject,
        );
      } else {
        await Share.share(
          text,
          subject: subject,
        );
      }
    } catch (e) {
      print('Error sharing custom content: $e');
    }
  }

  /// Share with specific position (for tablets/desktop)
  static Future<void> shareWithPosition({
    required String text,
    String? subject,
    required Rect sharePositionOrigin,
  }) async {
    try {
      await Share.share(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } catch (e) {
      print('Error sharing with position: $e');
    }
  }

  /// Share a wishlist
  static Future<void> shareWishlist(List<ProductModel> wishlistItems) async {
    if (wishlistItems.isEmpty) {
      await shareApp();
      return;
    }

    final String productList = wishlistItems
        .take(5) // Limit to first 5 items
        .map((product) => '• ${product.name} - \$${product.finalPrice.toStringAsFixed(2)}')
        .join('\n');

    final String text = '''
💖 Check out my wishlist on $_appName!

🛍️ My favorite products:
$productList${wishlistItems.length > 5 ? '\n...and ${wishlistItems.length - 5} more items!' : ''}

Total: ${wishlistItems.length} amazing products waiting for me!

Join me on $_appName and create your own wishlist!
$_appUrl
''';

    try {
      await Share.share(
        text,
        subject: 'My Wishlist - $_appName',
      );
    } catch (e) {
      print('Error sharing wishlist: $e');
    }
  }

  /// Share search results
  static Future<void> shareSearchResults({
    required String searchQuery,
    required int resultCount,
  }) async {
    final String text = '''
🔍 Found amazing results on $_appName!

Search: "$searchQuery"
Results: $resultCount products found

Discover wholesale products and suppliers on $_appName!
$_appUrl
''';

    try {
      await Share.share(
        text,
        subject: 'Search Results - $_appName',
      );
    } catch (e) {
      print('Error sharing search results: $e');
    }
  }
}
