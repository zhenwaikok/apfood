import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminViewCategories extends StatefulWidget {
  final String currentVendorId;

  const AdminViewCategories({required this.currentVendorId, Key? key}) : super(key: key);

  @override
  _AdminViewCategoriesState createState() => _AdminViewCategoriesState();
}

class _AdminViewCategoriesState extends State<AdminViewCategories> {
  final CollectionReference categoriesCollection = FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF003B73),
        foregroundColor: Colors.white,
        title: const Text('View Categories'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriesCollection
            .where('vendor.vendorId', isEqualTo: widget.currentVendorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final categories = snapshot.data!.docs;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category['categoryName']),
                leading: category['image_url'] != null
                    ? Image.network(category['image_url'], width: 50, height: 50)
                    : const Icon(Icons.image, size: 50),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () => _viewCategory(category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editCategory(category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteCategory(category),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCategory,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _viewCategory(DocumentSnapshot category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(category['categoryName']),
          content: category['image_url'] != null
              ? Image.network(category['image_url'])
              : const Icon(Icons.image, size: 100),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _addCategory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        File? pickedImage;

        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Category Name'),
                onChanged: (value) => name = value,
              ),
              TextButton.icon(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      pickedImage = File(pickedFile.path);
                    });
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                String imageUrl = '';
                if (pickedImage != null) {
                  final ref = FirebaseStorage.instance.ref().child('category_images').child(name + '.jpg');
                  await ref.putFile(pickedImage!);
                  imageUrl = await ref.getDownloadURL();
                }
                await categoriesCollection.add({
                  'categoryName': name,
                  'image_url': imageUrl,
                  'vendor': {
                    'vendorId': widget.currentVendorId,
                    'vendorName': 'Vendor Name', // Replace with actual vendor name if available
                  },
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editCategory(DocumentSnapshot category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = category['categoryName'];
        File? pickedImage;

        return AlertDialog(
          title: const Text('Edit Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Category Name'),
                onChanged: (value) => name = value,
                controller: TextEditingController(text: name),
              ),
              TextButton.icon(
                onPressed: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      pickedImage = File(pickedFile.path);
                    });
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('Pick New Image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                String imageUrl = category['image_url'];
                if (pickedImage != null) {
                  final ref = FirebaseStorage.instance.ref().child('category_images').child(name + '.jpg');
                  await ref.putFile(pickedImage!);
                  imageUrl = await ref.getDownloadURL();
                }
                await categoriesCollection.doc(category.id).update({
                  'categoryName': name,
                  'image_url': imageUrl,
                  'vendor': {
                    'vendorId': widget.currentVendorId,
                    'vendorName': 'Vendor Name', // Replace with actual vendor name if available
                  },
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(DocumentSnapshot category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await categoriesCollection.doc(category.id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
