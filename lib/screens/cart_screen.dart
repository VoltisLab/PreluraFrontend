import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart();
          }

          return Column(
            children: [
              Expanded(
                child: _buildCartItems(cartProvider),
              ),
              _buildCheckoutSection(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(CartProvider cartProvider) {
    final itemsByVendor = cartProvider.itemsByVendor;

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: itemsByVendor.length,
      itemBuilder: (context, index) {
        final vendorId = itemsByVendor.keys.elementAt(index);
        final items = itemsByVendor[vendorId]!;
        final vendor = items.first.product.vendor;

        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor header (clickable)
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(
                    context,
                    '/vendor-shop',
                    arguments: vendor,
                  );
                },
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusLarge),
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.store, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vendor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        '£${cartProvider.getVendorTotal(vendorId).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Items
              ...items.map((item) => _buildCartItem(context, item, cartProvider)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cartProvider) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.pushNamed(
          context,
          '/product-detail',
          arguments: item.product.id,
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: CachedNetworkImage(
              imageUrl: item.product.mainImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 60,
                height: 60,
                color: AppColors.background,
                child: const Icon(Icons.image),
              ),
              errorWidget: (context, url, error) => Container(
                width: 60,
                height: 60,
                color: AppColors.background,
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '£${item.product.finalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity controls
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: () => cartProvider.decrementQuantity(item.product.id),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item.quantity.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: () => cartProvider.incrementQuantity(item.product.id),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Remove button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => cartProvider.removeItem(item.product.id),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${cartProvider.itemCount} items)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '£${cartProvider.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cartProvider.items.isEmpty 
                    ? null 
                    : () => Navigator.pushNamed(context, '/checkout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
