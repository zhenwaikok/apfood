import 'package:apfood/vendors/Model/item_model.dart';
import 'package:apfood/vendors/Widget/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({required this.item, super.key});

  final ItemModel item;

  @override
  State<EditItemScreen> createState() {
    return _EditItemScreenState();
  }
}

class _EditItemScreenState extends State<EditItemScreen> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  var _enteredItemName = "";
  var _enteredPrice = 0.0;
  var _enteredDescription = "";
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
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

  void _editItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String capitalizedName = capitalizeFirstLetters(_enteredItemName);

      setState(() {
        _isLoading = true;
      });

      if (_selectedImage == null) {
        FirebaseFirestore.instance
            .collection("items")
            .doc(widget.item.itemId)
            .update(
          {
            "itemName": capitalizedName,
            "price": _enteredPrice,
            "description": _enteredDescription,
          },
        );
      }

      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("item_images")
            .child("${widget.item.itemId}.jpg");

        await storageRef.putFile(_selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection("items")
            .doc(widget.item.itemId)
            .update(
          {
            "itemName": capitalizedName,
            "price": _enteredPrice,
            "description": _enteredDescription,
            'image_url': imageUrl,
          },
        );
      }

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item successfully edited!"),
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
        title: const Text("Edit Item"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _editItem,
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
                  initialImageUrl: widget.item.imageURL,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue: widget.item.itemName,
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
                TextFormField(
                  initialValue: widget.item.price.toString(),
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
                  initialValue: widget.item.description,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
