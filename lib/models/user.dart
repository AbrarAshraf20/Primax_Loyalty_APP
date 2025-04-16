// lib/models/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? province;
  final String? city;
  final String? cnic;
  final String? shopNumber;
  final String? address;
  final String role;
  final String? profileImage;
  final int points;
  final List<Address> addresses;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.province,
    this.city,
    this.cnic,
    this.shopNumber,
    this.address,
    required this.role,
    this.profileImage,
    required this.points,
    this.addresses = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Address> addresses = [];
    if (json['addresses'] != null) {
      addresses = (json['addresses'] as List)
          .map((address) => Address.fromJson(address))
          .toList();
    }

    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      province: json['province'],
      city: json['city'],
      cnic: json['cnic'],
      shopNumber: json['shop_number'],
      address: json['address'],
      role: json['role'] ?? 'user',
      profileImage: json['profile_image'],
      points: json['points'] ?? 0,
      addresses: addresses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'province': province,
      'city': city,
      'cnic': cnic,
      'shop_number': shopNumber,
      'address': address,
      'role': role,
      'profile_image': profileImage,
      'points': points,
      'addresses': addresses.map((address) => address.toJson()).toList(),
    };
  }

  // Create a copy of the user with updated fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? province,
    String? city,
    String? cnic,
    String? shopNumber,
    String? address,
    String? role,
    String? profileImage,
    int? points,
    List<Address>? addresses,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      province: province ?? this.province,
      city: city ?? this.city,
      cnic: cnic ?? this.cnic,
      shopNumber: shopNumber ?? this.shopNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      points: points ?? this.points,
      addresses: addresses ?? this.addresses,
    );
  }
}

class Address {
  final int? id;
  final String address;
  final String? street;
  final String? postcode;
  final String? apartment;
  final String label;

  Address({
    this.id,
    required this.address,
    this.street,
    this.postcode,
    this.apartment,
    required this.label,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      address: json['address'] ?? '',
      street: json['street'],
      postcode: json['postcode'],
      apartment: json['apartment'],
      label: json['label'] ?? 'Home',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'street': street,
      'postcode': postcode,
      'apartment': apartment,
      'label': label,
    };
  }
}