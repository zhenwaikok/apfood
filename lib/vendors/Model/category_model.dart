import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String imageURL;
  final String vendorName;
  final String vendorId;

  CategoryModel({
    required this.categoryId,
    required this.categoryName,
    required this.imageURL,
    required this.vendorName,
    required this.vendorId,
  });

  factory CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return CategoryModel(
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      imageURL: data['image_url'] ?? '',
      vendorName: data['vendorName'] ?? '',
      vendorId: data['vendorId'] ?? '',
    );
  }
}
