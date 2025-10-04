import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItems{
  final String notes;
  final String orderId;
  final String image_url;
  final String itemId;
  final String itemName;
  final double price;
  final int quantity;
  final String paymentOption;
  final String status;
  final String userId;
  final String username;
  final String vendorId;
  final DateTime orderTime;

  OrderItems({
    required this.notes,
     required this.orderId,
     required this.image_url,
    required this.itemId,
     required this.itemName,
     required this.price,
     required this.quantity,
     required this.paymentOption,
     required this.status,
     required this.userId,
     required this.username,
     required this.vendorId,
     required this.orderTime,
  });

  factory OrderItems.fromMap(Map<String,dynamic> data){
    print('OrderItems data: $data');
    
    return OrderItems(
      notes: data["additionalNotes"] ?? '',
      orderId: data["orderId"] ?? '',
      image_url: data["image_url"] ?? '',
      itemId: data["itemId"] ?? '',
      itemName: data["itemName"] ?? '',
      price: data["price"]?.toDouble() ?? 0.0,
      quantity: data["quantity"]?.toInt() ?? 0,
      paymentOption: data["paymentOption"] ?? '',
      status: data["status"] ?? '',
      userId: data["userId"] ?? '',
      username: data["username"] ?? '',
      vendorId: data["vendorId"] ?? '',
      orderTime: (data["orderTime"] as Timestamp).toDate(),
    );
  }
}