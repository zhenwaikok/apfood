import 'package:apfood/vendors/Widget/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen(
      {required this.categoryName,
      required this.categoryId,
      required this.categoryImage,
      super.key});

  final String categoryName;
  final String categoryId;
  final String categoryImage;

  @override
  State<EditCategoryScreen> createState() {
    return _EditCategoryScreenState();
  }
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredCategoryName = "";

  File? _selectedImage;

  String capitalizeFirstLetter(String word) {
    if (word.isEmpty) {
      return word; // Return empty string if input is empty
    }
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  // splits the strings into list of word, applies the capitalizeFirstLetter function, then joins back the word into 1 string
  String capitalizeFirstLetters(String text) {
    return text.split(' ').map(capitalizeFirstLetter).join(' ');
  }

  void _editCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String capitalizedName = capitalizeFirstLetters(_enteredCategoryName);

      setState(() {
        _isLoading = true;
      });

      if (_selectedImage == null) {
        FirebaseFirestore.instance
            .collection("categories")
            .doc(widget.categoryId)
            .update(
          {
            "categoryName": capitalizedName,
          },
        );
      }

      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("category_images")
            .child("${widget.categoryId}.jpg");

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection("categories")
            .doc(widget.categoryId)
            .update(
          {
            "categoryName": capitalizedName,
            'image_url': imageUrl,
          },
        );
      }

      // Update category name in all the items document based on the category ID
      QuerySnapshot itemsSnapshot = await FirebaseFirestore.instance
          .collection("items")
          .where("category.categoryId", isEqualTo: widget.categoryId)
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (QueryDocumentSnapshot doc in itemsSnapshot.docs) {
        batch.update(doc.reference, {"category.categoryName": capitalizedName});
      }

      await batch.commit();

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category successfully edited!"),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 59, 115),
        foregroundColor: Colors.white,
        title: const Text("Edit Category"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _editCategory,
            icon: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ImagePickerWidget(
                  onPickImage: (pickedImage) {
                    _selectedImage = pickedImage;
                  },
                  isLoading: _isLoading,
                  initialImageUrl: widget.categoryImage,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: widget.categoryName,
                  readOnly: _isLoading ? true : false,
                  cursorColor: const Color.fromARGB(255, 0, 59, 115),
                  maxLength: 20,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Category Name"),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 59, 115),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter category name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredCategoryName = value!;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
