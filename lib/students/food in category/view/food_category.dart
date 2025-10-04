import 'package:apfood/students/food%20in%20category/viewmodel/category_vm.dart';
import 'package:apfood/students/food%20details/view/food_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodCategoryScreen extends StatelessWidget {
  const FoodCategoryScreen({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodCategoryViewModel(categoryName),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          title: Text(
            categoryName,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body: Consumer<FoodCategoryViewModel>(
          builder: (context, viewModel, child) {

            if(viewModel.isLoading){
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.foodItems.isEmpty) {
              return const Center(
                child: Text(
                  "No item for this category",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: viewModel.foodItems.length,
              itemBuilder: (context, index) {
                final foodItems = viewModel.foodItems[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodDetailsScreen(
                                      itemId: foodItems.itemId,
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //food image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                foodItems.imageURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          //food details
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //food name
                                Text(
                                  foodItems.itemName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),

                                //price
                                Text(
                                  "RM${viewModel.formatPrice(foodItems.price)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                //vendor name
                                Text(
                                  foodItems.vendorName,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //forward icon
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
            },
          );
        }),
      ),
    );
  }
}
