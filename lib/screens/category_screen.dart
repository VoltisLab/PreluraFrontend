import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/enhanced_product_provider.dart';
import '../widgets/product_card.dart';
import '../utils/page_transitions.dart';

class CategoryScreen extends StatefulWidget {
  final String? initialCategory;
  
  const CategoryScreen({super.key, this.initialCategory});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'All',
      'icon': Icons.grid_view,
      'color': AppColors.primary,
      'count': 0,
    },
    {
      'name': 'Dresses',
      'icon': Icons.checkroom,
      'color': Colors.pink,
      'count': 156,
    },
    {
      'name': 'Outerwear',
      'icon': Icons.ac_unit,
      'color': Colors.blue,
      'count': 89,
    },
    {
      'name': 'Bags',
      'icon': Icons.shopping_bag,
      'color': Colors.brown,
      'count': 234,
    },
    {
      'name': 'Shoes',
      'icon': Icons.sports_soccer,
      'color': Colors.orange,
      'count': 178,
    },
    {
      'name': 'Accessories',
      'icon': Icons.diamond,
      'color': Colors.purple,
      'count': 312,
    },
    {
      'name': 'Tops',
      'icon': Icons.checkroom_outlined,
      'color': Colors.green,
      'count': 267,
    },
    {
      'name': 'Bottoms',
      'icon': Icons.accessibility_new,
      'color': Colors.teal,
      'count': 145,
    },
    {
      'name': 'Jewelry',
      'icon': Icons.diamond_outlined,
      'color': Colors.amber,
      'count': 98,
    },
    {
      'name': 'Beauty',
      'icon': Icons.face,
      'color': Colors.red,
      'count': 203,
    },
    {
      'name': 'Home',
      'icon': Icons.home,
      'color': Colors.indigo,
      'count': 167,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        // This will trigger a rebuild when tab changes
      });
    });
    
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryGrid(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(),
                _buildSuppliersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildFilterButton('Products', 0),
          _buildFilterButton('Suppliers', 1),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search in $_selectedCategory...',
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Browse Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.1,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category['name'];
                  });
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category['icon'],
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        final products = productProvider.products.where((product) {
          final matchesCategory = _selectedCategory == 'All' || 
              product.category.toLowerCase() == _selectedCategory.toLowerCase();
          final matchesSearch = _searchQuery.isEmpty || 
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              product.description.toLowerCase().contains(_searchQuery.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        if (products.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.54,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/product-detail',
                  arguments: product,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSuppliersTab() {
    return Consumer<EnhancedProductProvider>(
      builder: (context, productProvider, child) {
        // For now, show empty state until suppliers are implemented
        return _buildEmptyState();
      },
    );
  }


  Widget _buildEmptyState() {
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
            _searchQuery.isNotEmpty 
                ? 'No results found for "$_searchQuery"'
                : 'No items in $_selectedCategory',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search or category',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
