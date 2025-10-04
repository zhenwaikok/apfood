import 'package:apfood/vendors/Model/item_model.dart';
import 'package:apfood/vendors/ViewModel/item_in_category.dart';
import 'package:apfood/vendors/Widget/shimmer_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({required this.item, required this.onEdit, super.key});

  final ItemModel item;
  final VoidCallback onEdit;

  @override
  State<ItemWidget> createState() {
    return _ItemWidgetState();
  }
}

class _ItemWidgetState extends State<ItemWidget> {
  var isAvailable;
  var isRecommended;

  @override
  void initState() {
    isAvailable = widget.item.isAvailable;
    isRecommended = widget.item.isRecommended;
    super.initState();
  }

  void toggleAvailable(bool value) {
    setState(
      () {
        isAvailable = value;
      },
    );

    FirebaseFirestore.instance
        .collection("items")
        .doc(widget.item.itemId)
        .update(
      {'isAvailable': isAvailable},
    );
  }

  void toggleRecommended(bool value) {
    setState(() {
      isRecommended = value;
    });

    FirebaseFirestore.instance
        .collection("items")
        .doc(widget.item.itemId)
        .update(
      {"isRecommended": isRecommended},
    );
  }

  void deleteItem(String itemId) async {
    Navigator.pop(context);
    final provider =
        Provider.of<ItemInCategoryViewModel>(context, listen: false);
    await provider.deleteFoodItem(context, itemId);
  }

  void confirmDeleteModal(
      BuildContext context, String itemId, String itemName) {
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
        content: Text("Are you sure you want to delete $itemName?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteItem(itemId);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void editItem(BuildContext context) {
    Navigator.pop(context);
    widget.onEdit();
  }

  void viewItemDetails() {
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShimmerImageWidget(
                      imageURL: widget.item.imageURL,
                      height: 200,
                      width: double.infinity),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.item.itemName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            "RM ${widget.item.price.toString()}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      ),
                      Text(
                        widget.item.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isRecommended ? "Recommended" : "Not Recommended",
                            style: TextStyle(
                                color:
                                    isRecommended ? Colors.green : Colors.red),
                          ),
                          Switch(
                            value: isRecommended,
                            onChanged: (value) {
                              setState(() {
                                isRecommended = value;
                              });
                              toggleRecommended(value);
                            },
                            activeTrackColor:
                                const Color.fromARGB(255, 0, 59, 115),
                            inactiveThumbColor:
                                const Color.fromARGB(255, 0, 59, 115),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isAvailable ? "Available" : "Not Available",
                            style: TextStyle(
                                color: isAvailable ? Colors.green : Colors.red),
                          ),
                          Switch(
                            value: isAvailable,
                            onChanged: (value) {
                              setState(() {
                                isAvailable = value;
                              });
                              toggleAvailable(value);
                            },
                            activeTrackColor:
                                const Color.fromARGB(255, 0, 59, 115),
                            inactiveThumbColor:
                                const Color.fromARGB(255, 0, 59, 115),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                confirmDeleteModal(context, widget.item.itemId,
                                    widget.item.itemName);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Icon(Icons.delete),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onEdit();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 59, 115),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Icon(Icons.edit),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
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
                      onTap: viewItemDetails,
                      leading: const Icon(Icons.content_paste_search),
                      title: const Text("View Details"),
                    ),
                    if (isAvailable == false)
                      ListTile(
                        onTap: () {
                          toggleAvailable(true);
                          Navigator.pop(context);
                        },
                        leading: const Icon(Icons.check_circle),
                        title: const Text("Make Available"),
                      ),
                    if (isAvailable == true)
                      ListTile(
                        onTap: () {
                          toggleAvailable(false);
                          Navigator.pop(context);
                        },
                        leading: const Icon(Icons.cancel),
                        title: const Text("Make Unavailable"),
                      ),
                    ListTile(
                      onTap: () {
                        editItem(context);
                      },
                      leading: const Icon(Icons.edit),
                      title: const Text("Edit Item"),
                    ),
                    ListTile(
                      onTap: () {
                        confirmDeleteModal(
                            context, widget.item.itemId, widget.item.itemName);
                      },
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      title: const Text(
                        "Delete Item",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        onTap: viewItemDetails,
        child: Card(
          color: Colors.white,
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                ShimmerImageWidget(
                    imageURL: widget.item.imageURL, height: 85, width: 85),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        widget.item.itemName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isAvailable)
                      const Text(
                        "Available",
                        style: TextStyle(color: Colors.green),
                      ),
                    if (!isAvailable)
                      const Text(
                        "Not Available",
                        style: TextStyle(color: Colors.red),
                      ),
                    Text(
                      "RM ${widget.item.price}",
                    ),
                  ],
                ),
                const Spacer(),
                Switch(
                  value: isAvailable,
                  onChanged: toggleAvailable,
                  activeTrackColor: const Color.fromARGB(255, 0, 59, 115),
                  inactiveThumbColor: const Color.fromARGB(255, 0, 59, 115),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
