import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:geolocator/geolocator.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vendor_provider.dart';
import '../widgets/vendor_card.dart';
import '../models/product_model.dart';
import '../services/image_search_service.dart';
import 'enhanced_vendor_list_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'vendor_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  
  // Map settings
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 12,
  );
  
  Set<Marker> _markers = {};
  VendorModel? _selectedVendor;
  bool _showVendorList = false;
  
  @override
  void initState() {
    super.initState();
    _loadVendorMarkers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _loadVendorMarkers() {
    final vendorProvider = context.read<VendorProvider>();
    final vendors = vendorProvider.vendors;
    
    _markers = vendors.map((vendor) {
      return Marker(
        markerId: MarkerId(vendor.id),
        position: LatLng(
          vendor.address.latitude ?? 37.7749,
          vendor.address.longitude ?? -122.4194,
        ),
        infoWindow: InfoWindow(
          title: vendor.name,
          snippet: vendor.description,
          onTap: () => _selectVendor(vendor),
        ),
        onTap: () => _selectVendor(vendor),
      );
    }).toSet();
    
    if (mounted) setState(() {});
  }
  
  void _selectVendor(VendorModel vendor) {
    setState(() {
      _selectedVendor = vendor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMapHomeTab(),
          const EnhancedVendorListScreen(),
          const CartScreen(),
          authProvider.isSupplier ? const VendorDashboardScreen() : const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMapHomeTab() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Full-screen map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: _initialPosition,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          
          // Top overlay with search and controls
          _buildTopOverlay(),
          
          // Bottom vendor list overlay
          if (_showVendorList) _buildVendorListOverlay(),
          
          // Selected vendor details
          if (_selectedVendor != null) _buildSelectedVendorCard(),
          
          // Floating action buttons
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            // App title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Wholesalers B2B',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(color: AppColors.textSecondary.withOpacity(0.4), width: 2.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search vendors...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: AppColors.primary),
                        onPressed: _handleImageSearch,
                        tooltip: 'Search by image',
                      ),
                      IconButton(
                        icon: Icon(
                          _showVendorList ? Icons.map : Icons.list,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          setState(() {
                            _showVendorList = !_showVendorList;
                          });
                        },
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorListOverlay() {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusLarge),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                child: Row(
                  children: [
                    Icon(Icons.store, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text(
                      'Nearby Vendors',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Vendor list
              Expanded(
                child: Consumer<VendorProvider>(
                  builder: (context, vendorProvider, child) {
                    final vendors = vendorProvider.vendors;
                    
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                      itemCount: vendors.length,
                      itemBuilder: (context, index) {
                        final vendor = vendors[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: VendorCard(
                            vendor: vendor,
                            onTap: () => _selectVendorFromList(vendor),
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
      },
    );
  }

  Widget _buildSelectedVendorCard() {
    return Positioned(
      bottom: 100,
      left: AppConstants.paddingMedium,
      right: AppConstants.paddingMedium,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      _selectedVendor!.logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.store, color: AppColors.textHint);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedVendor!.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (_selectedVendor!.isVerified)
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                      Text(
                        _selectedVendor!.address.city,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (_selectedVendor!.rating > 0)
                        Text(
                          '⭐ ${_selectedVendor!.rating.toStringAsFixed(1)} (${_selectedVendor!.reviewCount} reviews)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedVendor = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/vendor-shop',
                        arguments: _selectedVendor,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View Store'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Set the selected vendor in product provider and navigate to search
                      Navigator.pushNamed(context, '/search');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                    child: const Text('Browse Products'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      right: AppConstants.paddingMedium,
      bottom: 200,
      child: Column(
        children: [
          FloatingActionButton(
            heroTag: 'location',
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: _getCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'filter',
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: () {
              // Show filter options
            },
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  void _selectVendorFromList(VendorModel vendor) {
    setState(() {
      _selectedVendor = vendor;
      _showVendorList = false;
    });
    
    // Move camera to vendor location
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            vendor.address.latitude ?? 37.7749,
            vendor.address.longitude ?? -122.4194,
          ),
          15,
        ),
      );
    }
  }

  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return;
      }
      
      Position position = await Geolocator.getCurrentPosition();
      
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15,
          ),
        );
      }
    } catch (e) {
      // Handle error
      debugPrint('Error getting location: $e');
    }
  }


  Widget _buildBottomNavigationBar() {
    final authProvider = context.watch<AuthProvider>();
    
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          activeIcon: Icon(Icons.store),
          label: 'Vendors',
        ),
        BottomNavigationBarItem(
          icon: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return badges.Badge(
                badgeContent: Text(
                  cartProvider.itemCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                ),
                showBadge: cartProvider.itemCount > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              );
            },
          ),
          activeIcon: const Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(authProvider.isSupplier ? Icons.dashboard_outlined : Icons.person_outlined),
          activeIcon: Icon(authProvider.isSupplier ? Icons.dashboard : Icons.person),
          label: authProvider.isSupplier ? 'Dashboard' : 'Profile',
        ),
      ],
    );
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
              // Set search query and navigate to search screen
              _searchController.text = result.searchTerms.first;
              Navigator.pushNamed(context, '/search');
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
