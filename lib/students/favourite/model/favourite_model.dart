import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteItem{
  final String image_url;
  final String itemId;
  final String itemName;
  final double price;

  FavouriteItem({
    required this.image_url,
    required this.itemId,
    required this.itemName,
    required this.price,
  });

  factory FavouriteItem.fromMap(Map<String, dynamic> data){
    return FavouriteItem(
      image_url: data['image_url'] ?? '', 
      itemId: data['itemId'] ?? '',
      itemName: data['itemName'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}