// lib/models/address_model.dart
import 'dart:convert';

class Address {
  final int? id;
  final String? userId;
  final String? address;
  final String? street;
  final String? postcode;
  final String? apartment;
  final String? latitude;
  final String? longitude;
  final String? label;
  final String? createdAt;
  final String? updatedAt;
  
  // Legacy fields for backward compatibility
  final bool isDefault;
  final String postalCode;
  final String city;
  final String state;
  final String country;

  Address({
    this.id,
    this.userId,
    this.address,
    this.street,
    this.postcode,
    this.apartment,
    this.latitude,
    this.longitude,
    this.label,
    this.createdAt,
    this.updatedAt,
    this.isDefault = false,
    this.city = '',
    this.state = '',
    this.country = '',
    this.postalCode = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    // Handle potential parsing issues
    int? id;
    if (json['id'] != null) {
      if (json['id'] is int) {
        id = json['id'];
      } else if (json['id'] is String) {
        id = int.tryParse(json['id']);
      }
    }
    
    return Address(
      id: id,
      userId: json['user_id']?.toString(),
      address: json['address']?.toString(),
      street: json['street']?.toString(),
      postcode: json['postcode']?.toString(),
      apartment: json['apartment']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      label: json['label']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      // Legacy fields for backward compatibility
      postalCode: json['postcode']?.toString() ?? json['postal_code']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      isDefault: json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (address != null) 'address': address,
      if (street != null) 'street': street,
      if (postcode != null) 'postcode': postcode,
      if (apartment != null) 'apartment': apartment,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (label != null) 'label': label,
      // Don't include timestamps in requests
      // 'created_at': createdAt,
      // 'updated_at': updatedAt,
    };
  }

  Address copyWith({
    int? id,
    String? userId,
    String? address,
    String? street,
    String? postcode,
    String? apartment,
    String? latitude,
    String? longitude,
    String? label,
    String? createdAt,
    String? updatedAt,
    bool? isDefault,
    String? city,
    String? state,
    String? country,
    String? postalCode,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address: address ?? this.address,
      street: street ?? this.street,
      postcode: postcode ?? this.postcode,
      apartment: apartment ?? this.apartment,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDefault: isDefault ?? this.isDefault,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  @override
  String toString() {
    return 'Address{id: $id, address: $address, street: $street, apartment: $apartment, postcode: $postcode, label: $label, lat: $latitude, lng: $longitude}';
  }

  // Parse API response with different structures
  static List<Address> parseAddresses(dynamic json) {
    // Case 1: Success response with user object (single address)
    if (json is Map<String, dynamic> && 
        json['status'] == 'success' && 
        json['user'] != null) {
      final address = Address.fromJson(json['user']);
      return [address];
    }
    
    // Case 2: Array of addresses
    else if (json is List) {
      return json.map((item) => Address.fromJson(item)).toList();
    }
    
    // Case 3: Object with addresses array
    else if (json is Map<String, dynamic> && json['addresses'] != null) {
      final addressesData = json['addresses'] as List;
      return addressesData.map((item) => Address.fromJson(item)).toList();
    }
    
    // Case 4: Single address object directly
    else if (json is Map<String, dynamic> && 
             (json['address'] != null || json['street'] != null)) {
      return [Address.fromJson(json)];
    }
    
    // Default: empty list
    return [];
  }
}