import 'package:apfood/students/cart/viewmodel/cart_vm.dart';
import 'package:apfood/students/favourite/viewmodel/favouriteVM.dart';
import 'package:apfood/students/food%20details/viewmodel/fooddetails_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodDetailsScreen extends StatelessWidget {
  const FoodDetailsScreen({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodDetailsViewModel(itemId)),
        ChangeNotifierProvider(create: (_) => FavouriteViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<FoodDetailsViewModel>(
            builder: (context, foodDetailsViewModel, child) {
          if (foodDetailsViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (foodDetailsViewModel.foodItemDetails == null) {
            return const Center(
              child: Text(
                "No food item details",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }

          var foodItemDetails = foodDetailsViewModel.foodItemDetails!;

          return Consumer<FavouriteViewModel>(
              builder: (context, favouriteViewModel, child) {
              bool isFavourite = favouriteViewModel.isFavourite(foodItemDetails.itemId);

            return Consumer<CartViewModel>(
              builder:(conntext, cartViewModel, child){

                int quantity = cartViewModel.quantity;

                return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        //image
                        SizedBox(
                          height: 230,
                          width: double.infinity,
                          child: Image.network(
                            foodItemDetails.image_url,
                            fit: BoxFit.cover,
                          ),
                        ),

                        //back and favourite icon button
                        Positioned(
                          top: 20,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //back icon
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    )),

                                //favourite icon
                                IconButton(
                                    onPressed: () async {
                                      if (isFavourite) {
                                        await favouriteViewModel
                                            .removeFromFavourite(
                                                foodItemDetails.itemId);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Removed from favourite")),
                                        );
                                      } else {
                                        await favouriteViewModel.addToFavourite(
                                          foodItemDetails.itemId,
                                          foodItemDetails.itemName,
                                          foodItemDetails.image_url,
                                          foodItemDetails.price,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text("Added to favourite")),
                                        );
                                      }
                                    },
                                    icon: Icon(
                                      isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: isFavourite
                                          ? Colors.red
                                          : Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //food details
                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodItemDetails.itemName,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            "RM ${foodDetailsViewModel.formatPrice(foodItemDetails.price)}",
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          Text(
                            foodItemDetails.description,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.justify,
                          ),

                          const SizedBox(
                            height: 50,
                          ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              color: const Color(0XFFBED7ED),
                              width: double.infinity,
                              height: 150,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    RadioListTile(
                                        title: const Text(
                                          "Pickup (Takeaway)",
                                          style: TextStyle(
                                            fontSize: 23,
                                          ),
                                        ),
                                        value: "Pickup (Takeaway)",
                                        groupValue: foodDetailsViewModel.selectedOption,
                                        onChanged: (String? value) {
                                          if(value != null)
                                          {
                                            foodDetailsViewModel.setSelectedOption(value);
                                          }
                                        }),

                                    RadioListTile(
                                        title: const Text(
                                          "Pickup (Dine In)",
                                          style: TextStyle(
                                            fontSize: 23,
                                          ),
                                        ),
                                        value: "Pickup (Dine In)",
                                        groupValue: foodDetailsViewModel.selectedOption,
                                        onChanged: (String? value) {
                                          if(value != null)
                                          {
                                            foodDetailsViewModel.setSelectedOption(value);
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 40,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: const Color(0XFF003B73)),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        cartViewModel.minusQuantity();
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Color(0XFF003B73),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Text(
                                    "$quantity",
                                    style: const TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: const Color(0XFF003B73)),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        cartViewModel.addQuantity();
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Color(0XFF003B73),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFF003B73),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50),
                                  ),
                                  onPressed: () {
                                    cartViewModel.addToCartItems(
                                      foodItemDetails.itemId, 
                                      foodItemDetails.itemName, 
                                      foodItemDetails.price, 
                                      quantity,
                                      foodDetailsViewModel.selectedOption,
                                      foodItemDetails.image_url,
                                      foodItemDetails.vendorId,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Added to cart")),
                                    );

                                  },
                                  child: const Text(
                                    "Add to cart",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
              }
            );
          });
        }),
      ),
    );
  }
}
