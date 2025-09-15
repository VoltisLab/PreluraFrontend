import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/enhanced_product_provider.dart';
import '../providers/vendor_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/vendor_card.dart';
import '../services/image_search_service.dart';

class EnhancedSearchScreen extends StatefulWidget {
  const EnhancedSearchScreen({super.key});

  @override
  State<EnhancedSearchScreen> createState() => _EnhancedSearchScreenState();
}

class _EnhancedSearchScreenState extends State<EnhancedSearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _searchQuery = '';
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;
  
  void scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
  
  // Product names for autocomplete (from your provided list)
  final List<String> _productSuggestions = [
    'The North Face Denali Fleece Jackets',
    'Y2K Leather Bomber Jackets',
    'Patagonia Retro-X Fleece',
    'Ralph Lauren Harrington Jackets',
    'Carhartt Work Jackets',
    'Nike Windbreakers',
    'Adidas 90s Track Jackets',
    'Tommy Hilfiger Sailing Jackets',
    'Vintage Varsity Jackets',
    'Columbia Sportswear Fleece Jackets',
    'Polo Ralph Lauren Heavyweight Sweaters',
    'Ralph Lauren 1/4 Zip Sweaters',
    'Lacoste Knitted Sweaters',
    'Patagonia Snap-T Pullovers',
    'Nike Tech Fleece Hoodies',
    'Champion Reverse Weave Hoodies',
    'Adidas 90s Sweatshirts',
    'Harley Davidson Sweatshirts',
    'Carhartt Hoodies',
    'Stüssy Streetwear Hoodies',
    'Vintage Harley Davidson Graphic Tees',
    'Y2K Band T-Shirts',
    'Nike Dri-Fit T-Shirts',
    'Adidas Logo Tees',
    'Polo Ralph Lauren Polo Shirts',
    'Burberry Nova Check Shirts',
    'Carhartt Workwear Tees',
    'Levi\'s Graphic T-Shirts',
    'Hard Rock Café Tees',
    'Sports Jerseys',
    'Levi\'s 501 Jeans',
    'Carhartt Double Knee Work Pants',
    'Dickies 874 Work Pants',
    'Wrangler Cowboy Cut Jeans',
    'Vintage Cargo Pants',
    'Nike Track Pants',
    'Adidas Tearaway Pants',
    'Jordan Basketball Shorts',
    'Vintage Workwear Overalls',
    'Supreme Hoodies',
  ];

  final List<String> _searchTags = [
    'Streetwear', 'Vintage', 'Y2K', 'Workwear', 'Athletic', 'Denim', 'Fleece', 'Hoodies'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        // This will trigger a rebuild when tab changes
      });
    });
    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _searchFocusNode.hasFocus && _searchQuery.isEmpty;
      });
    });
    
    // Auto-focus the search bar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty) {
        _filteredSuggestions = _productSuggestions
            .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
            .take(8)
            .toList();
        _showSuggestions = true;
      } else {
        _filteredSuggestions = [];
        _showSuggestions = _searchFocusNode.hasFocus;
      }
    });
  }

  void _selectSuggestion(String suggestion) {
    setState(() {
      _searchController.text = suggestion;
      _searchQuery = suggestion;
      _showSuggestions = false;
    });
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(
          'Search',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_showSuggestions) _buildSuggestions(),
          if (!_showSuggestions && _searchQuery.isEmpty) _buildSearchTags(),
          if (!_showSuggestions && _searchQuery.isNotEmpty) _buildTabBar(),
          if (!_showSuggestions && _searchQuery.isNotEmpty)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllTab(),
                  _buildProductsTab(),
                  _buildSuppliersTab(),
                ],
              ),
            ),
          if (!_showSuggestions && _searchQuery.isEmpty)
            Expanded(child: _buildEmptyState()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium, 
        0, 
        AppConstants.paddingMedium, 
        AppConstants.paddingMedium
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _searchFocusNode.hasFocus 
              ? AppColors.primary 
              : AppColors.divider, 
          width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
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
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt, color: AppColors.primary),
                onPressed: _handleImageSearch,
                tooltip: 'Search by image',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              ),
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    if (_searchQuery.isEmpty) {
      return _buildRecentSearches();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_filteredSuggestions.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Suggestions',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ..._filteredSuggestions.map((suggestion) => _buildSuggestionItem(suggestion)),
          ],
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Popular Searches',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _productSuggestions.take(8).length,
            itemBuilder: (context, index) {
              final suggestion = _productSuggestions[index];
              return _buildSuggestionThumbnail(suggestion);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String suggestion) {
    return InkWell(
      onTap: () => _selectSuggestion(suggestion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.north_west, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionThumbnail(String suggestion) {
    return InkWell(
      onTap: () => _selectSuggestion(suggestion),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.divider.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                suggestion,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchTags() {
    return Container(
      margin: const EdgeInsets.only(
        left: 0.0, // Removed left padding to align with search bar
        right: AppConstants.paddingMedium,
        bottom: AppConstants.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _searchTags.map((tag) => _buildSearchTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTag(String tag) {
    return InkWell(
      onTap: () => _selectSuggestion(tag),
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
        child: Text(
          tag,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildFilterButton('All', 0),
          _buildFilterButton('Products', 1),
          _buildFilterButton('Sellers', 2),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, int index) {
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
          HapticFeedback.selectionClick();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllTab() {
    return Consumer2<EnhancedProductProvider, VendorProvider>(
      builder: (context, productProvider, vendorProvider, child) {
        final products = productProvider.products
            .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
        final vendors = vendorProvider.vendors
            .where((v) => v.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (products.isEmpty && vendors.isEmpty) {
          return _buildNoResults();
        }

        return CustomScrollView(
          slivers: [
            if (products.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingMedium,
                  AppConstants.paddingMedium,
                  AppConstants.paddingMedium,
                  12,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Products (${products.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.54,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCard(
                      product: products[index],
                      onTap: () {},
                    ),
                    childCount: products.take(4).length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
            if (vendors.isNotEmpty) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.paddingMedium,
                  0,
                  AppConstants.paddingMedium,
                  12,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Suppliers (${vendors.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: VendorCard(vendor: vendors[index]),
                    ),
                    childCount: vendors.take(3).length,
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: AppConstants.paddingMedium)),
          ],
        );
      },
    );
  }

  Widget _buildProductsTab() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products
            .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (products.isEmpty) {
          return _buildNoResults();
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.54,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ProductCard(
                    product: products[index],
                    onTap: () {},
                  ),
                  childCount: products.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuppliersTab() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, child) {
        final vendors = vendorProvider.vendors
            .where((v) => v.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (vendors.isEmpty) {
          return _buildNoResults();
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: VendorCard(vendor: vendors[index]),
                  ),
                  childCount: vendors.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for products and suppliers',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for brands, categories, or specific items',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "$_searchQuery"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or check your spelling',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleImageSearch() async {
    // Simple placeholder for now
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image search coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
