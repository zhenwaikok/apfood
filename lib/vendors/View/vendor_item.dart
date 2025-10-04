import 'package:apfood/vendors/View/edit_item.dart';
import 'package:apfood/vendors/ViewModel/item_in_category.dart';
import 'package:apfood/vendors/Widget/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorItemScreen extends StatefulWidget {
  const VendorItemScreen(
      {required this.categoryId, required this.categoryName, super.key});

  final String categoryId;
  final String categoryName;

  @override
  State<VendorItemScreen> createState() {
    return _VendorItemScreenState();
  }
}

class _VendorItemScreenState extends State<VendorItemScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemInCategoryViewModel.fetchFoodItem(widget.categoryId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 59, 115),
          foregroundColor: Colors.white,
          title: Text(widget.categoryName),
          centerTitle: true,
        ),
        body: Consumer<ItemInCategoryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (viewModel.items.isEmpty) {
              return const Center(
                child: Text("No Item in this category, Please add item"),
              );
            }

            return ListView.builder(
              itemCount: viewModel.items.length,
              itemBuilder: (context, index) {
                final item = viewModel.items[index];

                return ItemWidget(
                  item: item,
                  onEdit: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EditItemScreen(item: item),
                      ),
                    );
                    // Refresh the items after returning from edit screen
                    await viewModel.refreshItems();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
