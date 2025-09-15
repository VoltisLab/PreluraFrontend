import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/product_model.dart';

class EnhancedProductProvider extends ChangeNotifier {
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
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setLoading(true);
      setError(null);
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Generate 1000 products (20 per vendor for 50 vendors)
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
    final List<ProductModel> allProducts = [];
    
    // Generate 20 products for each of the 50 vendors
    for (int vendorIndex = 1; vendorIndex <= 50; vendorIndex++) {
      final vendor = _createVendorForProducts(vendorIndex);
      
      for (int productIndex = 1; productIndex <= 20; productIndex++) {
        final productId = '${vendorIndex}_$productIndex';
        final product = _createProductForVendor(productId, vendor, productIndex);
        allProducts.add(product);
      }
    }
    
    return allProducts;
  }

  VendorModel _createVendorForProducts(int vendorIndex) {
    final vendorData = _getVendorData(vendorIndex);
    
    return VendorModel(
      id: vendorIndex.toString(),
      name: vendorData['name'],
      description: 'Premium ${vendorData['category'].toLowerCase()} products and services.',
      logo: 'https://picsum.photos/80/80?random=${vendorIndex + 500}',
      email: '${vendorData['name'].toLowerCase().replaceAll(' ', '').replaceAll('&', '')}@example.com',
      phone: '+44 ${(1000 + vendorIndex * 7).toString().padLeft(4, '0')} ${(100000 + vendorIndex * 123).toString().padLeft(6, '0')}',
      address: AddressModel(
        id: vendorIndex.toString(),
        street: '${100 + vendorIndex * 10} ${vendorData['category']} Street',
        city: _getCapitalCity(vendorData['country']),
        state: _getStateFromCountry(vendorData['country']),
        zipCode: _getPostcodeFromCountry(vendorData['country'], vendorIndex),
        country: vendorData['country'] ?? 'China',
      ),
      rating: vendorData['rating'].toDouble(),
      reviewCount: vendorData['reviews'],
      isVerified: vendorIndex % 3 == 0,
      createdAt: DateTime.now().subtract(Duration(days: 30 + vendorIndex * 10)),
      categories: [vendorData['category']],
    );
  }

  ProductModel _createProductForVendor(String productId, VendorModel vendor, int productIndex) {
    final productData = _getProductDataForCategory(vendor.categories.first, productIndex);
    final basePrice = productData['basePrice'] + (productIndex * 10.0);
    final hasDiscount = productIndex % 4 == 0;
    
    return ProductModel(
      id: productId,
      name: productData['name'],
      description: productData['description'],
      price: basePrice,
      discountPrice: hasDiscount ? basePrice * 0.8 : null,
      images: _getProductImages(vendor.categories.first, productIndex),
      category: vendor.categories.first,
      subcategory: productData['subcategory'],
      vendor: vendor,
      stockQuantity: 10 + (productIndex * 2),
      rating: 3.5 + (productIndex % 5) * 0.3,
      reviewCount: 50 + (productIndex * 15),
      tags: productData['tags'],
      isFeatured: productIndex <= 3, // First 3 products are featured
      createdAt: DateTime.now().subtract(Duration(days: productIndex * 5)),
      updatedAt: DateTime.now().subtract(Duration(days: productIndex)),
    );
  }

  Map<String, dynamic> _getVendorData(int index) {
    final vendorData = [
      {'name': 'Retro Revival Fashion', 'category': 'Fashion', 'country': 'China', 'rating': 4.8, 'reviews': 1250},
      {'name': 'Vintage Threads & Co', 'category': 'Fashion', 'country': 'India', 'rating': 4.6, 'reviews': 890},
      {'name': 'The Old Curiosity Shop', 'category': 'Home', 'country': 'Germany', 'rating': 4.4, 'reviews': 567},
      {'name': 'Second Chance Sports', 'category': 'Sports', 'country': 'Pakistan', 'rating': 4.7, 'reviews': 423},
      {'name': 'Dusty Pages Bookshop', 'category': 'Books', 'country': 'Russia', 'rating': 4.5, 'reviews': 789},
      {'name': 'Timeless Beauty Finds', 'category': 'Beauty', 'country': 'United States', 'rating': 4.9, 'reviews': 1100},
      {'name': 'Classic Car Parts Co', 'category': 'Automotive', 'country': 'Japan', 'rating': 4.3, 'reviews': 654},
      {'name': 'Paws & Claws Vintage', 'category': 'Pets', 'country': 'United Kingdom', 'rating': 4.7, 'reviews': 432},
      {'name': 'Vinyl & Vintage Music', 'category': 'Music', 'country': 'France', 'rating': 4.6, 'reviews': 876},
      {'name': 'Grandma\'s Kitchen Finds', 'category': 'Kitchen', 'country': 'Italy', 'rating': 4.5, 'reviews': 543},
      {'name': 'Yesteryear Toy Chest', 'category': 'Toys', 'city': 'Canterbury', 'rating': 4.8, 'reviews': 765},
      {'name': 'Mad Men Office Supply', 'category': 'Office', 'city': 'Cambridge', 'rating': 4.2, 'reviews': 321},
      {'name': 'Heirloom Jewelry Box', 'category': 'Jewelry', 'city': 'Windsor', 'rating': 4.9, 'reviews': 987},
      {'name': 'Artisan\'s Attic Crafts', 'category': 'Crafts', 'city': 'Stratford', 'rating': 4.4, 'reviews': 234},
      {'name': 'Apothecary & Wellness', 'category': 'Health', 'city': 'Harrogate', 'rating': 4.6, 'reviews': 678},
      {'name': 'Little Lamb\'s Legacy', 'category': 'Baby', 'city': 'Bournemouth', 'rating': 4.7, 'reviews': 456},
      {'name': 'Adventure Seekers Gear', 'category': 'Outdoor', 'city': 'Lake District', 'rating': 4.8, 'reviews': 789},
      {'name': 'Retro Streetwear Arcade', 'category': 'Fashion', 'city': 'Newcastle', 'rating': 4.5, 'reviews': 543},
      {'name': 'The Artist\'s Quarter', 'category': 'Art', 'city': 'St Ives', 'rating': 4.3, 'reviews': 321},
      {'name': 'Wanderlust Vintage', 'category': 'Travel', 'city': 'Dover', 'rating': 4.6, 'reviews': 654},
      {'name': 'Bygone Era Antiques', 'category': 'Vintage', 'city': 'Cotswolds', 'rating': 4.4, 'reviews': 432},
      {'name': 'Sheffield Vintage Couture', 'category': 'Fashion', 'city': 'Sheffield', 'rating': 4.7, 'reviews': 876},
      {'name': 'Mod & Vintage Fashion', 'category': 'Fashion', 'city': 'Nottingham', 'rating': 4.8, 'reviews': 765},
      {'name': 'Heritage Home & Garden', 'category': 'Garden', 'city': 'Chester', 'rating': 4.5, 'reviews': 543},
      {'name': 'Old School Fitness', 'category': 'Fitness', 'city': 'Leicester', 'rating': 4.6, 'reviews': 678},
      {'name': 'The Reading Room', 'category': 'Books', 'city': 'Salisbury', 'rating': 4.4, 'reviews': 456},
      {'name': 'Glamour Days Beauty', 'category': 'Beauty', 'city': 'Cheltenham', 'rating': 4.9, 'reviews': 987},
      {'name': 'Vintage Motor Works', 'category': 'Automotive', 'city': 'Coventry', 'rating': 4.3, 'reviews': 321},
      {'name': 'Furry Friends Vintage', 'category': 'Pets', 'city': 'Plymouth', 'rating': 4.7, 'reviews': 654},
      {'name': 'Melody Lane Records', 'category': 'Music', 'city': 'Portsmouth', 'rating': 4.5, 'reviews': 432},
      {'name': 'Retro Kitchen Co', 'category': 'Kitchen', 'city': 'Southampton', 'rating': 4.8, 'reviews': 789},
      {'name': 'Childhood Memories Toys', 'category': 'Toys', 'city': 'Exeter', 'rating': 4.6, 'reviews': 876},
      {'name': 'Typewriter & Quill Co', 'category': 'Office', 'city': 'Winchester', 'rating': 4.2, 'reviews': 543},
      {'name': 'Crown Jewels Vintage', 'category': 'Jewelry', 'city': 'Canterbury', 'rating': 4.9, 'reviews': 765},
      {'name': 'Handmade Heritage', 'category': 'Crafts', 'city': 'Glastonbury', 'rating': 4.4, 'reviews': 321},
      {'name': 'Victorian Remedies', 'category': 'Health', 'city': 'Warwick', 'rating': 4.7, 'reviews': 654},
      {'name': 'Nursery Rhyme Finds', 'category': 'Baby', 'city': 'Chichester', 'rating': 4.8, 'reviews': 432},
      {'name': 'Explorer\'s Emporium', 'category': 'Outdoor', 'city': 'Peak District', 'rating': 4.5, 'reviews': 789},
      {'name': 'Fashion Legends', 'category': 'Fashion', 'city': 'Derby', 'rating': 4.6, 'reviews': 876},
      {'name': 'Bohemian Art House', 'category': 'Art', 'city': 'Brighton', 'rating': 4.3, 'reviews': 543},
      {'name': 'Grand Tour Vintage', 'category': 'Travel', 'city': 'Hastings', 'rating': 4.7, 'reviews': 765},
      {'name': 'Antique Alley', 'category': 'Vintage', 'city': 'Rye', 'rating': 4.4, 'reviews': 321},
      {'name': 'Vintage Treasure Trove', 'category': 'Vintage', 'city': 'Guildford', 'rating': 4.8, 'reviews': 987},
      {'name': 'Swinging Sixties Style', 'category': 'Fashion', 'city': 'Margate', 'rating': 4.9, 'reviews': 654},
      {'name': 'Secret Garden Vintage', 'category': 'Garden', 'city': 'Kew', 'rating': 4.5, 'reviews': 432},
      {'name': 'Strongman\'s Gym Gear', 'category': 'Fitness', 'city': 'Blackpool', 'rating': 4.6, 'reviews': 789},
      {'name': 'Leather Bound Books', 'category': 'Books', 'city': 'Hay-on-Wye', 'rating': 4.4, 'reviews': 876},
      {'name': 'Speed Shop', 'category': 'Automotive', 'city': 'Lebanon', 'rating': 4.3, 'reviews': 765},
      {'name': 'Furry Friends', 'category': 'Pets', 'city': 'Syria', 'rating': 4.7, 'reviews': 321},
    ];
    
    return vendorData[(index - 1) % vendorData.length];
  }

  List<String> _getProductImages(String category, int productIndex) {
    // Using clothing-specific image sources for piles of clothing
    final clothingImageSources = [
      'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=300&h=300&fit=crop&crop=center', // Clothing pile
      'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=300&h=300&fit=crop&crop=center', // Clothes stack
      'https://images.unsplash.com/photo-1445205170230-053b83016050?w=300&h=300&fit=crop&crop=center', // Folded clothes
      'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=300&h=300&fit=crop&crop=center', // Clothing display
      'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=300&h=300&fit=crop&crop=center', // Clothes pile
      'https://images.unsplash.com/photo-1571945153237-4929e783af4a?w=300&h=300&fit=crop&crop=center', // Stacked clothing
      'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=300&h=300&fit=crop&crop=center', // Clothing arrangement
      'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=300&h=300&fit=crop&crop=center', // Fashion pile
      'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=300&h=300&fit=crop&crop=center', // Clothes collection
      'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=300&h=300&fit=crop&crop=center', // Clothing stack
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=300&h=300&fit=crop&crop=center', // Fashion items
      'https://images.unsplash.com/photo-1544966503-7cc5ac882d5f?w=300&h=300&fit=crop&crop=center', // Clothes arrangement
      'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=300&h=300&fit=crop&crop=center', // Clothing pile
      'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=300&h=300&fit=crop&crop=center', // Stacked garments
      'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300&h=300&fit=crop&crop=center', // Clothing collection
    ];
    
    // Select 5 different images for each product
    final baseIndex = (productIndex * 5) % clothingImageSources.length;
    final selectedImages = <String>[];
    
    for (int i = 0; i < 5; i++) {
      final imageIndex = (baseIndex + i) % clothingImageSources.length;
      selectedImages.add(clothingImageSources[imageIndex]);
    }
    
    return selectedImages;
  }

  Map<String, dynamic> _getProductDataForCategory(String category, int productIndex) {
    final productTemplates = {
      'Fashion': [
        {'name': 'The North Face Denali Fleece Jackets', 'description': 'Classic outdoor fleece jacket with superior warmth', 'basePrice': 149.0, 'subcategory': 'Outerwear', 'tags': ['fleece', 'outdoor', 'north face']},
        {'name': 'Y2K Leather Bomber Jackets', 'description': 'Vintage-inspired leather bomber with Y2K aesthetic', 'basePrice': 249.0, 'subcategory': 'Outerwear', 'tags': ['leather', 'bomber', 'y2k']},
        {'name': 'Patagonia Retro-X Fleece', 'description': 'Iconic fleece pullover with retro styling', 'basePrice': 199.0, 'subcategory': 'Outerwear', 'tags': ['patagonia', 'fleece', 'retro']},
        {'name': 'Ralph Lauren Harrington Jackets (Upcycled)', 'description': 'Sustainable upcycled Harrington jacket', 'basePrice': 179.0, 'subcategory': 'Outerwear', 'tags': ['ralph lauren', 'upcycled', 'sustainable']},
        {'name': 'Carhartt Work Jackets', 'description': 'Durable workwear jacket built to last', 'basePrice': 129.0, 'subcategory': 'Workwear', 'tags': ['carhartt', 'workwear', 'durable']},
        {'name': 'Nike Windbreakers', 'description': 'Lightweight windbreaker for active lifestyle', 'basePrice': 89.0, 'subcategory': 'Activewear', 'tags': ['nike', 'windbreaker', 'athletic']},
        {'name': 'Adidas 90s Track Jackets', 'description': 'Retro track jacket with classic 90s styling', 'basePrice': 99.0, 'subcategory': 'Activewear', 'tags': ['adidas', '90s', 'track jacket']},
        {'name': 'Tommy Hilfiger Sailing Jackets', 'description': 'Nautical-inspired sailing jacket', 'basePrice': 159.0, 'subcategory': 'Outerwear', 'tags': ['tommy hilfiger', 'sailing', 'nautical']},
        {'name': 'Vintage Varsity Jackets (Wool/Leather Mix)', 'description': 'Classic varsity jacket with wool body and leather sleeves', 'basePrice': 189.0, 'subcategory': 'Vintage', 'tags': ['varsity', 'vintage', 'wool leather']},
        {'name': 'Columbia Sportswear Fleece Jackets', 'description': 'Technical fleece for outdoor adventures', 'basePrice': 119.0, 'subcategory': 'Outdoor', 'tags': ['columbia', 'fleece', 'outdoor']},
        {'name': 'Polo Ralph Lauren Heavyweight Sweaters', 'description': 'Premium heavyweight knit sweater', 'basePrice': 149.0, 'subcategory': 'Knitwear', 'tags': ['polo', 'sweater', 'heavyweight']},
        {'name': 'Ralph Lauren 1/4 Zip Sweaters', 'description': 'Classic quarter-zip pullover sweater', 'basePrice': 129.0, 'subcategory': 'Knitwear', 'tags': ['ralph lauren', 'quarter zip', 'sweater']},
        {'name': 'Lacoste Knitted Sweaters', 'description': 'French elegance in knitted form', 'basePrice': 139.0, 'subcategory': 'Knitwear', 'tags': ['lacoste', 'knitted', 'french']},
        {'name': 'Patagonia Snap-T Pullovers', 'description': 'Iconic fleece pullover with snap closure', 'basePrice': 119.0, 'subcategory': 'Fleece', 'tags': ['patagonia', 'snap-t', 'pullover']},
        {'name': 'Nike Tech Fleece Hoodies', 'description': 'Innovative tech fleece for modern comfort', 'basePrice': 109.0, 'subcategory': 'Hoodies', 'tags': ['nike', 'tech fleece', 'hoodie']},
        {'name': 'Champion Reverse Weave Hoodies', 'description': 'Classic heavyweight reverse weave construction', 'basePrice': 89.0, 'subcategory': 'Hoodies', 'tags': ['champion', 'reverse weave', 'hoodie']},
        {'name': 'Adidas 90s Sweatshirts', 'description': 'Retro sweatshirt with vintage 90s appeal', 'basePrice': 79.0, 'subcategory': 'Sweatshirts', 'tags': ['adidas', '90s', 'sweatshirt']},
        {'name': 'Harley Davidson Sweatshirts', 'description': 'Iconic motorcycle brand sweatshirt', 'basePrice': 99.0, 'subcategory': 'Sweatshirts', 'tags': ['harley davidson', 'motorcycle', 'sweatshirt']},
        {'name': 'Carhartt Hoodies', 'description': 'Workwear-inspired heavyweight hoodie', 'basePrice': 89.0, 'subcategory': 'Hoodies', 'tags': ['carhartt', 'workwear', 'hoodie']},
        {'name': 'Stüssy Streetwear Hoodies', 'description': 'Streetwear essential with signature styling', 'basePrice': 119.0, 'subcategory': 'Streetwear', 'tags': ['stussy', 'streetwear', 'hoodie']},
        {'name': 'Vintage Harley Davidson Graphic Tees', 'description': 'Classic motorcycle graphics on vintage tee', 'basePrice': 49.0, 'subcategory': 'T-Shirts', 'tags': ['harley davidson', 'vintage', 'graphic tee']},
        {'name': 'Y2K Band T-Shirts (Linkin Park, Green Day, etc.)', 'description': 'Nostalgic band tees from the Y2K era', 'basePrice': 39.0, 'subcategory': 'T-Shirts', 'tags': ['y2k', 'band tee', 'vintage']},
        {'name': 'Nike Dri-Fit T-Shirts', 'description': 'Moisture-wicking athletic performance tee', 'basePrice': 29.0, 'subcategory': 'Athletic', 'tags': ['nike', 'dri-fit', 'athletic']},
        {'name': 'Adidas Logo Tees', 'description': 'Classic three stripes logo tee', 'basePrice': 25.0, 'subcategory': 'T-Shirts', 'tags': ['adidas', 'logo', 'tee']},
        {'name': 'Polo Ralph Lauren Polo Shirts', 'description': 'Timeless polo shirt with iconic pony logo', 'basePrice': 69.0, 'subcategory': 'Polo Shirts', 'tags': ['polo', 'ralph lauren', 'classic']},
        {'name': 'Burberry Nova Check Shirts', 'description': 'Luxury shirt with signature check pattern', 'basePrice': 199.0, 'subcategory': 'Dress Shirts', 'tags': ['burberry', 'nova check', 'luxury']},
        {'name': 'Carhartt Workwear Tees', 'description': 'Heavy-duty work tee built for durability', 'basePrice': 35.0, 'subcategory': 'Workwear', 'tags': ['carhartt', 'workwear', 'durable']},
        {'name': 'Levi\'s Graphic T-Shirts', 'description': 'Classic denim brand graphic tee', 'basePrice': 32.0, 'subcategory': 'T-Shirts', 'tags': ['levis', 'graphic', 'denim']},
        {'name': 'Hard Rock Café Tees (City Editions)', 'description': 'Collectible city-specific Hard Rock tees', 'basePrice': 29.0, 'subcategory': 'T-Shirts', 'tags': ['hard rock', 'city edition', 'collectible']},
        {'name': 'Sports Jerseys (NBA/NFL/Vintage Football)', 'description': 'Authentic and vintage sports jerseys', 'basePrice': 89.0, 'subcategory': 'Jerseys', 'tags': ['sports', 'jersey', 'vintage']},
        {'name': 'Levi\'s 501 Jeans (Light & Dark Wash)', 'description': 'Original straight fit jeans in classic washes', 'basePrice': 89.0, 'subcategory': 'Jeans', 'tags': ['levis', '501', 'denim']},
        {'name': 'Carhartt Double Knee Work Pants', 'description': 'Reinforced work pants with double knee', 'basePrice': 79.0, 'subcategory': 'Workwear', 'tags': ['carhartt', 'work pants', 'double knee']},
        {'name': 'Dickies 874 Work Pants', 'description': 'Classic straight leg work pants', 'basePrice': 59.0, 'subcategory': 'Workwear', 'tags': ['dickies', 'work pants', '874']},
        {'name': 'Wrangler Cowboy Cut Jeans', 'description': 'Western-style jeans with authentic fit', 'basePrice': 69.0, 'subcategory': 'Jeans', 'tags': ['wrangler', 'cowboy cut', 'western']},
        {'name': 'Vintage Cargo Pants (Y2K Military Style)', 'description': 'Military-inspired cargo pants with Y2K styling', 'basePrice': 79.0, 'subcategory': 'Cargo Pants', 'tags': ['cargo', 'y2k', 'military']},
        {'name': 'Nike Track Pants', 'description': 'Athletic track pants with side stripe', 'basePrice': 59.0, 'subcategory': 'Athletic', 'tags': ['nike', 'track pants', 'athletic']},
        {'name': 'Adidas Tearaway Pants (Popper Pants)', 'description': 'Iconic tearaway pants with side poppers', 'basePrice': 69.0, 'subcategory': 'Athletic', 'tags': ['adidas', 'tearaway', 'popper pants']},
        {'name': 'Jordan Basketball Shorts', 'description': 'Premium basketball shorts with Jumpman logo', 'basePrice': 49.0, 'subcategory': 'Shorts', 'tags': ['jordan', 'basketball', 'shorts']},
        {'name': 'Vintage Workwear Overalls', 'description': 'Classic workwear overalls with vintage appeal', 'basePrice': 99.0, 'subcategory': 'Overalls', 'tags': ['overalls', 'workwear', 'vintage']},
        {'name': 'Levi\'s Denim Jackets', 'description': 'Timeless denim jacket in classic blue', 'basePrice': 89.0, 'subcategory': 'Denim Jackets', 'tags': ['levis', 'denim jacket', 'classic']},
        {'name': 'Stone Island Jackets', 'description': 'Technical outerwear with innovative materials', 'basePrice': 399.0, 'subcategory': 'Technical Wear', 'tags': ['stone island', 'technical', 'premium']},
        {'name': 'Supreme Hoodies', 'description': 'Streetwear essential with box logo', 'basePrice': 159.0, 'subcategory': 'Streetwear', 'tags': ['supreme', 'box logo', 'streetwear']},
      ],
    };

    final defaultTemplate = [
      {'name': 'Premium Product', 'description': 'High-quality product with excellent features', 'basePrice': 99.0, 'subcategory': 'General', 'tags': ['premium', 'quality', 'product']},
      {'name': 'Essential Item', 'description': 'Must-have item for everyday use', 'basePrice': 49.0, 'subcategory': 'General', 'tags': ['essential', 'everyday', 'useful']},
      {'name': 'Deluxe Edition', 'description': 'Deluxe version with extra features', 'basePrice': 149.0, 'subcategory': 'General', 'tags': ['deluxe', 'premium', 'features']},
      {'name': 'Starter Kit', 'description': 'Perfect starter kit for beginners', 'basePrice': 79.0, 'subcategory': 'General', 'tags': ['starter', 'beginner', 'kit']},
      {'name': 'Professional Grade', 'description': 'Professional-grade quality and performance', 'basePrice': 199.0, 'subcategory': 'General', 'tags': ['professional', 'quality', 'performance']},
    ];

    final templates = productTemplates[category] ?? defaultTemplate;
    final template = templates[(productIndex - 1) % templates.length];
    
    return {
      'name': '${template['name']} ${String.fromCharCode(65 + ((productIndex - 1) ~/ templates.length))}',
      'description': template['description'],
      'basePrice': template['basePrice'],
      'subcategory': template['subcategory'],
      'tags': template['tags'],
    };
  }

  String _getCountyFromCity(String city) {
    final cityCounties = {
      'London': 'Greater London', 'Brighton': 'East Sussex', 'Bath': 'Somerset', 
      'Manchester': 'Greater Manchester', 'Oxford': 'Oxfordshire', 'Edinburgh': 'Midlothian',
      'Birmingham': 'West Midlands', 'Liverpool': 'Merseyside', 'Bristol': 'Gloucestershire',
      'York': 'North Yorkshire', 'Canterbury': 'Kent', 'Cambridge': 'Cambridgeshire',
      'Windsor': 'Berkshire', 'Stratford': 'Warwickshire', 'Harrogate': 'North Yorkshire',
      'Bournemouth': 'Dorset', 'Lake District': 'Cumbria', 'Newcastle': 'Tyne and Wear',
      'St Ives': 'Cornwall', 'Dover': 'Kent', 'Cotswolds': 'Gloucestershire',
      'Sheffield': 'South Yorkshire', 'Nottingham': 'Nottinghamshire', 'Chester': 'Cheshire',
      'Leicester': 'Leicestershire', 'Salisbury': 'Wiltshire', 'Cheltenham': 'Gloucestershire',
      'Coventry': 'West Midlands', 'Plymouth': 'Devon', 'Portsmouth': 'Hampshire',
      'Southampton': 'Hampshire', 'Exeter': 'Devon', 'Winchester': 'Hampshire',
      'Glastonbury': 'Somerset', 'Warwick': 'Warwickshire', 'Chichester': 'West Sussex',
      'Peak District': 'Derbyshire', 'Derby': 'Derbyshire', 'Hastings': 'East Sussex',
      'Rye': 'East Sussex', 'Guildford': 'Surrey', 'Margate': 'Kent', 'Kew': 'Greater London',
      'Blackpool': 'Lancashire', 'Hay-on-Wye': 'Powys', 'Eastbourne': 'East Sussex',
      'Goodwood': 'West Sussex', 'Crufts': 'West Midlands',
    };
    return cityCounties[city] ?? 'England';
  }

  String _getPostcodeFromCity(String city, int index) {
    final cityPostcodes = {
      'London': 'SW1A 1AA', 'Brighton': 'BN1 1AA', 'Bath': 'BA1 1AA',
      'Manchester': 'M1 1AA', 'Oxford': 'OX1 1AA', 'Edinburgh': 'EH1 1AA',
      'Birmingham': 'B1 1AA', 'Liverpool': 'L1 1AA', 'Bristol': 'BS1 1AA',
      'York': 'YO1 1AA', 'Canterbury': 'CT1 1AA', 'Cambridge': 'CB1 1AA',
      'Windsor': 'SL4 1AA', 'Stratford': 'CV37 1AA', 'Harrogate': 'HG1 1AA',
      'Bournemouth': 'BH1 1AA', 'Lake District': 'LA22 1AA', 'Newcastle': 'NE1 1AA',
      'St Ives': 'TR26 1AA', 'Dover': 'CT16 1AA', 'Cotswolds': 'GL54 1AA',
      'Sheffield': 'S1 1AA', 'Nottingham': 'NG1 1AA', 'Chester': 'CH1 1AA',
      'Leicester': 'LE1 1AA', 'Salisbury': 'SP1 1AA', 'Cheltenham': 'GL50 1AA',
      'Coventry': 'CV1 1AA', 'Plymouth': 'PL1 1AA', 'Portsmouth': 'PO1 1AA',
      'Southampton': 'SO14 1AA', 'Exeter': 'EX1 1AA', 'Winchester': 'SO23 1AA',
      'Glastonbury': 'BA6 1AA', 'Warwick': 'CV34 1AA', 'Chichester': 'PO19 1AA',
      'Peak District': 'SK17 1AA', 'Derby': 'DE1 1AA', 'Hastings': 'TN34 1AA',
      'Rye': 'TN31 1AA', 'Guildford': 'GU1 1AA', 'Margate': 'CT9 1AA',
      'Kew': 'TW9 1AA', 'Blackpool': 'FY1 1AA', 'Hay-on-Wye': 'HR3 1AA',
      'Eastbourne': 'BN21 1AA', 'Goodwood': 'PO18 1AA', 'Crufts': 'B40 1AA',
    };
    final basePostcode = cityPostcodes[city] ?? 'EN1 1AA';
    // Vary the postcode slightly based on index
    final parts = basePostcode.split(' ');
    final number = (int.tryParse(parts[1].substring(0, 1)) ?? 1) + (index % 9);
    return '${parts[0]} ${number}${parts[1].substring(1)}';
  }

  String _getCapitalCity(String? country) {
    final capitals = {
      'China': 'Beijing', 'India': 'New Delhi', 'Germany': 'Berlin', 'Pakistan': 'Islamabad',
      'Russia': 'Moscow', 'United States': 'Washington D.C.', 'Japan': 'Tokyo', 'United Kingdom': 'London',
      'France': 'Paris', 'Italy': 'Rome', 'Brazil': 'Brasília', 'Canada': 'Ottawa',
      'Australia': 'Canberra', 'Spain': 'Madrid', 'Netherlands': 'Amsterdam', 'Sweden': 'Stockholm',
      'Norway': 'Oslo', 'South Korea': 'Seoul', 'Mexico': 'Mexico City', 'Argentina': 'Buenos Aires',
    };
    return capitals[country] ?? 'Unknown City';
  }

  String _getStateFromCountry(String? country) {
    final states = {
      'China': 'Beijing Municipality', 'India': 'Delhi', 'Germany': 'Berlin', 'Pakistan': 'Islamabad Capital Territory',
      'Russia': 'Moscow Oblast', 'United States': 'District of Columbia', 'Japan': 'Tokyo Metropolis', 'United Kingdom': 'England',
      'France': 'Île-de-France', 'Italy': 'Lazio', 'Brazil': 'Federal District', 'Canada': 'Ontario',
      'Australia': 'Australian Capital Territory', 'Spain': 'Community of Madrid', 'Netherlands': 'North Holland', 'Sweden': 'Stockholm County',
      'Norway': 'Oslo', 'South Korea': 'Seoul', 'Mexico': 'Mexico City', 'Argentina': 'Buenos Aires',
    };
    return states[country] ?? 'Unknown State';
  }

  String _getPostcodeFromCountry(String? country, int index) {
    final baseCodes = {
      'China': '100000', 'India': '110001', 'Germany': '10115', 'Pakistan': '44000',
      'Russia': '101000', 'United States': '20001', 'Japan': '100-0001', 'United Kingdom': 'SW1A 1AA',
      'France': '75001', 'Italy': '00118', 'Brazil': '70040-010', 'Canada': 'K1A 0A6',
      'Australia': '2600', 'Spain': '28001', 'Netherlands': '1011', 'Sweden': '10011',
      'Norway': '0001', 'South Korea': '04524', 'Mexico': '06000', 'Argentina': 'C1001',
    };
    final baseCode = baseCodes[country] ?? '00000';
    return '$baseCode${(index + 1).toString().padLeft(1, '0')}';
  }
}
