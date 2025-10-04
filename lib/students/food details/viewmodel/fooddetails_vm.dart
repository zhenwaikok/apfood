import 'package:apfood/students/food%20details/model/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class FoodDetailsViewModel extends ChangeNotifier{

  String selectedOption = "Pickup (Takeaway)";

  final String itemId;
  FoodItemDetails? _foodItemDetails;
  bool _isLoading = true;

  FoodItemDetails? get foodItemDetails => _foodItemDetails;
  bool get isLoading => _isLoading; 


  FoodDetailsViewModel(this.itemId){
    _fetchFoodItemsDetails();
  }

  String formatPrice(double price)
  {
    final NumberFormat formatter = NumberFormat("0.00");
    return formatter.format(price);
  }

  void setSelectedOption(String value){
    selectedOption = value;
    notifyListeners();
  }

  Future<void> _fetchFoodItemsDetails() async
  {
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection("items").where("itemId", isEqualTo: itemId).get();

      if (querySnapshot.docs.isNotEmpty)
      {
        _foodItemDetails = FoodItemDetails.fromSnapshot(querySnapshot.docs.first);
      }
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }


}