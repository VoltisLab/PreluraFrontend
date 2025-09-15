import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vendor_provider.dart';
import '../providers/enhanced_product_provider.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';
import '../utils/page_transitions.dart';
import 'enhanced_search_screen.dart';
import 'enhanced_vendor_list_screen.dart';
import 'cart_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import 'modern_profile_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'home_screen.dart';

class HomeScreenSimple extends StatefulWidget {
  const HomeScreenSimple({super.key});

  @override
  State<HomeScreenSimple> createState() => _HomeScreenSimpleState();
}

class _HomeScreenSimpleState extends State<HomeScreenSimple> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _feedScrollController = ScrollController();
  final PageController _bannerPageController = PageController();
  int _currentBannerIndex = 0;
  

  @override
  void dispose() {
    _searchController.dispose();
    _feedScrollController.dispose();
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildFeedTab(),
          const EnhancedSearchScreen(),
          const MessagesScreen(),
          authProvider.isSupplier ? const VendorDashboardScreen() : const ModernProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFeedTab() {
    return CustomScrollView(
      controller: _feedScrollController,
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildSearchTags(),
              const SizedBox(height: 24),
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              _buildSliderBanner(),
              const SizedBox(height: 24),
              _buildTrendingProducts(),
              const SizedBox(height: 24),
              _buildCategoryShowcase(),
              const SizedBox(height: 24),
              _buildFeaturedVendors(),
              const SizedBox(height: 16),
              _buildRecentlyAdded(),
              const SizedBox(height: 16),
              _buildPopularProducts(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return SliverAppBar(
          floating: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Prelura',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.pushNamed(context, '/wishlist');
              },
              tooltip: 'Wishlist',
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () {
                Navigator.pushNamed(context, '/messages');
              },
              tooltip: 'Messages',
            ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }

  Widget _buildTrendingProducts() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final trendingProducts = productProvider.products.take(8).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Now',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/search');
                    },
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                itemCount: trendingProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: ProductCard(product: trendingProducts[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.vintedGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Fashion',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find unique pieces from sellers worldwide',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransitions.slideFromBottom(const EnhancedVendorListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Shopping',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.explore, color: Colors.white, size: 24),
                  onPressed: () {
                    Navigator.pushNamed(context, '/maps');
                  },
                  tooltip: 'Explore',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedVendors() {
    return Consumer2<VendorProvider, EnhancedProductProvider>(
      builder: (context, vendorProvider, productProvider, child) {
        final featuredVendors = vendorProvider.vendors.where((v) => v.isVerified).take(4).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: const Text(
                'Featured Collections',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280, // Increased height for gallery design
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                itemCount: featuredVendors.length,
                itemBuilder: (context, index) {
                  final vendor = featuredVendors[index];
                  final vendorProducts = productProvider.products
                      .where((p) => p.vendor.id == vendor.id)
                      .take(4)
                      .toList();
                  
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: _buildVendorGalleryCard(vendor, vendorProducts),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVendorGalleryCard(VendorModel vendor, List<ProductModel> products) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/vendor-shop',
          arguments: vendor,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.divider.withOpacity(0.3),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor header with logo and name
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6), // Reduced vertical padding
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: vendor.logo,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.divider,
                          child: const Icon(Icons.store, size: 20),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.divider,
                          child: const Icon(Icons.store, size: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendor.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.warning, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              vendor.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (vendor.isVerified)
                    const Icon(Icons.verified, color: AppColors.primary, size: 16),
                ],
              ),
            ),
            
            // Product gallery grid (2x2)
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8), // Reduced bottom padding
                child: products.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: AppColors.divider.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No products',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0, // Square aspect ratio for 2x2 grid
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          if (index < products.length) {
                            final product = products[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.divider.withOpacity(0.3)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: product.images.first,
                                  fit: BoxFit.cover, // Cover to fill the square space properly
                                  placeholder: (context, url) => Container(
                                    color: AppColors.divider.withOpacity(0.3),
                                    child: const Center(
                                      child: Icon(Icons.image, size: 16, color: AppColors.textSecondary),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: AppColors.divider.withOpacity(0.3),
                                    child: const Center(
                                      child: Icon(Icons.broken_image, size: 16, color: AppColors.textSecondary),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Empty placeholder
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.divider.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.divider.withOpacity(0.3)),
                              ),
                              child: const Center(
                                child: Icon(Icons.add, size: 20, color: AppColors.textSecondary),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ),
            
            // View collection button
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Text(
                  'View Collection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryShowcase() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final categories = ['Dresses', 'Outerwear', 'Bags', 'Shoes', 'Accessories', 'Tops'];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Shop by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final color = _getCategoryColor(index);
                  
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/categories',
                          arguments: category,
                        );
                      },
                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  color.withOpacity(0.8),
                                  color.withOpacity(0.6),
                                ],
                              ),
                            ),
                            child:                             ClipRRect(
                              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: _getCategoryClothingImage(category),
                                    fit: BoxFit.cover,
                                  ),
                                  // Enhanced overlay for better text readability
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.3),
                                          Colors.black.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 8,
                            right: 8,
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentlyAdded() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final recentProducts = productProvider.products.skip(20).take(6).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Text(
                'Recently Added',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.52, // Final adjustment to eliminate remaining overflow
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 18,
                ),
                itemCount: recentProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: recentProducts[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopularProducts() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final popularProducts = productProvider.products.skip(50).take(4).toList();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Text(
                'Popular This Week',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.52, // Final adjustment to eliminate remaining overflow
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 18,
                ),
                itemCount: popularProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: popularProducts[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.info,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
    ];
    return colors[index % colors.length];
  }

  String _getCategoryClothingImage(String category) {
    // Category-specific clothing pile images
    switch (category) {
      case 'Dresses':
        return 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=300&h=300&fit=crop&crop=center';
      case 'Outerwear':
        return 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=300&fit=crop&crop=center';
      case 'Bags':
        return 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop&crop=center';
      case 'Shoes':
        return 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300&h=300&fit=crop&crop=center';
      case 'Accessories':
        return 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=300&h=300&fit=crop&crop=center';
      case 'Tops':
        return 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=300&h=300&fit=crop&crop=center';
      default:
        return 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=300&h=300&fit=crop&crop=center';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dresses':
        return Icons.checkroom_rounded;
      case 'Outerwear':
        return Icons.dry_cleaning_rounded;
      case 'Bags':
        return Icons.shopping_bag_rounded;
      case 'Shoes':
        return Icons.directions_walk_rounded;
      case 'Accessories':
        return Icons.watch_rounded;
      case 'Tops':
        return Icons.checkroom_rounded;
      case 'Vintage':
        return Icons.history_rounded;
      case 'Fashion':
        return Icons.shopping_bag_rounded;
      case 'Home':
        return Icons.home_rounded;
      case 'Beauty':
        return Icons.face_rounded;
      case 'Sports':
        return Icons.sports_soccer_rounded;
      case 'Books':
        return Icons.book_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  void _scrollToTop(int index) {
    // If tapping the same tab, scroll to top
    if (index == _currentIndex) {
      switch (index) {
        case 0: // Feed
          _feedScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          break;
      }
    }
  }

  Widget _buildBottomNavigationBar() {
    final authProvider = context.watch<AuthProvider>();
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          HapticFeedback.selectionClick();
          if (index == 2) {
            // Navigate to Add Product screen instead of staying in bottom nav
            Navigator.pushNamed(context, '/add-product');
            return;
          }
          // Adjust index for cart and profile since we removed the vendor list
          int adjustedIndex = index;
          if (index > 2) {
            adjustedIndex = index - 1;
          }
          _scrollToTop(adjustedIndex);
          setState(() => _currentIndex = adjustedIndex);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Sell',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(authProvider.isSupplier ? Icons.storefront_outlined : Icons.account_circle_outlined),
            activeIcon: Icon(authProvider.isSupplier ? Icons.storefront : Icons.account_circle),
            label: authProvider.isSupplier ? 'Sell' : 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pushNamed(context, '/search');
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: 'Search for items, brands, styles...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 16,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTags() {
    final suggestedTags = [
      'Dresses', 'Jackets', 'Shoes', 'Bags', 'Vintage', 'Designer', 'Streetwear', 'Accessories'
    ];

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        itemCount: suggestedTags.length,
        itemBuilder: (context, index) {
          final tag = suggestedTags[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/search');
              },
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.divider, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildSliderBanner() {
    return Consumer2<EnhancedProductProvider, VendorProvider>(
      builder: (context, productProvider, vendorProvider, child) {
        final bannerItems = <Map<String, dynamic>>[];
        
        // Add 3 featured products
        final featuredProducts = productProvider.products.where((p) => p.isFeatured).take(3).toList();
        for (final product in featuredProducts) {
          bannerItems.add({
            'type': 'product',
            'title': product.name,
            'subtitle': 'From ${product.vendor.name}',
            'image': product.images.first,
            'data': product,
          });
        }
        
        // Add 2 featured vendors
        final featuredVendors = vendorProvider.vendors.where((v) => v.isVerified).take(2).toList();
        for (final vendor in featuredVendors) {
          bannerItems.add({
            'type': 'vendor',
            'title': vendor.name,
            'subtitle': '${vendor.categories.join(', ')} Specialist',
            'image': vendor.logo,
            'data': vendor,
          });
        }

        return Column(
          children: [
            SizedBox(
              height: 220, // Increased height similar to welcome banner
              child: PageView.builder(
                controller: _bannerPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemCount: bannerItems.length,
            itemBuilder: (context, index) {
              final item = bannerItems[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primary.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: item['type'] == 'product' 
                              ? item['image'] 
                              : 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=400&fit=crop&crop=center', // HD clothing pile for vendor banners
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.overlay,
                          color: Colors.black.withOpacity(0.3),
                          placeholder: (context, url) => Container(
                            color: AppColors.primary.withOpacity(0.1),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.primary.withOpacity(0.2),
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    ),
                    // Content overlay - no text as requested
                  ],
                ),
              );
            },
              ),
            ),
            // Navigation dots
            if (bannerItems.length > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  bannerItems.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentBannerIndex == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentBannerIndex == index
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

