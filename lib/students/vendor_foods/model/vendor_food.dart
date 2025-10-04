import 'package:cloud_firestore/cloud_firestore.dart';


class VendorFoodItems{

  final String categoryId;
  final String categoryName;
  final String description;
  final String image_url;
  final String itemId;
  final String itemName;
  final double price;
  final bool recommend;
  final String vendorId;
  final String vendorName;

  VendorFoodItems({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.image_url,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.recommend,
    required this.vendorId,
    required this.vendorName,
  });

  factory VendorFoodItems.fromSnapshot(DocumentSnapshot snapshot)
  {
    final data = snapshot.data() as Map<String, dynamic>;

    return VendorFoodItems(
      categoryId: data['categoryId'] ?? '', 
      categoryName: data['categoryName'] ?? '',  
      description: data['description'] ?? '',  
      image_url: data['image_url'] ?? '', 
      itemId: data['itemId'] ?? '', 
      itemName: data['itemName'] ?? '', 
      price: (data['price'] as num?)?.toDouble() ?? 0.0,  
      recommend: data['recommend'] ?? false, 
      vendorId: data['vendorId'] ?? '',
      vendorName: data['vendorName'] ?? '', 
    );
  }
}