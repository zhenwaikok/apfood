import 'package:apfood/students/cart/model/cart_model.dart';
import 'package:apfood/students/orders/model/orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersViewModel extends ChangeNotifier{
  final String status;

  List<OrderItems> _orderItems = [];
  bool _isLoading = true;

  List<OrderItems> get orderItems => _orderItems;
  bool get isLoading => _isLoading;

  OrdersViewModel(this.status){
    fetchUserOrders(status);
  }

  String formateDateTime(DateTime date)
  {
    return DateFormat("yyyy-MM-dd HH:mm").format(date);
  }

  String formatPrice(double price)
  {
    final NumberFormat formatter = NumberFormat("0.00");
    return formatter.format(price);
  }




  //retrieve user orders
  Future<void> fetchUserOrders(String status) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null)
    {
      try
      {
        
        QuerySnapshot orderSnapshot = await FirebaseFirestore.instance.collection("order")
                                            .where("userId", isEqualTo: currentUserId)
                                            .where("status",isEqualTo: status)
                                            .get();

        _orderItems.clear();

        for(var doc in orderSnapshot.docs)
        {
          List<dynamic> orderItemsData = doc["orderItems"];

          for(var item in orderItemsData)
          {
            Map<String,dynamic> orderData = {
              "notes": doc["additionalNotes"],
              "orderId": doc["orderId"],
              "paymentOption": doc["paymentOption"],
              "status": doc["status"],
              "userId": doc["userId"],
              "username": doc["username"],
              "vendorId": doc["vendorId"],
              "orderTime":doc["orderTime"],
            }..addAll(item as Map<String,dynamic>);
            OrderItems orderItem = OrderItems.fromMap(orderData);
            _orderItems.add(orderItem);
          }
        }
        
      }
      finally
      {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  //add orders
  Future<void> addOrders(List<CartItems> cartItems, String paymentOption, String notes) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      final username = await fetchUsername(currentUserId);

      final orderRef = FirebaseFirestore.instance.collection("order").doc();

      final vendorId = cartItems.first.vendorId;

      final orderItems = cartItems.map((item){
        return {
          "itemId":item.itemId,
          "itemName":item.itemName,
          "price":item.price,
          "quantity":item.quantity,
          "image_url":item.image_url,
          "pickupType":item.pickupType,
        };
      }).toList();

      final orderDetails = {
        "orderId":orderRef.id,
        "orderItems":orderItems,
        "paymentOption":paymentOption,
        "status":"pending",
        "userId":currentUserId,
        "username":username,
        "orderTime":DateTime.now(),
        "vendorId":vendorId,
        "additionalNotes":notes,
      };

      await orderRef.set(
        orderDetails
      );
    }

    notifyListeners();
  }

  //get current username
  Future<String> fetchUsername(String userId) async{
    String username = "";
    try
    {
      final userDoc = await FirebaseFirestore.instance.collection("users").doc(userId).get();
      if(userDoc.exists)
      {
        final userData = userDoc.data();
        if(userData != null)
        {
          username = userData["username"];
        }
      }
    }
    catch(e)
    {
      print("error:$e");
    }
    return username;
  }
}