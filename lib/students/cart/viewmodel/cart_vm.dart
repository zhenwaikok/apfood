import 'package:apfood/students/cart/model/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartViewModel extends ChangeNotifier{
  int _quantity = 1;
  List<CartItems> _cartItems = [];
  bool _isLoading = true;
  double _total = 0.0;
  String selectedPaymentOption = "AP Card";
  final TextEditingController notesController = TextEditingController(); 
  

  int get quantity => _quantity;
  bool get isLoading => _isLoading;
  List<CartItems> get cartItems => _cartItems;
  double get total => _total;


  CartViewModel(){
    fetchCartItems();  
  }

  String formatPrice(double price)
  {
    final NumberFormat formatter = NumberFormat("0.00");
    return formatter.format(price);
  }


  void setSelectedPaymentOptionState(value){
    selectedPaymentOption = value;
    notifyListeners();
  }

  Future<void> clearCartItems() async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      await FirebaseFirestore.instance.collection("cart").doc(currentUserId).update({
        "carts":[]
      });
    }

    fetchCartItems();
    notifyListeners();
  }


  //retrieve user cart items
  Future<void> fetchCartItems() async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      try
      {
        final docSnapshot = await FirebaseFirestore.instance.collection("cart").doc(currentUserId).get();

        if(docSnapshot.exists)
        {
          final data = docSnapshot.data();

          if(data != null && data.containsKey("carts"))
          {
            final List carts = data["carts"];
            _cartItems = carts.map((item) => CartItems.fromMap(item as Map<String, dynamic>)).toList();

            calculateTotal();
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


  //add cart items
  Future<void> addToCartItems(String itemId, String itemName,double price,int quantity, String pickupType, String image_url, String vendorId) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null)
    {
      final cartRef = FirebaseFirestore.instance.collection("cart").doc(currentUserId);

      //retrieve current cart items
      final docSnapshot = await cartRef.get();
      Map<String, dynamic>? cartData;
      if(docSnapshot.exists)
      {
        cartData = docSnapshot.data();
      }

      List carts = [];
      if(cartData != null && cartData.containsKey("carts"))
      {
        carts = cartData["carts"];
      }

      //check if user add the item is from same vendor
      if(carts.isNotEmpty && carts.any((item) => item["vendorId"] != vendorId))
      {

        //clear cart list if not same
        carts.clear();

        //update firestore
        await cartRef.set(
            {
              "carts":carts,
            },SetOptions(merge:true),
          );
      }

      //check if the item already exist in cart
      bool itemExist = false;
      for (var item in carts)
      {
        if(item["itemId"] == itemId)
        {
          item["quantity"] += quantity; //increase quantity
          itemExist = true;
          break;
        }
      }

      if(!itemExist)
      {
        final cartItems = {
          "itemId":itemId,
          "itemName":itemName,
          "price":price,
          "quantity":quantity,
          "pickupType":pickupType,
          "image_url": image_url,
          "userId":currentUserId,
          "vendorId":vendorId
        };

        carts.add(cartItems);
      }

      //update firestore
      await cartRef.set(
          {
            "carts":carts,
          },SetOptions(merge:true),
        );

      //refresh UI
      await fetchCartItems();
    }
  }

  //remove cart items
  Future<void> removeCartItems(String itemId) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      final cartRef = FirebaseFirestore.instance.collection("cart").doc(currentUserId);

      final docSnapshot = await cartRef.get();

      if(docSnapshot.exists)
      {
        final data = docSnapshot.data();
        if(data != null && data.containsKey("carts"))
        {
          final List carts = data["carts"];
          carts.removeWhere((item) => item["itemId"] == itemId);

          await cartRef.update({"carts":carts});

          await fetchCartItems();

        }
      }
    }
  }

  //add quantity
  void addQuantity(){
    _quantity = _quantity + 1;
    notifyListeners();
  }

  //minus quantity
  void minusQuantity(){
    if(_quantity > 1)
    {
      _quantity = _quantity - 1;
      notifyListeners();
    }
  }

  Future<void> updateAddQuantity(String itemId) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null)
    {
      final cartRef = FirebaseFirestore.instance.collection("cart").doc(currentUserId);

      //retrieve current cart items
      final docSnapshot = await cartRef.get();
      Map<String, dynamic>? cartData;
      if(docSnapshot.exists)
      {
        cartData = docSnapshot.data();
      }

      List carts = [];
      if(cartData != null && cartData.containsKey("carts"))
      {
        carts = cartData["carts"];
      }

       //increase quantity
      for (var item in carts)
      {
        if(item["itemId"] == itemId)
        {
          item["quantity"] += 1;
          break;
        }
      }

      //update firestore
      await cartRef.set(
        {
          "carts":carts,
        },SetOptions(merge:true),
      );

      //refresh UI
      await fetchCartItems();
    }
  }

  Future<void> updateMinusQuantity(String itemId) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null)
    {
      final cartRef = FirebaseFirestore.instance.collection("cart").doc(currentUserId);

      //retrieve current cart items
      final docSnapshot = await cartRef.get();
      Map<String, dynamic>? cartData;
      if(docSnapshot.exists)
      {
        cartData = docSnapshot.data();
      }

      List carts = [];
      if(cartData != null && cartData.containsKey("carts"))
      {
        carts = cartData["carts"];
      }

      //decrease quantity
      for (var item in carts)
      {
        if(item["itemId"] == itemId)
        {
          if(item["quantity"] > 1)
          {
            item["quantity"] -= 1; 
          }
          break;
        }
      }

      //update firestore
      await cartRef.set(
        {
          "carts":carts,
        },SetOptions(merge:true),
      );

      //refresh UI
      await fetchCartItems();
    }
  }

  void calculateTotal(){
    _total = 0.0;
    for(var item in cartItems)
    {
      _total += item.price * item.quantity;
    }
  }

}