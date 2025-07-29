class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? province;
  final String? city;
  final String? cnicNumber;
  final String? companyShopNumber;
  final String? role;
  final String? status;
  final int? tokens;
  final String? image;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.province,
    this.city,
    this.cnicNumber,
    this.companyShopNumber,
    required this.role,
    required this.status,
    required this.tokens,
    this.image,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      province: json['province'],
      city: json['city'],
      cnicNumber: json['cnic_number'],
      companyShopNumber: json['company_shop_number'],
      role: json['role'],
      status: json['status'],
      tokens: json['tokens'],
      image: json['image'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'province': province,
      'city': city,
      'cnic_number': cnicNumber,
      'company_shop_number': companyShopNumber,
      'role': role,
      'status': status,
      'tokens': tokens,
      'image': image,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
