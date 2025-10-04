import 'package:apfood/students/favourite/model/favourite_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavouriteViewModel extends ChangeNotifier{
  List<FavouriteItem> _favouriteItem = [];
  bool _isLoading = true;

  List<FavouriteItem> get favouriteItem => _favouriteItem;
  bool get isLoading => _isLoading;


  FavouriteViewModel(){
    fetchUserFavourite();
  }

  bool isFavourite(String itemId)
  {
    return _favouriteItem.any((item) => item.itemId == itemId);
  }

  String formatPrice(double price)
  {
    final NumberFormat formatter = NumberFormat("0.00");
    return formatter.format(price);
  }

  //retrieve user favourite items
  Future<void> fetchUserFavourite() async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null)
    {
      try
      {
        final docSnapshot = await FirebaseFirestore.instance.collection("favourite").doc(currentUserId).get();
        if (docSnapshot.exists)
        {
          final data = docSnapshot.data();
          if(data != null && data.containsKey("favourites"))
          {
            final List favourites = data["favourites"];
            _favouriteItem = favourites.map((item) => FavouriteItem.fromMap(item as Map<String,dynamic>)).toList();
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

  //remove favourite item from firestore
  Future<void> removeFromFavourite(String itemId) async{

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    
    if(currentUserId != null)
    {
      try
        {
        final favouriteRef = FirebaseFirestore.instance.collection("favourite").doc(currentUserId);

        final docSnapshot = await favouriteRef.get();
        if(docSnapshot.exists)
        {
          final data = docSnapshot.data();
          if(data != null && data.containsKey("favourites"))
          {
            final List favourites = data["favourites"];
            favourites.removeWhere((item) => item["itemId"] == itemId);

            await favouriteRef.update({"favourites":favourites});

          }
          await fetchUserFavourite();
        }
      }
      finally
      {
        notifyListeners();
      }
    }
  }

  //add favourite item to firestore
  Future<void> addToFavourite(String itemId, String itemName, String image_url,double price) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null)
    {
      final favouriteRef = FirebaseFirestore.instance.collection("favourite").doc(currentUserId);


      final favouriteItemDetails = {
        "itemId": itemId,
        "itemName": itemName,
        "image_url": image_url,
        "price":price,
        "userId":currentUserId,
      };

      await favouriteRef.set(
        {
          "favourites": FieldValue.arrayUnion([favouriteItemDetails])
        }, SetOptions(merge:true)
      );

      fetchUserFavourite();
      notifyListeners();
    }
  }
}