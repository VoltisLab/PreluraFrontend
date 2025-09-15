import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/vendor_provider.dart';
import '../widgets/vendor_card.dart';
import '../models/product_model.dart';
import '../services/image_search_service.dart';
import '../utils/country_emoji.dart';

enum ViewType { grid, list, compact, thumbnail }
enum SortType { alphabetical, rating, newest, location }

class EnhancedVendorListScreen extends StatefulWidget {
  const EnhancedVendorListScreen({super.key});

  @override
  State<EnhancedVendorListScreen> createState() => _EnhancedVendorListScreenState();
}

class _EnhancedVendorListScreenState extends State<EnhancedVendorListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ViewType _currentViewType = ViewType.grid;
  SortType _currentSortType = SortType.alphabetical;

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
        title: const Text(
          'Suppliers',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          _buildViewButton(),
          _buildSortButton(),
          const SizedBox(width: 8),
        ],
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

  Widget _buildViewTypeSelector() {
    return PopupMenuButton<ViewType>(
      icon: Icon(
        _getViewTypeIcon(_currentViewType),
        color: AppColors.textPrimary,
      ),
      onSelected: (ViewType viewType) {
        setState(() {
          _currentViewType = viewType;
        });
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<ViewType>(
          value: ViewType.grid,
          child: Row(
            children: [
              Icon(
                Icons.grid_view,
                color: _currentViewType == ViewType.grid 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                'Grid View',
                style: TextStyle(
                  color: _currentViewType == ViewType.grid 
                      ? AppColors.primary 
                      : AppColors.textPrimary,
                  fontWeight: _currentViewType == ViewType.grid 
                      ? FontWeight.w600 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ViewType>(
          value: ViewType.list,
          child: Row(
            children: [
              Icon(
                Icons.view_list,
                color: _currentViewType == ViewType.list 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                'List View',
                style: TextStyle(
                  color: _currentViewType == ViewType.list 
                      ? AppColors.primary 
                      : AppColors.textPrimary,
                  fontWeight: _currentViewType == ViewType.list 
                      ? FontWeight.w600 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ViewType>(
          value: ViewType.compact,
          child: Row(
            children: [
              Icon(
                Icons.view_compact,
                color: _currentViewType == ViewType.compact 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                'Compact View',
                style: TextStyle(
                  color: _currentViewType == ViewType.compact 
                      ? AppColors.primary 
                      : AppColors.textPrimary,
                  fontWeight: _currentViewType == ViewType.compact 
                      ? FontWeight.w600 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<ViewType>(
          value: ViewType.thumbnail,
          child: Row(
            children: [
              Icon(
                Icons.photo_size_select_actual,
                color: _currentViewType == ViewType.thumbnail 
                    ? AppColors.primary 
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                'Thumbnail View',
                style: TextStyle(
                  color: _currentViewType == ViewType.thumbnail 
                      ? AppColors.primary 
                      : AppColors.textPrimary,
                  fontWeight: _currentViewType == ViewType.thumbnail 
                      ? FontWeight.w600 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getViewTypeIcon(ViewType viewType) {
    switch (viewType) {
      case ViewType.grid:
        return Icons.grid_view;
      case ViewType.list:
        return Icons.view_list;
      case ViewType.compact:
        return Icons.view_compact;
      case ViewType.thumbnail:
        return Icons.photo_size_select_actual;
    }
  }

  Widget _buildViewButton() {
    return IconButton(
      icon: Icon(
        _getViewTypeIcon(_currentViewType),
        color: AppColors.textPrimary,
      ),
      onPressed: () => _showViewBottomSheet(context),
    );
  }

  Widget _buildSortButton() {
    return IconButton(
      icon: const Icon(
        Icons.sort,
        color: AppColors.textPrimary,
      ),
      onPressed: () => _showSortBottomSheet(context),
    );
  }

  void _showViewBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'View Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // View toggle using current design
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider.withOpacity(0.3), width: 2.0),
                ),
                child: Row(
                  children: [
                    _buildModalViewToggleButton(ViewType.grid, Icons.grid_view, 'Grid'),
                    _buildModalViewToggleButton(ViewType.list, Icons.view_list, 'List'),
                    _buildModalViewToggleButton(ViewType.compact, Icons.view_compact, 'Compact'),
                    _buildModalViewToggleButton(ViewType.thumbnail, Icons.photo_size_select_actual, 'Thumbnail'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModalViewToggleButton(ViewType viewType, IconData icon, String label) {
    final isSelected = _currentViewType == viewType;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentViewType = viewType;
          });
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Sort options
            _buildSortOption(
              SortType.alphabetical,
              Icons.sort_by_alpha,
              'Alphabetical',
              'A to Z order',
            ),
            _buildSortOption(
              SortType.rating,
              Icons.star_outline,
              'Highest Rated',
              'Best rated suppliers first',
            ),
            _buildSortOption(
              SortType.newest,
              Icons.access_time,
              'Newest First',
              'Recently added suppliers',
            ),
            _buildSortOption(
              SortType.location,
              Icons.location_on_outlined,
              'By Location',
              'Grouped by location',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(SortType sortType, IconData icon, String title, String subtitle) {
    final isSelected = _currentSortType == sortType;
    
    return InkWell(
      onTap: () {
        setState(() {
          _currentSortType = sortType;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppColors.primary.withOpacity(0.1) 
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium, 
            0, 
            AppConstants.paddingMedium, 
            AppConstants.paddingMedium
          ),
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
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: AppColors.primary),
                    onPressed: _handleImageSearch,
                    tooltip: 'Search by image',
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
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
        ),
        const SizedBox(height: 8),
        _buildSearchTags(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildViewToggleBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildViewToggleButton(ViewType.grid, Icons.grid_view, 'Grid'),
          _buildViewToggleButton(ViewType.list, Icons.view_list, 'List'),
          _buildViewToggleButton(ViewType.compact, Icons.view_compact, 'Compact'),
          _buildViewToggleButton(ViewType.thumbnail, Icons.photo_size_select_actual, 'Thumbnail'),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(ViewType viewType, IconData icon, String label) {
    final isSelected = _currentViewType == viewType;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentViewType = viewType;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTags() {
    final suggestedTags = [
      'Fashion', 'Electronics', 'Home & Garden', 'Sports', 'Books', 'Beauty'
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        itemCount: suggestedTags.length,
        itemBuilder: (context, index) {
          final tag = suggestedTags[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _searchQuery = tag;
                  _searchController.text = tag;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVendorList() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, child) {
        var vendors = vendorProvider.vendors.where((vendor) {
          final query = _searchQuery.toLowerCase();
          return vendor.name.toLowerCase().contains(query) ||
                 vendor.address.city.toLowerCase().contains(query) ||
                 vendor.address.country.toLowerCase().contains(query) ||
                 vendor.description.toLowerCase().contains(query) ||
                 _matchesSearchTag(vendor, query);
        }).toList();

        // Apply sorting
        vendors = _sortVendors(vendors);

        if (vendors.isEmpty) {
          return const Center(
            child: Text('No vendors found'),
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
          child: _buildViewContent(vendors),
        );
      },
    );
  }

  Widget _buildViewContent(List<VendorModel> vendors) {
    Widget content;
    
    switch (_currentViewType) {
      case ViewType.grid:
        content = _buildGridView(vendors);
        break;
      case ViewType.list:
        content = _buildListView(vendors);
        break;
      case ViewType.compact:
        content = _buildCompactView(vendors);
        break;
      case ViewType.thumbnail:
        content = _buildThumbnailView(vendors);
        break;
    }
    
    // Add a unique key based on view type to ensure AnimatedSwitcher works
    return KeyedSubtree(
      key: ValueKey(_currentViewType),
      child: content,
    );
  }

  List<VendorModel> _sortVendors(List<VendorModel> vendors) {
    switch (_currentSortType) {
      case SortType.alphabetical:
        vendors.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.rating:
        vendors.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortType.newest:
        vendors.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortType.location:
        vendors.sort((a, b) => a.address.country.compareTo(b.address.country));
        break;
    }
    return vendors;
  }

  Widget _buildGridView(List<VendorModel> vendors) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.69, // Keep the bottom fix
        crossAxisSpacing: 4, // Further reduced to achieve -3px target
        mainAxisSpacing: 16,
      ),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return VendorCard(
          vendor: vendors[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              '/vendor-shop',
              arguments: vendors[index],
            );
          },
        );
      },
    );
  }

  Widget _buildListView(List<VendorModel> vendors) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return _buildListViewCard(vendor);
      },
    );
  }

  Widget _buildListViewCard(VendorModel vendor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.divider.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/vendor-shop',
            arguments: vendor,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Vendor Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.divider.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: vendor.logo,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.store, color: AppColors.textSecondary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.store, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Vendor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${vendor.address.city}, ${CountryEmoji.getCountryWithFlag(vendor.address.country)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vendor.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${vendor.reviewCount} reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactView(List<VendorModel> vendors) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return _buildCompactCard(vendor);
      },
    );
  }

  Widget _buildCompactCard(VendorModel vendor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.divider.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/vendor-shop',
            arguments: vendor,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Small Logo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.divider.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: vendor.logo,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.store, size: 20, color: AppColors.textSecondary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.store, size: 20, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Vendor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textSecondary.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${vendor.address.city}, ${CountryEmoji.getCountryWithFlag(vendor.address.country)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary.withOpacity(0.8),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 14,
                    color: Colors.amber[600],
                  ),
                  const SizedBox(width: 2),
                  Text(
                    vendor.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailView(List<VendorModel> vendors) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8, // Improved aspect ratio to prevent overflow
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final vendor = vendors[index];
        return _buildThumbnailCard(vendor);
      },
    );
  }

  Widget _buildThumbnailCard(VendorModel vendor) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/vendor-shop',
          arguments: vendor,
        );
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          side: BorderSide(
            color: AppColors.divider.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            // Profile Photo
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusLarge),
                    topRight: Radius.circular(AppConstants.radiusLarge),
                  ),
                  border: Border.all(
                    color: AppColors.divider.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusLarge),
                    topRight: Radius.circular(AppConstants.radiusLarge),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: vendor.logo,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.store, color: AppColors.textSecondary, size: 32),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surface,
                      child: const Icon(Icons.store, color: AppColors.textSecondary, size: 32),
                    ),
                  ),
                ),
              ),
            ),
            // Shop Name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                vendor.name,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            // Description (Rating + Country)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start, // Changed from center to start
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          vendor.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _matchesSearchTag(VendorModel vendor, String query) {
    // Match fashion subcategory tags with vendor properties
    switch (query.toLowerCase()) {
      case 'streetwear':
        return vendor.description.toLowerCase().contains('streetwear') ||
               vendor.description.toLowerCase().contains('urban') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('streetwear'));
      case 'vintage':
        return vendor.description.toLowerCase().contains('vintage') ||
               vendor.description.toLowerCase().contains('retro') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('vintage'));
      case 'denim':
        return vendor.description.toLowerCase().contains('denim') ||
               vendor.description.toLowerCase().contains('jeans') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('denim'));
      case 'activewear':
        return vendor.description.toLowerCase().contains('activewear') ||
               vendor.description.toLowerCase().contains('athletic') ||
               vendor.description.toLowerCase().contains('sports') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('activewear'));
      case 'outerwear':
        return vendor.description.toLowerCase().contains('outerwear') ||
               vendor.description.toLowerCase().contains('jackets') ||
               vendor.description.toLowerCase().contains('coats') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('outerwear'));
      case 'footwear':
        return vendor.description.toLowerCase().contains('footwear') ||
               vendor.description.toLowerCase().contains('shoes') ||
               vendor.description.toLowerCase().contains('sneakers') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('footwear'));
      case 'accessories':
        return vendor.description.toLowerCase().contains('accessories') ||
               vendor.description.toLowerCase().contains('bags') ||
               vendor.description.toLowerCase().contains('jewelry') ||
               vendor.categories.any((cat) => cat.toLowerCase().contains('accessories'));
      case 'premium':
        return vendor.description.toLowerCase().contains('premium') ||
               vendor.description.toLowerCase().contains('luxury') ||
               vendor.description.toLowerCase().contains('designer') ||
               vendor.rating >= 4.5;
      default:
        return false;
    }
  }

  Future<void> _handleImageSearch() async {
    try {
      final imageSearchService = ImageSearchService();
      
      // Show image source selection dialog
      final imageFile = await imageSearchService.showImageSourceDialog(context);
      if (imageFile == null) return;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Analyzing image...'),
            ],
          ),
        ),
      );

      // Process the image
      final result = await imageSearchService.processImageForSearch(imageFile);
      
      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show results and handle search
      if (mounted) {
        imageSearchService.showImageSearchResults(
          context,
          result,
          () {
            if (result.success && result.searchTerms.isNotEmpty) {
              // Set search query
              _searchController.text = result.searchTerms.join(' ');
              setState(() {
                _searchQuery = result.searchTerms.join(' ');
              });
            }
          },
        );
      }
    } catch (e) {
      // Close loading dialog if open
      if (mounted) Navigator.pop(context);
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
