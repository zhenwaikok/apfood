import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem{
  final String categoryId;
  final String categoryName;
  final String description;
  final String imageURL;
  final String itemId;
  final String itemName;
  final double price;
  final bool recommend;
  final String vendorName;

  FoodItem({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.imageURL,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.recommend,
    required this.vendorName,
  });

  factory FoodItem.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>;
    
    return FoodItem(
      categoryId: data['categoryId'] ?? '', 
      categoryName: data['categoryName'] ?? '', 
      description: data['description'] ?? '', 
      imageURL: data['image_url'] ?? '', 
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      recommend: data['recommend'] ?? false,
      vendorName: data['vendorName'] ?? '',
    );
  }
}