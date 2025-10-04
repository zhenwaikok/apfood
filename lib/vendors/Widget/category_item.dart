import 'package:apfood/vendors/View/edit_category.dart';
import 'package:apfood/vendors/View/vendor_item.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({
    required this.categoryName,
    required this.categoryImage,
    required this.categoryId,
    super.key,
  });

  final String categoryName;
  final String categoryId;
  final String categoryImage;

  void deleteCategory(BuildContext context, String categoryId) async {
    Navigator.pop(context);

    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.delete(
        FirebaseFirestore.instance.collection("categories").doc(categoryId));

    QuerySnapshot itemsToDelete = await FirebaseFirestore.instance
        .collection("items")
        .where("category.categoryId", isEqualTo: categoryId)
        .get();

    for (var doc in itemsToDelete.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  void editCategory(BuildContext context) {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditCategoryScreen(
            categoryName: categoryName,
            categoryId: categoryId,
            categoryImage: categoryImage),
      ),
    );
  }

  void confirmDeleteModal(
      BuildContext context, String categoryId, String categoryName) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        title: const Text("Confirm Delete"),
        content: Text(
            "Are you sure you want to delete the $categoryName category and all items inside it?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteCategory(context, categoryId);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onLongPress: () {
          showModalBottomSheet(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      onTap: () {
                        editCategory(context);
                      },
                      leading: const Icon(Icons.edit),
                      title: const Text("Edit Category"),
                    ),
                    ListTile(
                      onTap: () {
                        confirmDeleteModal(context, categoryId, categoryName);
                      },
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Delete Category",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.black.withAlpha(30),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => VendorItemScreen(
                    categoryId: categoryId,
                    categoryName: categoryName,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("items")
                            .where("category.categoryId", isEqualTo: categoryId)
                            .snapshots(),
                        builder: (ctx, orderSnapshots) {
                          if (!orderSnapshots.hasData ||
                              orderSnapshots.data!.docs.isEmpty) {
                            return const Text(
                              "0 Item",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            );
                          }
                          int orderCount = orderSnapshots.data!.docs.length;
                          return Text(
                            "$orderCount Items",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Color.fromARGB(255, 0, 59, 115),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
