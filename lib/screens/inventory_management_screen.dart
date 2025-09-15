import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';

enum InventoryFilter { all, inStock, lowStock, outOfStock }
enum InventorySort { name, price, stock, recent }

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final int lowStockThreshold;
  final String imageUrl;
  final DateTime lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.lowStockThreshold = 10,
    required this.imageUrl,
    required this.lastUpdated,
  });

  bool get isInStock => stock > 0;
  bool get isLowStock => stock <= lowStockThreshold && stock > 0;
  bool get isOutOfStock => stock == 0;
}

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  InventoryFilter _selectedFilter = InventoryFilter.all;
  InventorySort _selectedSort = InventorySort.recent;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<InventoryItem> _inventory = [];

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  void _loadInventory() {
    _inventory = [
      InventoryItem(
        id: '1',
        name: 'Premium Cotton T-Shirt',
        category: 'Clothing',
        price: 25.99,
        stock: 45,
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300&h=300&fit=crop',
        lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InventoryItem(
        id: '2',
        name: 'Designer Denim Jacket',
        category: 'Outerwear',
        price: 89.99,
        stock: 8,
        lowStockThreshold: 10,
        imageUrl: 'https://images.unsplash.com/photo-1544966503-7cc5ac882d5e?w=300&h=300&fit=crop',
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InventoryItem(
        id: '3',
        name: 'Athletic Wear Set',
        category: 'Activewear',
        price: 79.99,
        stock: 0,
        imageUrl: 'https://images.unsplash.com/photo-1506629905607-d9a9b17f2501?w=300&h=300&fit=crop',
        lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      ),
      InventoryItem(
        id: '4',
        name: 'Vintage Leather Bag',
        category: 'Accessories',
        price: 120.00,
        stock: 23,
        imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=300&h=300&fit=crop',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _buildInventoryListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewProduct,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildInventoryListView() {
    final filteredItems = _getFilteredItems();
    
    if (filteredItems.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildInventoryCard(item),
        );
      },
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 50,
                child: Icon(
                  Icons.inventory,
                  size: 30,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search products by name or category...',
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
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter and Sort Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<InventoryFilter>(
                      value: _selectedFilter,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      onChanged: (InventoryFilter? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedFilter = newValue;
                          });
                          HapticFeedback.selectionClick();
                        }
                      },
                      items: const [
                        DropdownMenuItem(value: InventoryFilter.all, child: Text('All Products')),
                        DropdownMenuItem(value: InventoryFilter.inStock, child: Text('In Stock')),
                        DropdownMenuItem(value: InventoryFilter.lowStock, child: Text('Low Stock')),
                        DropdownMenuItem(value: InventoryFilter.outOfStock, child: Text('Out of Stock')),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<InventorySort>(
                    value: _selectedSort,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    onChanged: (InventorySort? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedSort = newValue;
                        });
                        HapticFeedback.selectionClick();
                      }
                    },
                    items: const [
                      DropdownMenuItem(value: InventorySort.recent, child: Text('Recent')),
                      DropdownMenuItem(value: InventorySort.name, child: Text('Name')),
                      DropdownMenuItem(value: InventorySort.price, child: Text('Price')),
                      DropdownMenuItem(value: InventorySort.stock, child: Text('Stock')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    final filteredItems = _getFilteredItems();
    
    if (filteredItems.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = filteredItems[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildInventoryCard(item),
            );
          },
          childCount: filteredItems.length,
        ),
      ),
    );
  }

  Widget _buildInventoryCard(InventoryItem item) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _showProductOptions(item);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surface,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildStockBadge(item),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '£${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Stock: ${item.stock}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: item.isOutOfStock 
                                ? AppColors.error 
                                : item.isLowStock 
                                    ? Colors.orange 
                                    : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
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
    );
  }

  Widget _buildStockBadge(InventoryItem item) {
    Color badgeColor;
    String badgeText;
    
    if (item.isOutOfStock) {
      badgeColor = AppColors.error;
      badgeText = 'OUT';
    } else if (item.isLowStock) {
      badgeColor = Colors.orange;
      badgeText = 'LOW';
    } else {
      badgeColor = AppColors.success;
      badgeText = 'OK';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add products to manage your inventory',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addNewProduct,
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  List<InventoryItem> _getFilteredItems() {
    var items = List<InventoryItem>.from(_inventory);
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) =>
        item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.category.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    // Apply status filter
    switch (_selectedFilter) {
      case InventoryFilter.inStock:
        items = items.where((item) => item.isInStock && !item.isLowStock).toList();
        break;
      case InventoryFilter.lowStock:
        items = items.where((item) => item.isLowStock).toList();
        break;
      case InventoryFilter.outOfStock:
        items = items.where((item) => item.isOutOfStock).toList();
        break;
      case InventoryFilter.all:
      default:
        break;
    }
    
    // Apply sorting
    switch (_selectedSort) {
      case InventorySort.name:
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case InventorySort.price:
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case InventorySort.stock:
        items.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case InventorySort.recent:
      default:
        items.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;
    }
    
    return items;
  }

  void _showProductOptions(InventoryItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: Icons.edit,
                title: 'Edit Product',
                subtitle: 'Update product details',
                onTap: () {
                  Navigator.pop(context);
                  _editProduct(item);
                },
              ),
              _buildOptionTile(
                icon: Icons.add_circle_outline,
                title: 'Update Stock',
                subtitle: 'Add or remove inventory',
                onTap: () {
                  Navigator.pop(context);
                  _updateStock(item);
                },
              ),
              _buildOptionTile(
                icon: Icons.visibility,
                title: 'View Analytics',
                subtitle: 'See product performance',
                onTap: () {
                  Navigator.pop(context);
                  _viewProductAnalytics(item);
                },
              ),
              _buildOptionTile(
                icon: Icons.delete,
                title: 'Delete Product',
                subtitle: 'Remove from inventory',
                onTap: () {
                  Navigator.pop(context);
                  _deleteProduct(item);
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isDestructive ? AppColors.error : AppColors.primary).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? AppColors.error : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewProduct() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add product feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _editProduct(InventoryItem item) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${item.name}...'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _updateStock(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) {
        final stockController = TextEditingController(text: item.stock.toString());
        
        return AlertDialog(
          title: Text('Update Stock - ${item.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Current stock: ${item.stock}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newStock = int.tryParse(stockController.text) ?? item.stock;
                setState(() {
                  final index = _inventory.indexWhere((i) => i.id == item.id);
                  if (index != -1) {
                    _inventory[index] = InventoryItem(
                      id: item.id,
                      name: item.name,
                      category: item.category,
                      price: item.price,
                      stock: newStock,
                      lowStockThreshold: item.lowStockThreshold,
                      imageUrl: item.imageUrl,
                      lastUpdated: DateTime.now(),
                    );
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Stock updated successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _viewProductAnalytics(InventoryItem item) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Analytics for ${item.name} coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _deleteProduct(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${item.name}" from your inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _inventory.removeWhere((i) => i.id == item.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted from inventory'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
