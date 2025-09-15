import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/wishlist_provider.dart';
import '../providers/enhanced_product_provider.dart';
import '../widgets/product_card.dart';
import '../services/share_service.dart';

enum WishlistViewType { grid, list }

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  WishlistViewType _viewType = WishlistViewType.grid;
  String _sortBy = 'Recently Added';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              if (wishlistProvider.isNotEmpty) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_viewType == WishlistViewType.grid ? Icons.view_list : Icons.grid_view),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _viewType = _viewType == WishlistViewType.grid 
                              ? WishlistViewType.list 
                              : WishlistViewType.grid;
                        });
                      },
                      tooltip: _viewType == WishlistViewType.grid ? 'List View' : 'Grid View',
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.sort),
                      onSelected: (String value) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _sortBy = value;
                        });
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem(value: 'Recently Added', child: Text('Recently Added')),
                        const PopupMenuItem(value: 'Price: Low to High', child: Text('Price: Low to High')),
                        const PopupMenuItem(value: 'Price: High to Low', child: Text('Price: High to Low')),
                        const PopupMenuItem(value: 'Name A-Z', child: Text('Name A-Z')),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => ShareService.shareWishlist(wishlistProvider.wishlistItems),
                      tooltip: 'Share Wishlist',
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_all),
                      onPressed: () => _showClearWishlistDialog(context, wishlistProvider),
                      tooltip: 'Clear All',
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          if (wishlistProvider.isEmpty) {
            return _buildEmptyWishlist();
          }
          
          return _viewType == WishlistViewType.grid 
              ? _buildWishlistGrid(wishlistProvider)
              : _buildWishlistList(wishlistProvider);
        },
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16),
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Save items you love to see them here',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistGrid(WishlistProvider wishlistProvider) {
    var items = wishlistProvider.wishlistItems;
    
    // Apply sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        items.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case 'Price: High to Low':
        items.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case 'Name A-Z':
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Recently Added':
      default:
        // Keep original order (most recently added first)
        break;
    }
    
    return Column(
      children: [
        // Wishlist count header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.divider.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${wishlistProvider.itemCount} ${wishlistProvider.itemCount == 1 ? 'item' : 'items'} saved',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'Sorted by $_sortBy',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Products grid with better constraints
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.52, // Final adjustment to eliminate overflow
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return Container(
                constraints: const BoxConstraints(
                  minHeight: 320, // Increased minimum height for new aspect ratio
                  maxHeight: 360, // Increased maximum height for new aspect ratio
                ),
                child: ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWishlistList(WishlistProvider wishlistProvider) {
    var items = wishlistProvider.wishlistItems;
    
    // Apply sorting
    switch (_sortBy) {
      case 'Price: Low to High':
        items.sort((a, b) => a.finalPrice.compareTo(b.finalPrice));
        break;
      case 'Price: High to Low':
        items.sort((a, b) => b.finalPrice.compareTo(a.finalPrice));
        break;
      case 'Name A-Z':
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Recently Added':
      default:
        // Keep original order (most recently added first)
        break;
    }
    
    return Column(
      children: [
        // Wishlist count header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.divider.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${wishlistProvider.itemCount} ${wishlistProvider.itemCount == 1 ? 'item' : 'items'} saved',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'Sorted by $_sortBy',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Products list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 120,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.mainImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.surface,
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.vendor.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '£${product.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      wishlistProvider.removeFromWishlist(product.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Removed from wishlist'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/product-detail',
                                        arguments: product.id,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(80, 36),
                                    ),
                                    child: const Text('View'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearWishlistDialog(BuildContext context, WishlistProvider wishlistProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text('Are you sure you want to remove all items from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              wishlistProvider.clearWishlist();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist cleared'),
                  backgroundColor: AppColors.textSecondary,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
