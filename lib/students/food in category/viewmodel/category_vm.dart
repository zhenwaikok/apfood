import 'package:apfood/students/food%20in%20category/model/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodCategoryViewModel extends ChangeNotifier{
  final String categoryName;
  List<FoodItem> _foodItems = [];
  bool _isLoading = true;

  List<FoodItem> get foodItems => _foodItems;
  bool get isLoading => _isLoading;

  FoodCategoryViewModel(this.categoryName){
    _fetchFoodItems();
  }

  String formatPrice(double price)
  {
    final NumberFormat formatter = NumberFormat("0.00");
    return formatter.format(price);
  }

  Future<void> _fetchFoodItems() async{
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection("items")
                                  .where('category.categoryName',isEqualTo: categoryName)
                                  .where('isAvailable',isEqualTo: true)
                                  .get();

      _foodItems = querySnapshot.docs.map((doc) => FoodItem.fromSnapshot(doc)).toList();
    }
    finally
    {
      _isLoading = false;
      notifyListeners();
    }
  }
}