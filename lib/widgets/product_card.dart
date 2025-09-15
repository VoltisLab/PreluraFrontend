import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/share_service.dart';
import '../screens/product_detail_screen.dart';
import '../utils/page_transitions.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool isCompact;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ?? () {
          Navigator.push(
            context,
            PageTransitions.heroTransition(
              ProductDetailScreen(productId: product.id),
              heroTag: 'product_${product.id}',
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    _buildProductName(),
                    const SizedBox(height: 2),
                    
                    // Price
                    _buildPriceRow(),
                    const SizedBox(height: 2),
                    
                    // Vendor name
                    _buildVendorName(),
                    
                    const Spacer(),
                    
                    // Action buttons
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: CachedNetworkImage(
              imageUrl: product.mainImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.background,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.background,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
        ),
        // Wishlist button
        Positioned(
          top: 8,
          right: 8,
          child: _buildWishlistButton(),
        ),
        // Discount badge
        if (product.hasDiscount)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.vintedCoral,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${product.discountPercentage.toInt()}% OFF',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        // Out of stock overlay
        if (!product.inStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Text(
                  'SOLD OUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductName() {
    return Text(
      product.name,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildVendorName() {
    return Text(
      product.vendor.name,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w400,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }


  Widget _buildPriceRow() {
    return Row(
      children: [
        Text(
          '£${product.finalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        if (product.hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            '£${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWishlistButton() {
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final isInWishlist = wishlistProvider.isInWishlist(product.id);
        
        return GestureDetector(
          onTap: () {
            wishlistProvider.toggleWishlist(product);
            
            // Show feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isInWishlist 
                    ? 'Removed from wishlist' 
                    : 'Added to wishlist',
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: isInWishlist 
                  ? AppColors.textSecondary 
                  : AppColors.primary,
              ),
            );
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: isInWishlist ? AppColors.vintedCoral : AppColors.textSecondary,
            ),
          ),
        );
      },
    );
  }


  Widget _buildActionButtons(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final isInCart = cartProvider.isInCart(product.id);
        
        return Row(
          children: [
            // Offer button
            Expanded(
              child: OutlinedButton(
                onPressed: product.inStock
                    ? () {
                        Navigator.pushNamed(
                          context,
                          '/offer',
                          arguments: product,
                        );
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Offer',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Add to cart button
            Expanded(
              child: ElevatedButton(
                onPressed: product.inStock
                    ? () {
                        if (isInCart) {
                          Navigator.pushNamed(context, '/cart');
                        } else {
                          cartProvider.addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart!'),
                              duration: Duration(seconds: 1),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isInCart ? 'In Cart' : 'Buy',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Share button
            GestureDetector(
              onTap: () => ShareService.shareProduct(product),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(
                  Icons.share_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
