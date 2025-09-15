import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _wishlistItems = [];
  
  List<ProductModel> get wishlistItems => List.unmodifiable(_wishlistItems);
  int get itemCount => _wishlistItems.length;
  bool get isEmpty => _wishlistItems.isEmpty;
  bool get isNotEmpty => _wishlistItems.isNotEmpty;
  
  bool isInWishlist(String productId) {
    return _wishlistItems.any((product) => product.id == productId);
  }
  
  void addToWishlist(ProductModel product) {
    if (!isInWishlist(product.id)) {
      _wishlistItems.add(product);
      notifyListeners();
    }
  }
  
  void removeFromWishlist(String productId) {
    _wishlistItems.removeWhere((product) => product.id == productId);
    notifyListeners();
  }
  
  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }
  
  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
  
  List<ProductModel> getWishlistByCategory(String category) {
    if (category == 'All') {
      return wishlistItems;
    }
    return _wishlistItems.where((product) => product.category == category).toList();
  }
  
  List<String> getWishlistCategories() {
    final categories = _wishlistItems.map((product) => product.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }
}
