import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String categoryId;
  final String categoryName;
  final String description;
  final String imageURL;
  final String itemId;
  final String itemName;
  final double price;
  final bool isAvailable;
  final bool isRecommended;
  final String vendorName;
  final String vendorId;

  ItemModel({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.imageURL,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.isAvailable,
    required this.isRecommended,
    required this.vendorName,
    required this.vendorId,
  });

  factory ItemModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return ItemModel(
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      description: data['description'] ?? '',
      imageURL: data['image_url'] ?? '',
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      isAvailable: data['isAvailable'] ?? false,
      isRecommended: data['isRecommended'] ?? false,
      vendorName: data['vendorName'] ?? '',
      vendorId: data['vendorId'] ?? '',
    );
  }
}
