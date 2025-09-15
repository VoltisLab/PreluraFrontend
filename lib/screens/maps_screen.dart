import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product_model.dart';
import '../providers/vendor_provider.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? _mapController;
  
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
          
          // Top overlay with back button and search
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
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back to Feed',
            ),
          ),
          const SizedBox(width: 12),
          // Search bar
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search vendors...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Toggle vendor list button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _showVendorList ? Icons.map : Icons.list,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() {
                  _showVendorList = !_showVendorList;
                });
              },
              tooltip: _showVendorList ? 'Hide List' : 'Show List',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorListOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Nearby Vendors',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Vendor list
            Expanded(
              child: Consumer<VendorProvider>(
                builder: (context, vendorProvider, child) {
                  final vendors = vendorProvider.vendors;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = vendors[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(vendor.logo),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        ),
                        title: Text(
                          vendor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          vendor.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        onTap: () => _selectVendor(vendor),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedVendorCard() {
    if (_selectedVendor == null) return const SizedBox.shrink();
    
    return Positioned(
      bottom: _showVendorList ? MediaQuery.of(context).size.height * 0.4 + 20 : 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(_selectedVendor!.logo),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedVendor!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _selectedVendor!.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
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
                      // Navigate to vendor details
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to vendor products
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Products'),
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
      bottom: _showVendorList ? MediaQuery.of(context).size.height * 0.4 + 20 : 20,
      right: 20,
      child: Column(
        children: [
          // My location button
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: () {
              _mapController?.animateCamera(
                CameraUpdate.newCameraPosition(_initialPosition),
              );
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          // Zoom in button
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: () {
              _mapController?.animateCamera(CameraUpdate.zoomIn());
            },
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: 12),
          // Zoom out button
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: AppColors.primary,
            onPressed: () {
              _mapController?.animateCamera(CameraUpdate.zoomOut());
            },
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
    );
  }
}
