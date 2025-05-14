// lib/services/brand_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';

class BrandService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch brands from Firestore
  Future<List<Brand>> getBrands() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('brands')
          .orderBy('timestamp', descending: false)
          .get();

      List<Brand> brands = [];

      for (var doc in querySnapshot.docs) {
        brands.add(Brand(
          id: doc.id,
          name: doc['name'] ?? '',
          imageUrl: doc['imageUrl'] ?? doc['logo'] ?? '',
        ));
      }

      return brands;
    } catch (e) {
      print("Error fetching brands from Firestore: $e");
      throw Exception('Failed to fetch brands: $e');
    }
  }
}