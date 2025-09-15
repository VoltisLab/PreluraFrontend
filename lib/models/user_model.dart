class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String userType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final AddressModel? defaultAddress;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.defaultAddress,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      userType: json['user_type'] ?? 'customer',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? true,
      defaultAddress: json['default_address'] != null 
          ? AddressModel.fromJson(json['default_address']) 
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'user_type': userType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'default_address': defaultAddress?.toJson(),
    };
  }
  
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? userType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    AddressModel? defaultAddress,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      defaultAddress: defaultAddress ?? this.defaultAddress,
    );
  }
}

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
