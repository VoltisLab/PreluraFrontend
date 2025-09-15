import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  
  CartItem({
    required this.product,
    this.quantity = 1,
  });
  
  double get totalPrice => product.finalPrice * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  
  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    // Haptic feedback for adding to cart
    HapticFeedback.mediumImpact();
    
    notifyListeners();
  }
  
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    
    // Haptic feedback for removing from cart
    HapticFeedback.heavyImpact();
    
    notifyListeners();
  }
  
  void updateQuantity(String productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
        // Haptic feedback for removing item
        HapticFeedback.heavyImpact();
      } else {
        _items[index].quantity = quantity;
        // Haptic feedback for quantity change
        HapticFeedback.lightImpact();
      }
      notifyListeners();
    }
  }
  
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    
    if (index >= 0) {
      _items[index].quantity++;
      
      // Haptic feedback for increasing quantity
      HapticFeedback.lightImpact();
      
      notifyListeners();
    }
  }
  
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        // Haptic feedback for decreasing quantity
        HapticFeedback.lightImpact();
      } else {
        _items.removeAt(index);
        // Haptic feedback for removing item completely
        HapticFeedback.heavyImpact();
      }
      notifyListeners();
    }
  }
  
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
  
  int getQuantity(String productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: ProductModel(
        id: '',
        name: '',
        description: '',
        price: 0,
        images: [],
        category: '',
        subcategory: '',
        vendor: VendorModel(
          id: '',
          name: '',
          description: '',
          logo: '',
          email: '',
          phone: '',
          address: AddressModel(
            id: '',
            street: '',
            city: '',
            state: '',
            zipCode: '',
            country: '',
          ),
          createdAt: DateTime.now(),
        ),
        stockQuantity: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ), quantity: 0),
    );
    return item.quantity;
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
  
  Map<String, List<CartItem>> get itemsByVendor {
    final Map<String, List<CartItem>> vendorItems = {};
    
    for (final item in _items) {
      final vendorId = item.product.vendor.id;
      if (vendorItems.containsKey(vendorId)) {
        vendorItems[vendorId]!.add(item);
      } else {
        vendorItems[vendorId] = [item];
      }
    }
    
    return vendorItems;
  }
  
  double getVendorTotal(String vendorId) {
    return _items
        .where((item) => item.product.vendor.id == vendorId)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  // Mock checkout process
  Future<bool> checkout() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Clear cart after successful checkout
      clearCart();
      
      return true;
    } catch (e) {
      return false;
    }
  }
}
