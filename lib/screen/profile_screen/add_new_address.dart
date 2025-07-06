import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/models/address_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AddNewAddressScreen extends StatefulWidget {
  final Address? address; // Pass existing address for editing, null for new address

  const AddNewAddressScreen({Key? key, this.address}) : super(key: key);
  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  String _selectedLabel = 'Home'; // Default to Home
  bool _isEditMode = false;
  
  // Map related variables
  GoogleMapController? _mapController;
  CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(24.8607, 67.0011), // Default position - Karachi
    zoom: 15,
  );

  LatLng _currentPosition = LatLng(24.8607, 67.0011);
  bool _isMapLoading = true;
  Set<Marker> _markers = {};
  
  @override
  void initState() {
    super.initState();

    // If editing, populate the form with existing address data
    if (widget.address != null) {
      _isEditMode = true;
      _streetController.text = widget.address!.street ?? '';
      _addressController.text = widget.address!.address ?? '';
      _postalCodeController.text = widget.address!.postcode ?? widget.address!.postalCode;
      _apartmentController.text = widget.address!.apartment ?? '';
      _selectedLabel = widget.address!.label ?? "Home";

      // If location coordinates are available, set initial camera position
      if (widget.address!.latitude != null && widget.address!.longitude != null) {
        try {
          final lat = double.parse(widget.address!.latitude!);
          final lng = double.parse(widget.address!.longitude!);
          _currentPosition = LatLng(lat, lng);
          _initialCameraPosition = CameraPosition(
            target: _currentPosition,
            zoom: 15,
          );
        } catch (e) {
          // Continue with default position if parsing fails
          print('Error parsing location coordinates: $e');
        }
      }
    } else {
      // For new addresses, ensure Home is selected by default
      _selectedLabel = 'Home';
    }

    // Delay location permission request to avoid context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
      // Force UI update to ensure default label selection is visible
      setState(() {});
    });
  }

  @override
  void dispose() {
    _streetController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _apartmentController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
  
  Future<void> _requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled. Please enable location services.')),
        );
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permissions are denied. You can still select a location on the map.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permissions are permanently denied. Please enable them in settings.'),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );
        return;
      }

      // If we got here, permissions are granted
      _getCurrentLocation();
    } catch (e) {
      print('Error requesting location permission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error accessing location services. You can still select a location on the map.')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _initialCameraPosition = CameraPosition(
            target: _currentPosition,
            zoom: 15,
          );

          // Update marker
          _updateMarker();
        });

        // If map controller is initialized, animate to current position
        if (_mapController != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_currentPosition),
          );
        }
        // Get address from coordinates
        _getAddressFromLatLng();
      }
    } catch (e) {
      print('Error getting current location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get your current location. You can still select a location on the map.')),
        );
      }
    }
  }
  
  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude, 
        _currentPosition.longitude
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        _addressController.text = '${place.street}, ${place.subLocality}, ${place.locality}';
        _streetController.text = place.street ?? '';
        _postalCodeController.text = place.postalCode ?? '';
      }
    } catch (e) {
      print('Error getting address from coordinates: $e');
    }
  }
  
  void _updateMarker() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId('selected_location'),
        position: _currentPosition,
        draggable: false,
      ),
    );
  }
  
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapLoading = false;
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _currentPosition = position;
      _updateMarker();
    });

    // Move camera to the selected position
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );

    // Get address from the new coordinates
    _getAddressFromLatLng();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return Stack(
            children: [
              // Main content
              Column(
                children: [
                  // Map section
                  Stack(
                    children: [
                      // Google Map
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: GoogleMap(
                          initialCameraPosition: _initialCameraPosition,
                          onMapCreated: _onMapCreated,
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          onTap: _onMapTap,
                        ),
                      ),
                      
                      // Loading indicator for map
                      if (_isMapLoading)
                        Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),

                      // Back button
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.arrow_back_ios_new, size: 16),
                            ),
                          ),
                        ),
                      ),

                      // Location edit button
                      // Positioned(
                      //   top: 120,
                      //   left: 0,
                      //   right: 0,
                      //   child: Center(
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      //       decoration: BoxDecoration(
                      //         color: Colors.black87,
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //       child: Text(
                      //         'Tap on map to select location',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 14,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Current location button
                      Positioned(
                        top: 16,
                        right: 16,
                        child: SafeArea(
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: Colors.white,
                            onPressed: _getCurrentLocation,
                            child: Icon(Icons.my_location, color: Colors.blue),
                          ),
                        ),
                      ),

                      // Location marker in center
                      if (!_isMapLoading)
                        Positioned(
                          top: 115, // Adjusted to be in the center
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Form section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Address label
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),

                            // Full address display
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.teal,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _addressController,
                                    decoration: InputDecoration(
                                      hintText: "Enter your full address",
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24),

                            // Two column layout for Street and Post code
                            Row(
                              children: [
                                // Street
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Street',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      _buildFormField(
                                        controller: _streetController,
                                        hintText: 'Street name',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),

                                // Post code
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Post code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      _buildFormField(
                                        controller: _postalCodeController,
                                        hintText: 'Postal code',
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24),

                            // Apartment
                            Text(
                              'Apartment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            _buildFormField(
                              controller: _apartmentController,
                              hintText: 'Apartment, suite, etc. (optional)',
                              isRequired: false, // Mark as optional
                            ),

                            SizedBox(height: 24),

                            // Label selection
                            Text(
                              'Label as',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 12),
                            _buildLabelSelection(),

                            SizedBox(height: 32),

                            // Save button
                            _buildSaveButton(profileProvider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Loading indicator
              if (profileProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: isRequired ? (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        } : null, // No validation for optional fields
      ),
    );
  }

  Widget _buildLabelSelection() {
    return Row(
      children: [
        _buildLabelOption('Home'),
        SizedBox(width: 12),
        _buildLabelOption('Work'),
        SizedBox(width: 12),
        _buildLabelOption('Other'),
      ],
    );
  }

  Widget _buildLabelOption(String label) {
    final isSelected = _selectedLabel == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLabel = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF2196F3),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ProfileProvider profileProvider) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4CAF50),
            Color(0xFF2196F3),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: profileProvider.isLoading ? null : _saveAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Save location',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      bool success;

      // Convert coordinates to strings for API
      final latitude = _currentPosition.latitude.toString();
      final longitude = _currentPosition.longitude.toString();

      // Debug print to check the label value
      print('🏷️ Selected Label: $_selectedLabel');
      print('📍 Address Details:');
      print('  - Street: ${_streetController.text}');
      print('  - Address: ${_addressController.text}');
      print('  - Postal Code: ${_postalCodeController.text}');
      print('  - Apartment: ${_apartmentController.text}');
      print('  - Latitude: $latitude');
      print('  - Longitude: $longitude');

      if (_isEditMode && widget.address?.id != null) {
        // Update existing address
        success = await profileProvider.updateAddress(
          addressId: widget.address!.id!,
          street: _streetController.text,
          address: _addressController.text,
          postalCode: _postalCodeController.text,
          label: _selectedLabel,
          apartment: _apartmentController.text,
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        // Add new address
        success = await profileProvider.addAddress(
          street: _streetController.text,
          address: _addressController.text,
          postalCode: _postalCodeController.text,
          label: _selectedLabel,
          apartment: _apartmentController.text,
          latitude: latitude,
          longitude: longitude,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditMode ? 'Address updated successfully' : 'Address added successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${profileProvider.errorMessage}')),
        );
      }
    }
  }
}