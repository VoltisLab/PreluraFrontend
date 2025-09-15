import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/product_model.dart';

class ImageSearchService {
  static final ImageSearchService _instance = ImageSearchService._internal();
  factory ImageSearchService() => _instance;
  ImageSearchService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Show image source selection dialog
  Future<XFile?> showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<XFile?>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Search by Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Take Photo'),
              subtitle: const Text('Use camera to capture an item'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _pickImageFromCamera();
                if (context.mounted) {
                  Navigator.pop(context, image);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select an existing photo'),
              onTap: () async {
                Navigator.pop(context);
                final image = await _pickImageFromGallery();
                if (context.mounted) {
                  Navigator.pop(context, image);
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Pick image from camera
  Future<XFile?> _pickImageFromCamera() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  /// Pick image from gallery
  Future<XFile?> _pickImageFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Process image and extract search terms
  Future<ImageSearchResult> processImageForSearch(XFile imageFile) async {
    try {
      // Read image bytes
      final bytes = await imageFile.readAsBytes();
      
      // Simulate AI/ML image processing
      // In a real app, you would use services like:
      // - Google Vision API
      // - AWS Rekognition
      // - Custom ML model
      // - TensorFlow Lite
      
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing time
      
      // Mock results based on common fashion items
      final mockResults = _generateMockSearchResults();
      
      return ImageSearchResult(
        success: true,
        searchTerms: mockResults['terms'] as List<String>,
        confidence: mockResults['confidence'] as double,
        detectedItems: mockResults['items'] as List<String>,
        suggestedCategories: mockResults['categories'] as List<String>,
        colors: mockResults['colors'] as List<String>,
        imageBytes: bytes,
      );
    } catch (e) {
      debugPrint('Error processing image: $e');
      return ImageSearchResult(
        success: false,
        error: 'Failed to process image: ${e.toString()}',
        imageBytes: await imageFile.readAsBytes(),
      );
    }
  }

  /// Generate mock search results for demonstration
  Map<String, dynamic> _generateMockSearchResults() {
    final fashionItems = [
      {
        'terms': ['vintage', 'leather', 'jacket', 'brown'],
        'items': ['Leather Jacket', 'Vintage Outerwear'],
        'categories': ['Outerwear', 'Jackets', 'Vintage'],
        'colors': ['Brown', 'Black', 'Tan'],
        'confidence': 0.85,
      },
      {
        'terms': ['denim', 'jeans', 'blue', 'casual'],
        'items': ['Denim Jeans', 'Casual Pants'],
        'categories': ['Bottoms', 'Jeans', 'Casual'],
        'colors': ['Blue', 'Indigo', 'Light Blue'],
        'confidence': 0.92,
      },
      {
        'terms': ['dress', 'floral', 'summer', 'vintage'],
        'items': ['Floral Dress', 'Summer Dress'],
        'categories': ['Dresses', 'Summer', 'Vintage'],
        'colors': ['Floral', 'Pink', 'White'],
        'confidence': 0.78,
      },
      {
        'terms': ['sneakers', 'white', 'athletic', 'shoes'],
        'items': ['White Sneakers', 'Athletic Shoes'],
        'categories': ['Shoes', 'Sneakers', 'Athletic'],
        'colors': ['White', 'Black', 'Gray'],
        'confidence': 0.88,
      },
      {
        'terms': ['handbag', 'leather', 'black', 'accessories'],
        'items': ['Leather Handbag', 'Black Bag'],
        'categories': ['Bags', 'Accessories', 'Leather'],
        'colors': ['Black', 'Brown', 'Tan'],
        'confidence': 0.81,
      },
    ];

    // Return random result for demo
    return fashionItems[DateTime.now().millisecond % fashionItems.length];
  }

  /// Search products using image analysis results
  Future<List<ProductModel>> searchProductsByImage(
    ImageSearchResult imageResult,
    List<ProductModel> allProducts,
  ) async {
    if (!imageResult.success || imageResult.searchTerms.isEmpty) {
      return [];
    }

    // Filter products based on detected terms
    final results = allProducts.where((product) {
      final productText = '${product.name} ${product.description} ${product.category} ${product.subcategory} ${product.tags.join(' ')}'.toLowerCase();
      
      // Check if any search terms match the product
      return imageResult.searchTerms.any((term) => 
        productText.contains(term.toLowerCase())
      );
    }).toList();

    // Sort by relevance (number of matching terms)
    results.sort((a, b) {
      final aText = '${a.name} ${a.description} ${a.category} ${a.subcategory} ${a.tags.join(' ')}'.toLowerCase();
      final bText = '${b.name} ${b.description} ${b.category} ${b.subcategory} ${b.tags.join(' ')}'.toLowerCase();
      
      final aMatches = imageResult.searchTerms.where((term) => 
        aText.contains(term.toLowerCase())
      ).length;
      final bMatches = imageResult.searchTerms.where((term) => 
        bText.contains(term.toLowerCase())
      ).length;
      
      return bMatches.compareTo(aMatches);
    });

    return results.take(20).toList(); // Return top 20 matches
  }

  /// Show image search results dialog
  void showImageSearchResults(
    BuildContext context,
    ImageSearchResult result,
    VoidCallback onSearchPressed,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Analysis Results'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result.imageBytes != null) ...[
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      result.imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (result.success) ...[
                Text(
                  'Detected Items:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: result.detectedItems.map((item) => Chip(
                    label: Text(item, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.blue[50],
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Search Terms:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(result.searchTerms.join(', ')),
                const SizedBox(height: 12),
                Text(
                  'Confidence: ${(result.confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: result.confidence > 0.8 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                Text(
                  'Error: ${result.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (result.success)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSearchPressed();
              },
              child: const Text('Search Products'),
            ),
        ],
      ),
    );
  }
}

class ImageSearchResult {
  final bool success;
  final List<String> searchTerms;
  final double confidence;
  final List<String> detectedItems;
  final List<String> suggestedCategories;
  final List<String> colors;
  final String? error;
  final Uint8List? imageBytes;

  ImageSearchResult({
    required this.success,
    this.searchTerms = const [],
    this.confidence = 0.0,
    this.detectedItems = const [],
    this.suggestedCategories = const [],
    this.colors = const [],
    this.error,
    this.imageBytes,
  });
}
