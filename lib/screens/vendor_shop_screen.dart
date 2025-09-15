import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants/app_colors.dart';
import '../utils/country_emoji.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../providers/enhanced_product_provider.dart';
import '../widgets/product_card.dart';

class VendorShopScreen extends StatefulWidget {
  final VendorModel vendor;

  const VendorShopScreen({
    super.key,
    required this.vendor,
  });

  @override
  State<VendorShopScreen> createState() => _VendorShopScreenState();
}

class _VendorShopScreenState extends State<VendorShopScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200) {
      if (!_showScrollToTop) {
        setState(() {
          _showScrollToTop = true;
        });
      }
    } else {
      if (_showScrollToTop) {
        setState(() {
          _showScrollToTop = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: _buildVendorHeader(),
              ),
              SliverToBoxAdapter(
                child: _buildSearchAndFilters(),
              ),
              _buildProductGrid(),
            ],
          ),
          // Sticky back button in top left
          Positioned(
            top: 50, // Below status bar
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                iconSize: 24,
              ),
            ),
          ),
          // Scroll to top button - only show when scrolled
          if (_showScrollToTop)
            Positioned(
              bottom: 100, // Above bottom navigation
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: false,
      backgroundColor: AppColors.primary,
      title: const Text(''), // Empty title
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Banner background image
            Image.network(
              'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=400&fit=crop&crop=center',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            // 50% black overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            // Profile photo in bottom left corner
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.vendor.logo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white,
                      child: const Icon(
                        Icons.store,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Title positioned closer to banner bottom
            Positioned(
              bottom: 30, // Reduced from 46px to 30px
              left: 88, // Start after the 60px circle + 16px margin + 12px spacing
              right: 16,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.vendor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (widget.vendor.isVerified) ...[
                          const Icon(
                            Icons.verified,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Verified Vendor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    if (widget.vendor.rating > 0) ...[
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: widget.vendor.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 16.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.vendor.rating.toStringAsFixed(1)} (${widget.vendor.reviewCount} reviews)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      widget.vendor.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.vendor.address.city}, ${CountryEmoji.getCountryWithFlag(widget.vendor.address.country)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.vendor.categories.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.vendor.categories.map((category) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final vendorProducts = productProvider.getProductsByVendor(widget.vendor.id);
        final categories = ['All', ...{...vendorProducts.map((p) => p.category)}];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          child: Column(
            children: [
              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    borderSide: BorderSide(
                      color: AppColors.textHint.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Category filters
              if (categories.length > 1) ...[
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = _selectedCategory == category;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: AppColors.background,
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        List<ProductModel> vendorProducts = productProvider.getProductsByVendor(widget.vendor.id);
        
        // Apply filters
        if (_selectedCategory != 'All') {
          vendorProducts = vendorProducts.where((product) => product.category == _selectedCategory).toList();
        }
        
        if (_searchQuery.isNotEmpty) {
          vendorProducts = vendorProducts.where((product) =>
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description.toLowerCase().contains(_searchQuery.toLowerCase())
          ).toList();
        }

        if (vendorProducts.isEmpty) {
          return SliverToBoxAdapter(
            child: Container(
              height: 300,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: AppColors.textHint,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.52,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = vendorProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: product.id,
                    );
                  },
                );
              },
              childCount: vendorProducts.length,
            ),
          ),
        );
      },
    );
  }
}
