import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:primax/core/providers/profile_provider.dart';
import 'package:primax/core/utils/app_colors.dart';
import 'package:primax/models/address_model.dart';
import 'package:primax/screen/profile_screen/add_new_address.dart';
import 'package:primax/core/network/api_client.dart';
import 'package:primax/core/di/service_locator.dart';

class MyAddressesScreen extends StatefulWidget {
  const MyAddressesScreen({Key? key}) : super(key: key);

  @override
  _MyAddressesScreenState createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen> {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Direct API call to get the address
      final apiClient = locator<ApiClient>();
      final response = await apiClient.get('/get-address');
      print('📡 Direct API Response: ${response.data}');

      // Parse addresses using the new helper method
      final addresses = Address.parseAddresses(response.data);
      print('📌 Parsed addresses: $addresses');

      if (addresses.isNotEmpty) {
        setState(() {
          _addresses = addresses;
          _isLoading = false;
        });
      } else {
        setState(() {
          _addresses = [];
          _isLoading = false;
          _errorMessage = 'No address data found in response';
        });
      }
    } catch (e) {
      print('❌ Error during address loading: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading addresses: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
            ),
          ),
        ),
        actions: [
          // Debug button to force refresh addresses
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAddresses,
          ),
        ],
        elevation: 0,
      ),
      body: _buildBody(),
      // floatingActionButton: Container(
      //   width: 56,
      //   height: 56,
      //   decoration: const BoxDecoration(
      //     shape: BoxShape.circle,
      //     gradient: LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black26,
      //         blurRadius: 8.0,
      //         offset: Offset(0, 3),
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton(
      //     onPressed: () => _navigateToAddAddress(context),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0,
      //     child: const Icon(Icons.add, color: Colors.white),
      //   ),
      // ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_addresses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No addresses found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a new shipping address to use for your orders',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddAddress(context),
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ).copyWith(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return const Color(0xFF00C853);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAddresses,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return _buildAddressCard(context, address);
        },
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label badge (Home, Work, Other)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF00C853).withOpacity(0.1),
                  Color(0xFF00B0FF).withOpacity(0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: Text(
                address.label ?? 'Address',
                style: const TextStyle(
                  color: Colors.white, // This color is a placeholder and will be replaced by the gradient
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Address content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.teal, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address.address ?? 'No address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Street
                if (address.street != null && address.street!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Text(
                      'Street: ${address.street}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                
                // Apartment (if provided)
                if (address.apartment != null && address.apartment!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 4),
                    child: Text(
                      'Apartment: ${address.apartment}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                
                // Postcode
                if (address.postcode != null && address.postcode!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 4),
                    child: Text(
                      'Postcode: ${address.postcode ?? address.postalCode}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                
                // Coordinates (if available)
                if (address.latitude != null && address.longitude != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 28, top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.location_searching, color: Colors.grey, size: 14),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Coordinates: ${address.latitude}, ${address.longitude}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                const SizedBox(height: 16),
                
                // Action buttons
                Row(
                  children: [
                    // Edit button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToEditAddress(context, address),
                        icon: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                        label: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Text('Edit', style: TextStyle(color: Colors.white)),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF00C853)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Delete button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDeleteAddress(context, address),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete', style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddAddress(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewAddressScreen(),
      ),
    );
    
    if (result == true) {
      _loadAddresses();
    }
  }

  Future<void> _navigateToEditAddress(BuildContext context, Address address) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewAddressScreen(address: address),
      ),
    );
    
    if (result == true) {
      _loadAddresses();
    }
  }

  Future<void> _confirmDeleteAddress(BuildContext context, Address address) async {
    // Store the scaffold messenger before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF00B0FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirmed == true && address.id != null) {
      // Check if widget is still mounted before proceeding
      if (!mounted) return;
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        final success = await profileProvider.deleteAddress(address.id!);
        
        // Check if widget is still mounted before using context
        if (!mounted) return;
        
        if (success) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Address deleted successfully')),
          );
          _loadAddresses();
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error: ${profileProvider.errorMessage}')),
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (e) {
        // Use the stored scaffold messenger instead of context
        // scaffoldMessenger.showSnackBar(
        //   SnackBar(content: Text('Error deleting address: $e')),
        // );
        // if (mounted) {
        //   setState(() {
        //     _isLoading = false;
        //   });
        // }
      }
    }
  }
}