import 'package:flutter/material.dart';
import '../models/product_model.dart';

class VendorProvider extends ChangeNotifier {
  List<VendorModel> _vendors = [];
  bool _isLoading = false;
  String? _error;

  List<VendorModel> get vendors => _vendors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadVendors() async {
    setLoading(true);
    setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _vendors = _generateMockVendors();
      
      setLoading(false);
    } catch (e) {
      setError('Failed to load vendors: ${e.toString()}');
      setLoading(false);
    }
  }

  VendorModel? getVendorById(String id) {
    try {
      return _vendors.firstWhere((vendor) => vendor.id == id);
    } catch (e) {
      return null;
    }
  }

  List<VendorModel> getVendorsByCategory(String category) {
    return _vendors.where((vendor) => vendor.categories.contains(category)).toList();
  }

  List<VendorModel> searchVendors(String query) {
    return _vendors.where((vendor) => 
      vendor.name.toLowerCase().contains(query.toLowerCase()) ||
      vendor.description.toLowerCase().contains(query.toLowerCase()) ||
      vendor.categories.any((category) => 
        category.toLowerCase().contains(query.toLowerCase())
      )
    ).toList();
  }

  List<VendorModel> _generateMockVendors() {
    final List<Map<String, dynamic>> vendorData = [
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
      {'name': 'Yesteryear Toy Chest', 'category': 'Toys', 'country': 'Brazil', 'rating': 4.8, 'reviews': 765},
      {'name': 'Mad Men Office Supply', 'category': 'Office', 'country': 'Canada', 'rating': 4.2, 'reviews': 321},
      {'name': 'Heirloom Jewelry Box', 'category': 'Jewelry', 'country': 'Australia', 'rating': 4.9, 'reviews': 987},
      {'name': 'Artisan\'s Attic Crafts', 'category': 'Crafts', 'country': 'Spain', 'rating': 4.4, 'reviews': 234},
      {'name': 'Apothecary & Wellness', 'category': 'Health', 'country': 'Netherlands', 'rating': 4.6, 'reviews': 678},
      {'name': 'Little Lamb\'s Legacy', 'category': 'Baby', 'country': 'Sweden', 'rating': 4.7, 'reviews': 456},
      {'name': 'Adventure Seekers Gear', 'category': 'Outdoor', 'country': 'Norway', 'rating': 4.8, 'reviews': 789},
      {'name': 'Retro Streetwear Seoul', 'category': 'Fashion', 'country': 'South Korea', 'rating': 4.5, 'reviews': 543},
      {'name': 'The Artist\'s Quarter', 'category': 'Art', 'country': 'Mexico', 'rating': 4.3, 'reviews': 321},
      {'name': 'Wanderlust Vintage', 'category': 'Travel', 'country': 'Argentina', 'rating': 4.6, 'reviews': 654},
      {'name': 'Bygone Era Antiques', 'category': 'Vintage', 'country': 'Belgium', 'rating': 4.4, 'reviews': 432},
      {'name': 'Swiss Vintage Couture', 'category': 'Fashion', 'country': 'Switzerland', 'rating': 4.7, 'reviews': 876},
      {'name': 'Mod & Vintage Fashion', 'category': 'Fashion', 'country': 'Austria', 'rating': 4.8, 'reviews': 765},
      {'name': 'Heritage Home & Garden', 'category': 'Garden', 'country': 'Denmark', 'rating': 4.5, 'reviews': 543},
      {'name': 'Old School Fitness', 'category': 'Fitness', 'country': 'Finland', 'rating': 4.6, 'reviews': 678},
      {'name': 'Global Vintage Collective', 'category': 'Vintage', 'country': 'Singapore', 'rating': 4.7, 'reviews': 892},
      {'name': 'Fashion Forward', 'category': 'Fashion', 'country': 'Turkey', 'rating': 4.5, 'reviews': 567},
      {'name': 'Home Sweet Home', 'category': 'Home', 'country': 'Poland', 'rating': 4.3, 'reviews': 434},
      {'name': 'Sports Central', 'category': 'Sports', 'country': 'Czech Republic', 'rating': 4.6, 'reviews': 678},
      {'name': 'Book Haven', 'category': 'Books', 'country': 'Greece', 'rating': 4.4, 'reviews': 345},
      {'name': 'Beauty Bliss', 'category': 'Beauty', 'country': 'Portugal', 'rating': 4.8, 'reviews': 789},
      {'name': 'Auto Excellence', 'category': 'Automotive', 'country': 'Ireland', 'rating': 4.2, 'reviews': 456},
      {'name': 'Pet Paradise', 'category': 'Pets', 'country': 'New Zealand', 'rating': 4.9, 'reviews': 623},
      {'name': 'Music Mania', 'category': 'Music', 'country': 'Hungary', 'rating': 4.5, 'reviews': 512},
      {'name': 'Kitchen Kings', 'category': 'Kitchen', 'country': 'Romania', 'rating': 4.3, 'reviews': 389},
      {'name': 'Toy Town', 'category': 'Toys', 'country': 'Bulgaria', 'rating': 4.7, 'reviews': 445},
      {'name': 'Office Oasis', 'category': 'Office', 'country': 'Croatia', 'rating': 4.1, 'reviews': 267},
      {'name': 'Jewelry Junction', 'category': 'Jewelry', 'country': 'Slovenia', 'rating': 4.8, 'reviews': 678},
      {'name': 'Craft Corner', 'category': 'Crafts', 'country': 'Slovakia', 'rating': 4.4, 'reviews': 234},
      {'name': 'Health Hub', 'category': 'Health', 'country': 'Estonia', 'rating': 4.6, 'reviews': 456},
      {'name': 'Baby Boutique', 'category': 'Baby', 'country': 'Latvia', 'rating': 4.5, 'reviews': 345},
      {'name': 'Outdoor Outfitters', 'category': 'Outdoor', 'country': 'Lithuania', 'rating': 4.7, 'reviews': 567},
      {'name': 'Nordic Fashion House', 'category': 'Fashion', 'country': 'Iceland', 'rating': 4.6, 'reviews': 389},
      {'name': 'Art Avenue', 'category': 'Art', 'country': 'Luxembourg', 'rating': 4.3, 'reviews': 234},
      {'name': 'Travel Treasures', 'category': 'Travel', 'country': 'Malta', 'rating': 4.5, 'reviews': 345},
      {'name': 'Vintage Vibes', 'category': 'Vintage', 'country': 'Cyprus', 'rating': 4.4, 'reviews': 278},
      {'name': 'Timeless Textiles', 'category': 'Fashion', 'country': 'Israel', 'rating': 4.8, 'reviews': 789},
      {'name': 'Style Station', 'category': 'Fashion', 'country': 'South Africa', 'rating': 4.6, 'reviews': 567},
      {'name': 'Home Harmony', 'category': 'Home', 'country': 'Egypt', 'rating': 4.2, 'reviews': 434},
      {'name': 'Sports Spectrum', 'category': 'Sports', 'country': 'Morocco', 'rating': 4.5, 'reviews': 456},
      {'name': 'Literary Lounge', 'category': 'Books', 'country': 'Tunisia', 'rating': 4.3, 'reviews': 345},
      {'name': 'Beauty Boulevard', 'category': 'Beauty', 'country': 'Algeria', 'rating': 4.7, 'reviews': 678},
      {'name': 'Motor Masters', 'category': 'Automotive', 'country': 'Libya', 'rating': 4.1, 'reviews': 234},
      {'name': 'Pet Palace', 'category': 'Pets', 'country': 'Sudan', 'rating': 4.4, 'reviews': 345},
      {'name': 'Melody Makers', 'category': 'Music', 'country': 'Ethiopia', 'rating': 4.6, 'reviews': 456},
      {'name': 'Culinary Creations', 'category': 'Kitchen', 'country': 'Kenya', 'rating': 4.3, 'reviews': 389},
      {'name': 'Playtime Plaza', 'category': 'Toys', 'country': 'Tanzania', 'rating': 4.5, 'reviews': 567},
      {'name': 'Workspace Wonders', 'category': 'Office', 'country': 'Uganda', 'rating': 4.2, 'reviews': 234},
      {'name': 'Gem Gallery', 'category': 'Jewelry', 'country': 'Rwanda', 'rating': 4.8, 'reviews': 456},
      {'name': 'Creative Corner', 'category': 'Crafts', 'country': 'Ghana', 'rating': 4.4, 'reviews': 345},
      {'name': 'Wellness World', 'category': 'Health', 'country': 'Nigeria', 'rating': 4.6, 'reviews': 678},
      {'name': 'Tiny Tots', 'category': 'Baby', 'country': 'Senegal', 'rating': 4.5, 'reviews': 389},
      {'name': 'Adventure Awaits', 'category': 'Outdoor', 'country': 'Mali', 'rating': 4.7, 'reviews': 456},
      {'name': 'Artisan Apparel Zone', 'category': 'Fashion', 'country': 'Burkina Faso', 'rating': 4.3, 'reviews': 234},
      {'name': 'Artistic Expressions', 'category': 'Art', 'country': 'Niger', 'rating': 4.4, 'reviews': 345},
      {'name': 'Journey Junction', 'category': 'Travel', 'country': 'Chad', 'rating': 4.2, 'reviews': 278},
      {'name': 'Retro Relics', 'category': 'Vintage', 'country': 'Cameroon', 'rating': 4.5, 'reviews': 389},
      {'name': 'Dreamy Vintage Finds', 'category': 'Vintage', 'country': 'Thailand', 'rating': 4.7, 'reviews': 567},
      {'name': 'Fashion Fusion', 'category': 'Fashion', 'country': 'Vietnam', 'rating': 4.6, 'reviews': 456},
      {'name': 'Cozy Corners', 'category': 'Home', 'country': 'Philippines', 'rating': 4.3, 'reviews': 345},
      {'name': 'Athletic Arena', 'category': 'Sports', 'country': 'Indonesia', 'rating': 4.5, 'reviews': 678},
      {'name': 'Reading Room', 'category': 'Books', 'country': 'Malaysia', 'rating': 4.4, 'reviews': 389},
      {'name': 'Glamour Gallery', 'category': 'Beauty', 'country': 'Bangladesh', 'rating': 4.8, 'reviews': 567},
      {'name': 'Vehicle Vault', 'category': 'Automotive', 'country': 'Sri Lanka', 'rating': 4.2, 'reviews': 234},
      {'name': 'Animal Allies', 'category': 'Pets', 'country': 'Myanmar', 'rating': 4.6, 'reviews': 456},
      {'name': 'Sound Studio', 'category': 'Music', 'country': 'Cambodia', 'rating': 4.5, 'reviews': 345},
      {'name': 'Chef\'s Choice', 'category': 'Kitchen', 'country': 'Laos', 'rating': 4.3, 'reviews': 278},
      {'name': 'Fun Factory', 'category': 'Toys', 'country': 'Mongolia', 'rating': 4.7, 'reviews': 456},
      {'name': 'Business Base', 'category': 'Office', 'country': 'Nepal', 'rating': 4.1, 'reviews': 234},
      {'name': 'Precious Pieces', 'category': 'Jewelry', 'country': 'Bhutan', 'rating': 4.9, 'reviews': 345},
      {'name': 'Handmade Haven', 'category': 'Crafts', 'country': 'Afghanistan', 'rating': 4.4, 'reviews': 278},
      {'name': 'Vitality Vault', 'category': 'Health', 'country': 'Uzbekistan', 'rating': 4.6, 'reviews': 389},
      {'name': 'Little Luxuries', 'category': 'Baby', 'country': 'Kazakhstan', 'rating': 4.5, 'reviews': 456},
      {'name': 'Wild Wonders', 'category': 'Outdoor', 'country': 'Kyrgyzstan', 'rating': 4.8, 'reviews': 567},
      {'name': 'Paradise Vintage', 'category': 'Vintage', 'country': 'Tajikistan', 'rating': 4.3, 'reviews': 234},
      {'name': 'Canvas Creations', 'category': 'Art', 'country': 'Turkmenistan', 'rating': 4.4, 'reviews': 345},
      {'name': 'Wanderer\'s Way', 'category': 'Travel', 'country': 'Azerbaijan', 'rating': 4.6, 'reviews': 456},
      {'name': 'Nostalgia Nook', 'category': 'Vintage', 'country': 'Armenia', 'rating': 4.2, 'reviews': 278},
      {'name': 'Heritage Fashion House', 'category': 'Fashion', 'country': 'Georgia', 'rating': 4.7, 'reviews': 389},
      {'name': 'Trendy Threads', 'category': 'Fashion', 'country': 'Moldova', 'rating': 4.5, 'reviews': 345},
      {'name': 'Comfort Castle', 'category': 'Home', 'country': 'Belarus', 'rating': 4.3, 'reviews': 456},
      {'name': 'Victory Venue', 'category': 'Sports', 'country': 'Ukraine', 'rating': 4.6, 'reviews': 567},
      {'name': 'Knowledge Nook', 'category': 'Books', 'country': 'Serbia', 'rating': 4.4, 'reviews': 234},
      {'name': 'Radiance Realm', 'category': 'Beauty', 'country': 'Montenegro', 'rating': 4.8, 'reviews': 345},
      {'name': 'Drive Depot', 'category': 'Automotive', 'country': 'Bosnia and Herzegovina', 'rating': 4.1, 'reviews': 278},
      {'name': 'Companion Corner', 'category': 'Pets', 'country': 'North Macedonia', 'rating': 4.5, 'reviews': 389},
      {'name': 'Harmony House', 'category': 'Music', 'country': 'Albania', 'rating': 4.6, 'reviews': 456},
      {'name': 'Gourmet Gallery', 'category': 'Kitchen', 'country': 'Kosovo', 'rating': 4.3, 'reviews': 234},
      {'name': 'Wonder World', 'category': 'Toys', 'country': 'Chile', 'rating': 4.7, 'reviews': 567},
      {'name': 'Professional Plaza', 'category': 'Office', 'country': 'Peru', 'rating': 4.2, 'reviews': 345},
      {'name': 'Sparkle Spot', 'category': 'Jewelry', 'country': 'Colombia', 'rating': 4.9, 'reviews': 456},
      {'name': 'Artisan Alley', 'category': 'Crafts', 'country': 'Venezuela', 'rating': 4.4, 'reviews': 278},
      {'name': 'Health Haven', 'category': 'Health', 'country': 'Ecuador', 'rating': 4.6, 'reviews': 389},
      {'name': 'Bundle of Joy', 'category': 'Baby', 'country': 'Bolivia', 'rating': 4.5, 'reviews': 234},
      {'name': 'Explorer\'s Edge', 'category': 'Outdoor', 'country': 'Paraguay', 'rating': 4.8, 'reviews': 345},
      {'name': 'Vintage Grounds', 'category': 'Vintage', 'country': 'Uruguay', 'rating': 4.3, 'reviews': 456},
      {'name': 'Creative Canvas', 'category': 'Art', 'country': 'Guyana', 'rating': 4.4, 'reviews': 278},
      {'name': 'Voyage Vault', 'category': 'Travel', 'country': 'Suriname', 'rating': 4.6, 'reviews': 389},
      {'name': 'Timeless Treasures', 'category': 'Vintage', 'country': 'French Guiana', 'rating': 4.2, 'reviews': 234},
    ];

    return List.generate(50, (index) {
      final data = vendorData[index];
      final vendorId = (index + 1).toString();
      
      return VendorModel(
        id: vendorId,
        name: data['name'],
        description: 'Premium ${data['category'].toLowerCase()} products and services. Quality guaranteed with excellent customer service.',
        logo: 'https://picsum.photos/80/80?random=${index + 500}',
        email: '${data['name'].toLowerCase().replaceAll(' ', '').replaceAll('&', '')}@example.com',
        phone: '+44 ${(1000 + index * 7).toString().padLeft(4, '0')} ${(100000 + index * 123).toString().padLeft(6, '0')}',
        address: AddressModel(
          id: vendorId,
          street: '${100 + index * 10} ${data['category']} Street',
          city: _getCapitalCity(data['country']),
          state: _getStateFromCountry(data['country']),
          zipCode: _getPostcodeFromCountry(data['country'], index),
          country: data['country'] ?? 'China',
          latitude: _getCountryLatitude(data['country'], index),
          longitude: _getCountryLongitude(data['country'], index),
        ),
        rating: data['rating'].toDouble(),
        reviewCount: data['reviews'],
        isVerified: index % 3 == 0, // Every 3rd vendor is verified
        createdAt: DateTime.now().subtract(Duration(days: 30 + index * 10)),
        categories: [data['category'], 'General'],
      );
    });
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
      'Belgium': 'Brussels', 'Switzerland': 'Bern', 'Austria': 'Vienna', 'Denmark': 'Copenhagen',
      'Finland': 'Helsinki', 'Singapore': 'Singapore', 'Turkey': 'Ankara', 'Poland': 'Warsaw',
      'Czech Republic': 'Prague', 'Greece': 'Athens', 'Portugal': 'Lisbon', 'Ireland': 'Dublin',
      'New Zealand': 'Wellington', 'Hungary': 'Budapest', 'Romania': 'Bucharest', 'Bulgaria': 'Sofia',
      'Croatia': 'Zagreb', 'Slovenia': 'Ljubljana', 'Slovakia': 'Bratislava', 'Estonia': 'Tallinn',
      'Latvia': 'Riga', 'Lithuania': 'Vilnius', 'Iceland': 'Reykjavik', 'Luxembourg': 'Luxembourg City',
      'Malta': 'Valletta', 'Cyprus': 'Nicosia', 'Israel': 'Jerusalem', 'South Africa': 'Cape Town',
      'Egypt': 'Cairo', 'Morocco': 'Rabat', 'Tunisia': 'Tunis', 'Algeria': 'Algiers',
      'Libya': 'Tripoli', 'Sudan': 'Khartoum', 'Ethiopia': 'Addis Ababa', 'Kenya': 'Nairobi',
      'Tanzania': 'Dodoma', 'Uganda': 'Kampala', 'Rwanda': 'Kigali', 'Ghana': 'Accra',
      'Nigeria': 'Abuja', 'Senegal': 'Dakar', 'Mali': 'Bamako', 'Burkina Faso': 'Ouagadougou',
      'Niger': 'Niamey', 'Chad': 'N\'Djamena', 'Cameroon': 'Yaoundé', 'Thailand': 'Bangkok',
      'Vietnam': 'Hanoi', 'Philippines': 'Manila', 'Indonesia': 'Jakarta', 'Malaysia': 'Kuala Lumpur',
      'Bangladesh': 'Dhaka', 'Sri Lanka': 'Colombo', 'Myanmar': 'Naypyidaw', 'Cambodia': 'Phnom Penh',
      'Laos': 'Vientiane', 'Mongolia': 'Ulaanbaatar', 'Nepal': 'Kathmandu', 'Bhutan': 'Thimphu',
      'Afghanistan': 'Kabul', 'Uzbekistan': 'Tashkent', 'Kazakhstan': 'Nur-Sultan', 'Kyrgyzstan': 'Bishkek',
      'Tajikistan': 'Dushanbe', 'Turkmenistan': 'Ashgabat', 'Azerbaijan': 'Baku', 'Armenia': 'Yerevan',
      'Georgia': 'Tbilisi', 'Moldova': 'Chișinău', 'Belarus': 'Minsk', 'Ukraine': 'Kyiv',
      'Serbia': 'Belgrade', 'Montenegro': 'Podgorica', 'Bosnia and Herzegovina': 'Sarajevo', 'North Macedonia': 'Skopje',
      'Albania': 'Tirana', 'Kosovo': 'Pristina', 'Chile': 'Santiago', 'Peru': 'Lima',
      'Colombia': 'Bogotá', 'Venezuela': 'Caracas', 'Ecuador': 'Quito', 'Bolivia': 'Sucre',
      'Paraguay': 'Asunción', 'Uruguay': 'Montevideo', 'Guyana': 'Georgetown', 'Suriname': 'Paramaribo',
      'French Guiana': 'Cayenne',
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
      'Belgium': 'Brussels-Capital Region', 'Switzerland': 'Bern', 'Austria': 'Vienna', 'Denmark': 'Capital Region',
      'Finland': 'Uusimaa', 'Singapore': 'Central Region', 'Turkey': 'Ankara Province', 'Poland': 'Masovian Voivodeship',
      'Czech Republic': 'Prague', 'Greece': 'Attica', 'Portugal': 'Lisbon District', 'Ireland': 'Leinster',
      'New Zealand': 'Wellington Region', 'Hungary': 'Budapest', 'Romania': 'Bucharest', 'Bulgaria': 'Sofia Province',
      'Croatia': 'Zagreb County', 'Slovenia': 'Central Slovenia', 'Slovakia': 'Bratislava Region', 'Estonia': 'Harju County',
      'Latvia': 'Riga', 'Lithuania': 'Vilnius County', 'Iceland': 'Capital Region', 'Luxembourg': 'Luxembourg District',
      'Malta': 'Southern Region', 'Cyprus': 'Nicosia District', 'Israel': 'Jerusalem District', 'South Africa': 'Western Cape',
      'Egypt': 'Cairo Governorate', 'Morocco': 'Rabat-Salé-Kénitra', 'Tunisia': 'Tunis Governorate', 'Algeria': 'Algiers Province',
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
      'Belgium': '1000', 'Switzerland': '3001', 'Austria': '1010', 'Denmark': '1050',
      'Finland': '00100', 'Singapore': '018956', 'Turkey': '06420', 'Poland': '00-001',
    };
    final baseCode = baseCodes[country] ?? '00000';
    return '$baseCode${(index + 1).toString().padLeft(1, '0')}';
  }

  double _getCountryLatitude(String? country, int index) {
    final countryCoordinates = {
      'China': [39.9042, 116.4074], 'India': [28.7041, 77.1025], 'Germany': [52.5200, 13.4050],
      'Pakistan': [33.6844, 73.0479], 'Russia': [55.7558, 37.6176], 'United States': [38.9072, -77.0369],
      'Japan': [35.6762, 139.6503], 'United Kingdom': [51.5074, -0.1278], 'France': [48.8566, 2.3522],
      'Italy': [41.9028, 12.4964], 'Brazil': [-15.8267, -47.9218], 'Canada': [45.4215, -75.6972],
      'Australia': [-35.2809, 149.1300], 'Spain': [40.4168, -3.7038], 'Netherlands': [52.3676, 4.9041],
      'Sweden': [59.3293, 18.0686], 'Norway': [59.9139, 10.7522], 'South Korea': [37.5665, 126.9780],
      'Mexico': [19.4326, -99.1332], 'Argentina': [-34.6118, -58.3960], 'Belgium': [50.8503, 4.3517],
      'Switzerland': [46.9481, 7.4474], 'Austria': [48.2082, 16.3738], 'Denmark': [55.6761, 12.5683],
      'Finland': [60.1699, 24.9384], 'Singapore': [1.3521, 103.8198], 'Turkey': [39.9334, 32.8597],
      'Poland': [52.2297, 21.0122], 'Czech Republic': [50.0755, 14.4378], 'Greece': [37.9755, 23.7348],
      'Portugal': [38.7223, -9.1393], 'Hungary': [47.4979, 19.0402], 'Romania': [44.4268, 26.1025],
      'Bulgaria': [42.6977, 23.3219], 'Croatia': [45.8150, 15.9819], 'Slovenia': [46.0569, 14.5058],
      'Slovakia': [48.1486, 17.1077], 'Estonia': [59.4370, 24.7536], 'Latvia': [56.9496, 24.1052],
      'Lithuania': [54.6872, 25.2797], 'Iceland': [64.1466, -21.9426], 'Luxembourg': [49.6116, 6.1319],
      'Malta': [35.8997, 14.5146], 'Cyprus': [35.1856, 33.3823], 'Israel': [31.7683, 35.2137],
      'South Africa': [-25.7479, 28.2293], 'Egypt': [30.0444, 31.2357], 'Morocco': [34.0209, -6.8416],
      'Tunisia': [36.8065, 10.1815], 'Algeria': [36.7538, 3.0588], 'Libya': [32.8872, 13.1913],
      'Sudan': [15.5007, 32.5599], 'Ethiopia': [9.1450, 40.4897], 'Kenya': [-1.2921, 36.8219],
      'Uganda': [0.3476, 32.5825], 'Tanzania': [-6.7924, 39.2083], 'Rwanda': [-1.9441, 30.0619],
      'Ghana': [5.6037, -0.1870], 'Nigeria': [9.0765, 7.3986], 'Senegal': [14.7167, -17.4677],
      'Mali': [12.6392, -8.0029], 'Burkina Faso': [12.2383, -1.5616], 'Niger': [13.5116, 2.1254],
      'Chad': [12.1348, 15.0557], 'Cameroon': [3.8480, 11.5021], 'Thailand': [13.7563, 100.5018],
      'Vietnam': [21.0285, 105.8542], 'Philippines': [14.5995, 120.9842], 'Indonesia': [-6.2088, 106.8456],
      'Malaysia': [3.1390, 101.6869], 'Bangladesh': [23.8103, 90.4125], 'Myanmar': [19.7633, 96.0785],
      'Sri Lanka': [6.9271, 79.8612], 'Nepal': [27.7172, 85.3240], 'Bhutan': [27.4728, 89.6390],
      'Afghanistan': [34.5553, 69.2075], 'Uzbekistan': [41.2995, 69.2401], 'Kazakhstan': [51.1694, 71.4491],
      'Kyrgyzstan': [42.8746, 74.5698], 'Tajikistan': [38.8610, 71.2761], 'Turkmenistan': [37.9601, 58.3261],
      'Azerbaijan': [40.4093, 49.8671], 'Armenia': [40.0691, 44.5147], 'Georgia': [41.7151, 44.8271],
      'Moldova': [47.0105, 28.8638], 'Belarus': [53.9006, 27.5590], 'Ukraine': [50.4501, 30.5234],
      'Serbia': [44.7866, 20.4489], 'Montenegro': [42.7087, 19.3744], 'Bosnia and Herzegovina': [43.8563, 18.4131],
      'North Macedonia': [41.9973, 21.4280], 'Albania': [41.1533, 19.6172], 'Kosovo': [42.6026, 21.1655],
      'Colombia': [4.7110, -74.0721], 'Venezuela': [10.4806, -66.9036], 'Ecuador': [-0.1807, -78.4678],
      'Bolivia': [-16.2902, -63.5887], 'Paraguay': [-25.2637, -57.5759], 'Uruguay': [-34.9011, -56.1645],
      'Guyana': [6.8013, -58.1551], 'Suriname': [5.8520, -55.2038], 'French Guiana': [3.9339, -53.1258],
    };
    
    final coords = countryCoordinates[country] ?? [37.7749, -122.4194]; // Default to San Francisco
    // Add small random variation to avoid exact overlap
    final latVariation = (index % 7 - 3) * 0.01; // -0.03 to +0.03 degrees
    return coords[0] + latVariation;
  }

  double _getCountryLongitude(String? country, int index) {
    final countryCoordinates = {
      'China': [39.9042, 116.4074], 'India': [28.7041, 77.1025], 'Germany': [52.5200, 13.4050],
      'Pakistan': [33.6844, 73.0479], 'Russia': [55.7558, 37.6176], 'United States': [38.9072, -77.0369],
      'Japan': [35.6762, 139.6503], 'United Kingdom': [51.5074, -0.1278], 'France': [48.8566, 2.3522],
      'Italy': [41.9028, 12.4964], 'Brazil': [-15.8267, -47.9218], 'Canada': [45.4215, -75.6972],
      'Australia': [-35.2809, 149.1300], 'Spain': [40.4168, -3.7038], 'Netherlands': [52.3676, 4.9041],
      'Sweden': [59.3293, 18.0686], 'Norway': [59.9139, 10.7522], 'South Korea': [37.5665, 126.9780],
      'Mexico': [19.4326, -99.1332], 'Argentina': [-34.6118, -58.3960], 'Belgium': [50.8503, 4.3517],
      'Switzerland': [46.9481, 7.4474], 'Austria': [48.2082, 16.3738], 'Denmark': [55.6761, 12.5683],
      'Finland': [60.1699, 24.9384], 'Singapore': [1.3521, 103.8198], 'Turkey': [39.9334, 32.8597],
      'Poland': [52.2297, 21.0122], 'Czech Republic': [50.0755, 14.4378], 'Greece': [37.9755, 23.7348],
      'Portugal': [38.7223, -9.1393], 'Hungary': [47.4979, 19.0402], 'Romania': [44.4268, 26.1025],
      'Bulgaria': [42.6977, 23.3219], 'Croatia': [45.8150, 15.9819], 'Slovenia': [46.0569, 14.5058],
      'Slovakia': [48.1486, 17.1077], 'Estonia': [59.4370, 24.7536], 'Latvia': [56.9496, 24.1052],
      'Lithuania': [54.6872, 25.2797], 'Iceland': [64.1466, -21.9426], 'Luxembourg': [49.6116, 6.1319],
      'Malta': [35.8997, 14.5146], 'Cyprus': [35.1856, 33.3823], 'Israel': [31.7683, 35.2137],
      'South Africa': [-25.7479, 28.2293], 'Egypt': [30.0444, 31.2357], 'Morocco': [34.0209, -6.8416],
      'Tunisia': [36.8065, 10.1815], 'Algeria': [36.7538, 3.0588], 'Libya': [32.8872, 13.1913],
      'Sudan': [15.5007, 32.5599], 'Ethiopia': [9.1450, 40.4897], 'Kenya': [-1.2921, 36.8219],
      'Uganda': [0.3476, 32.5825], 'Tanzania': [-6.7924, 39.2083], 'Rwanda': [-1.9441, 30.0619],
      'Ghana': [5.6037, -0.1870], 'Nigeria': [9.0765, 7.3986], 'Senegal': [14.7167, -17.4677],
      'Mali': [12.6392, -8.0029], 'Burkina Faso': [12.2383, -1.5616], 'Niger': [13.5116, 2.1254],
      'Chad': [12.1348, 15.0557], 'Cameroon': [3.8480, 11.5021], 'Thailand': [13.7563, 100.5018],
      'Vietnam': [21.0285, 105.8542], 'Philippines': [14.5995, 120.9842], 'Indonesia': [-6.2088, 106.8456],
      'Malaysia': [3.1390, 101.6869], 'Bangladesh': [23.8103, 90.4125], 'Myanmar': [19.7633, 96.0785],
      'Sri Lanka': [6.9271, 79.8612], 'Nepal': [27.7172, 85.3240], 'Bhutan': [27.4728, 89.6390],
      'Afghanistan': [34.5553, 69.2075], 'Uzbekistan': [41.2995, 69.2401], 'Kazakhstan': [51.1694, 71.4491],
      'Kyrgyzstan': [42.8746, 74.5698], 'Tajikistan': [38.8610, 71.2761], 'Turkmenistan': [37.9601, 58.3261],
      'Azerbaijan': [40.4093, 49.8671], 'Armenia': [40.0691, 44.5147], 'Georgia': [41.7151, 44.8271],
      'Moldova': [47.0105, 28.8638], 'Belarus': [53.9006, 27.5590], 'Ukraine': [50.4501, 30.5234],
      'Serbia': [44.7866, 20.4489], 'Montenegro': [42.7087, 19.3744], 'Bosnia and Herzegovina': [43.8563, 18.4131],
      'North Macedonia': [41.9973, 21.4280], 'Albania': [41.1533, 19.6172], 'Kosovo': [42.6026, 21.1655],
      'Colombia': [4.7110, -74.0721], 'Venezuela': [10.4806, -66.9036], 'Ecuador': [-0.1807, -78.4678],
      'Bolivia': [-16.2902, -63.5887], 'Paraguay': [-25.2637, -57.5759], 'Uruguay': [-34.9011, -56.1645],
      'Guyana': [6.8013, -58.1551], 'Suriname': [5.8520, -55.2038], 'French Guiana': [3.9339, -53.1258],
    };
    
    final coords = countryCoordinates[country] ?? [37.7749, -122.4194]; // Default to San Francisco
    // Add small random variation to avoid exact overlap
    final lngVariation = (index % 5 - 2) * 0.01; // -0.02 to +0.02 degrees
    return coords[1] + lngVariation;
  }
}
