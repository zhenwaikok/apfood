import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:apfood/vendors/Model/category_model.dart';

class CategoryViewModel extends ChangeNotifier {
  final String vendorId;
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get hasCategories => _categories.isNotEmpty;

  CategoryViewModel.fetchCategory(this.vendorId) {
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("categories")
          .where('vendor.vendorId', isEqualTo: vendorId)
          .get();

      _categories = querySnapshot.docs
          .map(
            (doc) => CategoryModel.fromSnapshot(doc),
          )
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
