class ClaimedPoint {
  final int id;
  final String userId;
  final String serial;
  final String name;
  final String mobile;
  final String productName;
  final String city;
  final String? customerContact;
  final String customerAddress;
  final String cnic;
  final String serialNum;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClaimedPoint({
    required this.id,
    required this.userId,
    required this.serial,
    required this.name,
    required this.mobile,
    required this.productName,
    required this.city,
    this.customerContact,
    required this.customerAddress,
    required this.cnic,
    required this.serialNum,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClaimedPoint.fromJson(Map<String, dynamic> json) {
    return ClaimedPoint(
      id: json['id'],
      userId: json['user_id'].toString(),
      serial: json['serial'],
      name: json['name'],
      mobile: json['mobile'],
      productName: json['product_name'],
      city: json['city'],
      customerContact: json['customer_contact'],
      customerAddress: json['customer_address'],
      cnic: json['cnic'],
      serialNum: json['serial_num'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'serial': serial,
      'name': name,
      'mobile': mobile,
      'product_name': productName,
      'city': city,
      'customer_contact': customerContact,
      'customer_address': customerAddress,
      'cnic': cnic,
      'serial_num': serialNum,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}