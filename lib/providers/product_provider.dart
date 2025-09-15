import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<ProductModel> get products => _products;
  List<ProductModel> get featuredProducts => _featuredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = _products;
    
    if (_selectedCategory != 'All') {
      filtered = filtered.where((product) => product.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) => 
        product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        product.vendor.name.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    setLoading(true);
    setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data
      _products = _generateMockProducts();
      _featuredProducts = _products.where((product) => product.isFeatured).toList();
      _categories = ['All', ...{..._products.map((product) => product.category)}];
      
      setLoading(false);
    } catch (e) {
      setError('Failed to load products: ${e.toString()}');
      setLoading(false);
    }
  }

  ProductModel? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<ProductModel> getProductsByVendor(String vendorId) {
    return _products.where((product) => product.vendor.id == vendorId).toList();
  }

  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<ProductModel> _generateMockProducts() {
    final mockVendors = [
      VendorModel(
        id: '1',
        name: 'Vintage Fashion Co',
        description: 'Premium vintage and second-hand fashion',
        logo: 'https://via.placeholder.com/80',
        email: 'contact@vintagefashion.com',
        phone: '+1234567890',
        address: AddressModel(
          id: '1',
          street: '123 Fashion Street',
          city: 'San Francisco',
          state: 'CA',
          zipCode: '94105',
          country: 'USA',
        ),
        rating: 4.8,
        reviewCount: 1250,
        isVerified: true,
        createdAt: DateTime.now(),
        categories: ['Fashion', 'Vintage'],
      ),
      VendorModel(
        id: '2',
        name: 'Fashion Hub',
        description: 'Trendy fashion and accessories',
        logo: 'https://via.placeholder.com/80',
        email: 'info@fashionhub.com',
        phone: '+1234567891',
        address: AddressModel(
          id: '2',
          street: '456 Fashion Ave',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
        ),
        rating: 4.6,
        reviewCount: 890,
        isVerified: true,
        createdAt: DateTime.now(),
        categories: ['Fashion', 'Accessories'],
      ),
      VendorModel(
        id: '3',
        name: 'Home & Garden',
        description: 'Everything for your home and garden',
        logo: 'https://via.placeholder.com/80',
        email: 'support@homegarden.com',
        phone: '+1234567892',
        address: AddressModel(
          id: '3',
          street: '789 Garden Blvd',
          city: 'Austin',
          state: 'TX',
          zipCode: '73301',
          country: 'USA',
        ),
        rating: 4.4,
        reviewCount: 567,
        isVerified: true,
        createdAt: DateTime.now(),
        categories: ['Home', 'Garden'],
      ),
    ];

    return [
      ProductModel(
        id: '1',
        name: 'Vintage Leather Jacket',
        description: 'Classic 1980s genuine leather jacket in excellent condition',
        price: 299.99,
        discountPrice: 249.99,
        images: [
          'https://via.placeholder.com/300x300?text=Vintage+Leather+Jacket',
          'https://via.placeholder.com/300x300?text=Vintage+Leather+Jacket+2',
        ],
        category: 'Fashion',
        subcategory: 'Outerwear',
        vendor: mockVendors[0],
        stockQuantity: 5,
        rating: 4.8,
        reviewCount: 324,
        tags: ['vintage', 'leather', 'jacket', '1980s'],
        isFeatured: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '2',
        name: 'Designer Handbag',
        description: 'Luxury leather handbag with premium craftsmanship',
        price: 299.99,
        images: [
          'https://via.placeholder.com/300x300?text=Designer+Handbag',
          'https://via.placeholder.com/300x300?text=Handbag+2',
        ],
        category: 'Fashion',
        subcategory: 'Bags',
        vendor: mockVendors[1],
        stockQuantity: 25,
        rating: 4.6,
        reviewCount: 156,
        tags: ['handbag', 'luxury', 'leather'],
        isFeatured: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '3',
        name: 'Smart Garden Kit',
        description: 'Automated hydroponic garden system for indoor growing',
        price: 199.99,
        discountPrice: 149.99,
        images: [
          'https://via.placeholder.com/300x300?text=Smart+Garden',
          'https://via.placeholder.com/300x300?text=Garden+Kit+2',
        ],
        category: 'Home',
        subcategory: 'Garden',
        vendor: mockVendors[2],
        stockQuantity: 15,
        rating: 4.4,
        reviewCount: 89,
        tags: ['garden', 'smart', 'hydroponic'],
        isFeatured: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '4',
        name: 'Vintage Band T-Shirt',
        description: 'Authentic 1990s band t-shirt in great condition',
        price: 45.99,
        images: [
          'https://via.placeholder.com/300x300?text=Vintage+Band+Tee',
        ],
        category: 'Fashion',
        subcategory: 'T-Shirts',
        vendor: mockVendors[0],
        stockQuantity: 8,
        rating: 4.7,
        reviewCount: 234,
        tags: ['vintage', 'band', 'tshirt', '1990s'],
        isFeatured: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductModel(
        id: '5',
        name: 'Summer Dress',
        description: 'Elegant summer dress perfect for any occasion',
        price: 89.99,
        discountPrice: 69.99,
        images: [
          'https://via.placeholder.com/300x300?text=Summer+Dress',
        ],
        category: 'Fashion',
        subcategory: 'Dresses',
        vendor: mockVendors[1],
        stockQuantity: 40,
        rating: 4.5,
        reviewCount: 178,
        tags: ['dress', 'summer', 'elegant'],
        isFeatured: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
