import 'dart:io';
import 'package:apfood/vendors/Widget/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() {
    return _AddItemScreenState();
  }
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredItemName = "";
  var _enteredPrice = 0.0;
  var _enteredDescription = "";
  var _selectedCategory = "";
  bool isRecommended = false;
  List<Map<String, String>> _categories = [];
  var _isLoading = false;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  File? _selectedImage;
  Map<String, String> vendorInfo = {};

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchVendorInfo();
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

  Future<void> _fetchCategories() async {
    // fetch available categories for dropdownmenu based on the current user id
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("vendor.vendorId", isEqualTo: currentUserId)
        .get();
    final List<Map<String, String>> fetchedCategories = [];
    // iterate over the collection and add to fetchedCategories list
    for (var doc in snapshot.docs) {
      fetchedCategories.add({
        'categoryId': doc['categoryId'],
        'categoryName': doc['categoryName']
      });
    }
    setState(() {
      _categories = fetchedCategories;
      // set _selectedCategory to the first category name in the list of maps
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first['categoryName']!;
      }
    });
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String capitalizedName = capitalizeFirstLetters(_enteredItemName);

      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please add item image"),
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final selectedCategoryMap = _categories.firstWhere(
        (category) => category['categoryName'] == _selectedCategory,
      );

      final docRef = FirebaseFirestore.instance.collection('items').doc();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("item_images")
          .child("${docRef.id}.jpg");

      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      String docId = docRef.id;

      await docRef.set({
        'itemId': docId,
        'itemName': capitalizedName,
        'category': selectedCategoryMap,
        'price': _enteredPrice,
        'description': _enteredDescription,
        'isAvailable': true,
        'image_url': imageUrl,
        'vendor': vendorInfo,
        'isRecommended': isRecommended
      });

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Menu item successfully added!"),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 59, 115),
        foregroundColor: Colors.white,
        title: const Text("Add Menu Item"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _saveItem,
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
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 59, 115),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter item name";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredItemName = value!;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                  value: _selectedCategory,
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration(
                    label: Text("Category"),
                    floatingLabelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 59, 115),
                      ),
                    ),
                    fillColor: Colors.white,
                  ),
                  items: _categories
                      .map((category) => DropdownMenuItem(
                            value: category['categoryName'],
                            child: Text(category['categoryName']!),
                          ))
                      .toList(),
                  onChanged: _isLoading
                      ? null
                      : (String? value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please add at least 1 category";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                TextFormField(
                  readOnly: _isLoading ? true : false,
                  cursorColor: const Color.fromARGB(255, 0, 59, 115),
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Price"),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 59, 115),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null ||
                        double.tryParse(value)! <= 0) {
                      return "Enter valid price";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPrice = double.parse(value!);
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  readOnly: _isLoading ? true : false,
                  cursorColor: const Color.fromARGB(255, 0, 59, 115),
                  maxLength: 50,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Description"),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 0, 59, 115),
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter description";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredDescription = value!;
                  },
                ),
                Row(
                  children: [
                    const Text(
                      "Recommended",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isRecommended,
                      onChanged: _isLoading
                          ? null
                          : (value) {
                              setState(
                                () {
                                  isRecommended = value;
                                },
                              );
                            },
                      activeTrackColor: const Color.fromARGB(255, 0, 59, 115),
                      inactiveThumbColor: const Color.fromARGB(255, 0, 59, 115),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
