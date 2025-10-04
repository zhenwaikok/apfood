import 'dart:io';
import 'package:apfood/vendors/Widget/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() {
    return _AddCategoryScreenState();
  }
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredCategoryName = "";
  var _isLoading = false;
  File? _selectedImage;
  Map<String, String> vendorInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchVendorInfo();
  }

  Future<void> _fetchVendorInfo() async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;

    await db.collection("users").doc(currentUserId).get().then(
      (DocumentSnapshot doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        vendorInfo = {
          "vendorId": currentUserId,
          "vendorName": data['username']
        };
      },
    );
  }

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

  Future<bool> _isCategoryNameExists(String categoryName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('vendor.vendorId', isEqualTo: vendorInfo['vendorId'])
        .where('categoryName', isEqualTo: categoryName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String capitalizedName = capitalizeFirstLetters(_enteredCategoryName);

      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please add category image"),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final isExists = await _isCategoryNameExists(capitalizedName);
      if (isExists) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Category name already exists for this vendor"),
          ),
        );
        return;
      }

      final docRef = FirebaseFirestore.instance.collection('categories').doc();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("category_images")
          .child("${docRef.id}.jpg");

      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await docRef.set({
        'categoryName': capitalizedName,
        'categoryId': docRef.id,
        'image_url': imageUrl,
        'vendor': vendorInfo
      });

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category successfully added!"),
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
        title: const Text("Add Category"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveCategory,
            icon: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : const Icon(Icons.add),
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
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
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
