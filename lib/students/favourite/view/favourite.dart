import 'package:apfood/students/favourite/viewmodel/favouriteVM.dart';
import 'package:apfood/students/food%20details/view/food_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavouriteViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          title: const Text(
            "Favourite",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<FavouriteViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.favouriteItem.isEmpty) {
              return const Center(
                child: Text(
                  "Your favourite item is empty.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: viewModel.favouriteItem.length,
              itemBuilder: (context, index) {

                final favouriteItems = viewModel.favouriteItem[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                  child: Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => FoodDetailsScreen(itemId: favouriteItems.itemId)
                              )
                            ).then((_){
                              viewModel.fetchUserFavourite();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //food image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                      favouriteItems.image_url),
                                ),
                              ),

                              const SizedBox(
                                width: 20,
                              ),

                              //food name and price
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      favouriteItems.itemName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "RM${viewModel.formatPrice(favouriteItems.price)}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //delete icon
                              IconButton(
                                  onPressed: () {
                                    viewModel.removeFromFavourite(favouriteItems.itemId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Removed from favourite list")),
                                    );
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
