import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/vendor_provider.dart';
import '../widgets/vendor_card.dart';

class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key});

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vendors'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildVendorList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search vendors...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            borderSide: BorderSide(color: AppColors.divider.withOpacity(0.3)),
          ),
          filled: true,
          fillColor: AppColors.background,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildVendorList() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, child) {
        if (vendorProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (vendorProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${vendorProvider.error}',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => vendorProvider.loadVendors(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<dynamic> filteredVendors = vendorProvider.vendors;
        if (_searchQuery.isNotEmpty) {
          filteredVendors = vendorProvider.searchVendors(_searchQuery);
        }

        if (filteredVendors.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                SizedBox(height: 16),
                Text(
                  'No vendors found',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
          itemCount: filteredVendors.length,
          itemBuilder: (context, index) {
            final vendor = filteredVendors[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
              child: VendorCard(
                vendor: vendor,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/vendor-shop',
                    arguments: vendor,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
