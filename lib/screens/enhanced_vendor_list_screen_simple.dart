import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/vendor_provider.dart';
import '../widgets/vendor_card.dart';

class EnhancedVendorListScreen extends StatefulWidget {
  const EnhancedVendorListScreen({super.key});

  @override
  State<EnhancedVendorListScreen> createState() => EnhancedVendorListScreenState();
}

class EnhancedVendorListScreenState extends State<EnhancedVendorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = true;

  void scrollToTop() {
    // Scroll to top functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Suppliers'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<VendorProvider>(
              builder: (context, vendorProvider, child) {
                final vendors = vendorProvider.vendors;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: VendorCard(
                        vendor: vendors[index],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/vendor-shop',
                            arguments: vendors[index],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.4), width: 2.0),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search suppliers...',
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: IconButton(
            icon: const Icon(Icons.camera_alt, color: AppColors.primary),
            onPressed: _handleImageSearch,
            tooltip: 'Search by image',
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Future<void> _handleImageSearch() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image search coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
