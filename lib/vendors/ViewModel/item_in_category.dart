import 'package:apfood/vendors/Model/item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemInCategoryViewModel extends ChangeNotifier {
  final String categoryId;
  List<ItemModel> _items = [];
  bool _isLoading = true;

  List<ItemModel> get items => _items;
  bool get isLoading => _isLoading;

  ItemInCategoryViewModel.fetchFoodItem(this.categoryId) {
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("items")
          .where('category.categoryId', isEqualTo: categoryId)
          .get();

      _items = querySnapshot.docs
          .map(
            (doc) => ItemModel.fromSnapshot(doc),
          )
          .toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFoodItem(BuildContext context, String itemId) async {
    try {
      await FirebaseFirestore.instance.collection("items").doc(itemId).delete();

      _items.removeWhere((item) => item.itemId == itemId);

      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete item successful!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting item'),
        ),
      );
    }
  }

  Future<void> refreshItems() async {
    await _fetchFoodItems();
    notifyListeners();
  }
}
