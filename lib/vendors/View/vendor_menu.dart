import 'package:apfood/vendors/View/add_category.dart';
import 'package:apfood/vendors/View/add_item.dart';
import 'package:apfood/vendors/ViewModel/category.dart';
import 'package:apfood/vendors/Widget/category_item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorMenuScreen extends StatefulWidget {
  const VendorMenuScreen({super.key});

  @override
  State<VendorMenuScreen> createState() {
    return _MenuScreenState();
  }
}

class _MenuScreenState extends State<VendorMenuScreen> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _addCategoryPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AddCategoryScreen()),
    );
  }

  void _addItemPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const AddItemScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryViewModel.fetchCategory(currentUserId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 59, 115),
          title: const Text(
            "M E N U",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("categories")
                    .where("vendor.vendorId", isEqualTo: currentUserId)
                    .snapshots(),
                builder: (ctx, categorySnapshots) {
                  if (categorySnapshots.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!categorySnapshots.hasData ||
                      categorySnapshots.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                          "Category empty, Please add category to start adding items"),
                    );
                  }

                  final loadedCategories = categorySnapshots.data!.docs;

                  return ListView.builder(
                    itemCount: loadedCategories.length,
                    itemBuilder: (ctx, index) {
                      final category = loadedCategories[index].data();
                      final categoryName = category["categoryName"];
                      final categoryImage = category["image_url"];
                      final categoryId = category["categoryId"];
                      return CategoryItemWidget(
                        categoryName: categoryName,
                        categoryImage: categoryImage,
                        categoryId: categoryId,
                      );
                    },
                  );
                },
              ),
            ),
            // Consumer<CategoryViewModel>(builder: (context, viewModel, child) {
            //   return ListView.builder(
            //     itemCount: viewModel.categories.length,
            //     itemBuilder: (context, index) {
            //       final category = viewModel.categories[index];

            //       return CategoryItemWidget(
            //         category: category,
            //       );
            //     },
            //   );
            // }),
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addItemPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 59, 115),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text("Add Item"),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addCategoryPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 59, 115),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text("Add Category"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
