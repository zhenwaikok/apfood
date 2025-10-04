import 'package:apfood/students/vendor_foods/model/vendor_food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorFoodViewModel extends ChangeNotifier{

  final String vendorId;
  List<VendorFoodItems> _vendorFoodItems = [];
  bool _isLoading = true;

  List<VendorFoodItems> get vendorFoodItems => _vendorFoodItems;
  bool get isLoading => _isLoading;

  VendorFoodViewModel(this.vendorId){
    _fetchVendorFoodItems();
  }



  Future<void> _fetchVendorFoodItems() async{
    try
    {
      final querySnapshot = await FirebaseFirestore.instance.collection("items")
                                  .where('vendor.vendorId',isEqualTo: vendorId)
                                  .where('isAvailable',isEqualTo: true)
                                  .get();
    
      _vendorFoodItems = querySnapshot.docs.map((docs) => VendorFoodItems.fromSnapshot(docs)).toList();
    }
    finally{
      _isLoading = false;
      notifyListeners();
    }
  }
}