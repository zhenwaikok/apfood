import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItemDetails{
  final String categoryId;
  final String categoryName;
  final String description;
  final String image_url;
  final String itemId;
  final String itemName;
  final double price;
  final String vendorId;

  FoodItemDetails({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.image_url,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.vendorId,
  });

  factory FoodItemDetails.fromSnapshot(DocumentSnapshot snapshot){
    final data = snapshot.data() as Map<String, dynamic>;

    final vendorData = data["vendor"] as Map<String, dynamic>;
    
    return FoodItemDetails(
      categoryId: data['categoryId'] ?? '', 
      categoryName: data['categoryName'] ?? '', 
      description: data['description'] ?? '', 
      image_url: data['image_url'] ?? '', 
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      vendorId: vendorData['vendorId'] ?? '',
    );
  }
}