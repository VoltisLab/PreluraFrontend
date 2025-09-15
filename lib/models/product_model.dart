class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final List<String> images;
  final String category;
  final String subcategory;
  final VendorModel vendor;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final Map<String, dynamic> specifications;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.images,
    required this.category,
    required this.subcategory,
    required this.vendor,
    required this.stockQuantity,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    this.specifications = const {},
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discount_price']?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      vendor: VendorModel.fromJson(json['vendor'] ?? {}),
      stockQuantity: json['stock_quantity'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      isActive: json['is_active'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'images': images,
      'category': category,
      'subcategory': subcategory,
      'vendor': vendor.toJson(),
      'stock_quantity': stockQuantity,
      'rating': rating,
      'review_count': reviewCount,
      'tags': tags,
      'specifications': specifications,
      'is_active': isActive,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  double get finalPrice => discountPrice ?? price;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  double get discountPercentage => hasDiscount ? ((price - discountPrice!) / price * 100) : 0;
  bool get inStock => stockQuantity > 0;
  String get mainImage => images.isNotEmpty ? images.first : '';
}

class VendorModel {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String email;
  final String phone;
  final AddressModel address;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final List<String> categories;
  
  VendorModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.email,
    required this.phone,
    required this.address,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.isActive = true,
    required this.createdAt,
    this.categories = const [],
  });
  
  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: AddressModel.fromJson(json['address'] ?? {}),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logo': logo,
      'email': email,
      'phone': phone,
      'address': address.toJson(),
      'rating': rating,
      'review_count': reviewCount,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'categories': categories,
    };
  }
}

// Import AddressModel from user_model.dart
class AddressModel {
  final String id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;
  final bool isDefault;
  
  AddressModel({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });
  
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isDefault: json['is_default'] ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }
  
  String get fullAddress => '$street, $city, $state $zipCode, $country';
}
