import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constants/app_colors.dart';
import '../widgets/modal_dropdown.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _brandController = TextEditingController();
  final _customTagsController = TextEditingController();
  final _customProcessingDaysController = TextEditingController();
  final _deliveryTimeController = TextEditingController();

  String _selectedCategory = '';
  String _selectedCondition = 'New';
  String _selectedSize = '';
  String _selectedBrand = '';
  List<String> _selectedTags = [];
  List<File> _selectedImages = [];
  bool _isVintage = false;
  bool _isSustainable = false;
  bool _isHandmade = false;
  bool _isNegotiable = true;
  bool _isShippingIncluded = false;
  String _shippingMethod = 'Standard';
  int _processingTime = 1;
  bool _useCustomProcessingDays = false;
  String _generatedSku = '';

  final List<String> _categories = [
    'Clothing',
    'Shoes',
    'Accessories',
    'Bags',
    'Jewelry',
    'Beauty',
    'Home & Living',
    'Electronics',
    'Books',
    'Sports',
    'Toys',
    'Other'
  ];

  final List<String> _conditions = [
    'New',
    'Like New',
    'Used/2nd hand',
    'Good',
    'Fair',
    'Poor'
  ];

  final List<String> _sizes = [
    'XS', 'S', 'M', 'L', 'XL', 'XXL',
    'UK 4', 'UK 6', 'UK 8', 'UK 10', 'UK 12', 'UK 14', 'UK 16',
    'US 0', 'US 2', 'US 4', 'US 6', 'US 8', 'US 10', 'US 12', 'US 14',
    'EU 32', 'EU 34', 'EU 36', 'EU 38', 'EU 40', 'EU 42', 'EU 44', 'EU 46',
    'One Size', 'Custom'
  ];

  final List<String> _popularTags = [
    'Vintage', 'Y2K', 'Cottagecore', 'Dark Academia', 'Streetwear',
    'Minimalist', 'Boho', 'Grunge', 'Preppy', 'Gothic', 'Kawaii',
    'Sustainable', 'Handmade', 'Designer', 'Luxury', 'Affordable'
  ];

  final List<String> _brands = [
    'Nike', 'Adidas', 'Zara', 'H&M', 'Uniqlo', 'Gap', 'Levi\'s', 'Tommy Hilfiger',
    'Calvin Klein', 'Ralph Lauren', 'Gucci', 'Prada', 'Chanel', 'Louis Vuitton',
    'Versace', 'Armani', 'Burberry', 'Hermès', 'Dior', 'Balenciaga', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _generateSku();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    _dimensionsController.dispose();
    _brandController.dispose();
    _customTagsController.dispose();
    _customProcessingDaysController.dispose();
    _deliveryTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text(
              'Save Draft',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              const SizedBox(height: 24),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildPricingSection(),
              const SizedBox(height: 24),
              _buildDetailsSection(),
              const SizedBox(height: 24),
              _buildShippingSection(),
              const SizedBox(height: 24),
              _buildTagsSection(),
              const SizedBox(height: 24),
              _buildSpecialFeaturesSection(),
              const SizedBox(height: 40),
              _buildPublishButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add up to 10 photos. First photo will be your cover image.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        _selectedImages.isEmpty
            ? _buildAddImageButton()
            : _buildImageGrid(),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.divider,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'Add Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select from gallery',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _selectedImages.length + (_selectedImages.length < 10 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _selectedImages.length) {
          return _buildAddMoreButton();
        }
        return _buildImageItem(_selectedImages[index], index);
      },
    );
  }

  Widget _buildAddMoreButton() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(
          Icons.add,
          color: AppColors.textSecondary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildImageItem(File image, int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (index == 0)
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Cover',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _titleController,
          label: 'Product Title',
          hint: 'e.g., Vintage 90s Denim Jacket',
          maxLines: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a product title';
            }
            if (value.length < 10) {
              return 'Title must be at least 10 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _descriptionController,
          label: 'Description',
          hint: 'Tell buyers about your item...',
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            if (value.length < 20) {
              return 'Description must be at least 20 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ModalDropdown(
          label: 'Category',
          value: _selectedCategory.isEmpty ? null : _selectedCategory,
          items: _categories,
          onChanged: (value) => setState(() => _selectedCategory = value ?? ''),
          icon: Icons.category_outlined,
          hint: 'Select category',
          validator: (value) => value == null || value.isEmpty ? 'Please select a category' : null,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModalDropdown(
                label: 'Condition',
                value: _selectedCondition,
                items: _conditions,
                onChanged: (value) => setState(() => _selectedCondition = value ?? 'New'),
                icon: Icons.verified_outlined,
                hint: 'Select condition',
                itemSubtitles: {
                  'New': 'Brand new item that has never been used',
                  'Like New': 'Gently used with minimal signs of wear',
                  'Used/2nd hand': 'Previously owned item in good working condition',
                  'Good': 'Used with some signs of wear but still functional',
                  'Fair': 'Well-used with visible wear but works properly',
                  'Poor': 'Heavily used with significant wear or damage',
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModalDropdown(
                label: 'Size',
                value: _selectedSize.isEmpty ? null : _selectedSize,
                items: _sizes,
                onChanged: (value) => setState(() => _selectedSize = value ?? ''),
                icon: Icons.straighten_outlined,
                hint: 'Select size',
                validator: (value) => value == null || value.isEmpty ? 'Please select a size' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModalDropdown(
                label: 'Brand',
                value: _selectedBrand.isEmpty ? null : _selectedBrand,
                items: _brands,
                onChanged: (value) => setState(() => _selectedBrand = value ?? ''),
                icon: Icons.branding_watermark_outlined,
                hint: 'Select brand',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: TextEditingController(text: _generatedSku),
                label: 'SKU (Auto-generated)',
                hint: 'Auto-generated',
                enabled: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _priceController,
                label: 'Selling Price',
                hint: '0.00',
                keyboardType: TextInputType.number,
                prefix: Container(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: const Text(
                    '£',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _originalPriceController,
                label: 'Original Price (Optional)',
                hint: '0.00',
                keyboardType: TextInputType.number,
                prefix: Container(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: const Text(
                    '£',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _quantityController,
          label: 'Quantity Available',
          hint: '1',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter quantity';
            }
            if (int.tryParse(value) == null || int.parse(value) < 1) {
              return 'Please enter a valid quantity';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                title: const Text(
                  'Price Negotiable',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'Allow buyers to make offers',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isNegotiable,
                onChanged: (value) => setState(() => _isNegotiable = value),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: 'Weight (Optional)',
                hint: 'e.g., 500g',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _dimensionsController,
                label: 'Dimensions (Optional)',
                hint: 'L x W x H cm',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text(
            'Shipping Included',
            style: TextStyle(fontSize: 14),
          ),
          subtitle: const Text(
            'Include shipping cost in price',
            style: TextStyle(fontSize: 12),
          ),
          value: _isShippingIncluded,
          onChanged: (value) => setState(() => _isShippingIncluded = value),
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        ModalDropdown(
          label: 'Shipping Method',
          value: _shippingMethod,
          items: ['Standard', 'Express', 'Next Day', 'Collection Only'],
          onChanged: (value) => setState(() => _shippingMethod = value ?? 'Standard'),
          icon: Icons.local_shipping_outlined,
          hint: 'Select shipping method',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModalDropdown(
                label: 'Processing Time',
                value: _useCustomProcessingDays ? 'Custom' : _processingTime.toString(),
                items: ['1', '2', '3', '5', '7', '14', 'Custom'],
                onChanged: (value) {
                  if (value == 'Custom') {
                    setState(() => _useCustomProcessingDays = true);
                  } else {
                    setState(() {
                      _useCustomProcessingDays = false;
                      _processingTime = int.parse(value ?? '1');
                    });
                  }
                },
                icon: Icons.schedule_outlined,
                hint: 'Select processing time',
              ),
            ),
            if (_useCustomProcessingDays) ...[
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _customProcessingDaysController,
                  label: 'Custom Days',
                  hint: 'e.g., 10',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _deliveryTimeController,
          label: 'Estimated Delivery Time',
          hint: 'e.g., 3-5 business days',
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add tags to help buyers find your item',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedTags.remove(tag);
                  } else if (_selectedTags.length < 5) {
                    _selectedTags.add(tag);
                  }
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _customTagsController,
          label: 'Add Custom Tags',
          hint: 'Enter custom tags separated by commas',
          onSubmitted: _addCustomTags,
        ),
        if (_selectedTags.length >= 5)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Maximum 5 tags selected',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecialFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Special Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text(
            'Vintage Item',
            style: TextStyle(fontSize: 14),
          ),
          subtitle: const Text(
            'Item is from a previous era',
            style: TextStyle(fontSize: 12),
          ),
          value: _isVintage,
          onChanged: (value) => setState(() => _isVintage = value),
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
        ),
        SwitchListTile(
          title: const Text(
            'Sustainable',
            style: TextStyle(fontSize: 14),
          ),
          subtitle: const Text(
            'Eco-friendly or sustainable item',
            style: TextStyle(fontSize: 12),
          ),
          value: _isSustainable,
          onChanged: (value) => setState(() => _isSustainable = value),
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
        ),
        SwitchListTile(
          title: const Text(
            'Handmade',
            style: TextStyle(fontSize: 14),
          ),
          subtitle: const Text(
            'Item is handmade or custom',
            style: TextStyle(fontSize: 12),
          ),
          value: _isHandmade,
          onChanged: (value) => setState(() => _isHandmade = value),
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildPublishButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _publishProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Publish Product',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    Widget? prefix,
    String? Function(String?)? validator,
    bool enabled = true,
    Function(String)? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefix: prefix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }


  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        for (XFile image in images) {
          if (_selectedImages.length < 10) {
            _selectedImages.add(File(image.path));
          }
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _publishProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one photo'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate product creation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      Navigator.pop(context); // Close add product screen
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product published successfully! 🎉'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  void _generateSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = (timestamp.length > 6) ? timestamp.substring(timestamp.length - 6) : timestamp;
    setState(() {
      _generatedSku = 'SKU-$random';
    });
  }

  void _addCustomTags(String value) {
    if (value.trim().isNotEmpty) {
      final tags = value.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
      setState(() {
        for (String tag in tags) {
          if (!_selectedTags.contains(tag) && _selectedTags.length < 5) {
            _selectedTags.add(tag);
          }
        }
      });
      _customTagsController.clear();
    }
  }

}
