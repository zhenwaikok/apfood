import 'package:apfood/students/food%20details/view/food_details.dart';
import 'package:apfood/students/vendor_foods/viewmodel/vendorFood_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorFoodsScreen extends StatelessWidget{
  const VendorFoodsScreen({super.key, required this.vendorName, required this.vendorId});

  final String vendorId;
  final String vendorName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorFoodViewModel(vendorId),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          title: Text(
            vendorName,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
              )
            ),
        ),
        body: Consumer<VendorFoodViewModel>(
          builder: (context, viewModel, child) {

            if (viewModel.isLoading){
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.vendorFoodItems.isEmpty)
            {
                return const Center(child: Text(
                  "No item from this vendor",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
            }

            return ListView.builder(
              itemCount: viewModel.vendorFoodItems.length,
              itemBuilder: (context, index) {
                        
                final vendorFoodItems = viewModel.vendorFoodItems[index];
                        
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailsScreen(itemId: vendorFoodItems.itemId)));
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
                                vendorFoodItems.image_url,
                                fit: BoxFit.cover,
                              ),
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
                                vendorFoodItems.itemName,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                "RM${vendorFoodItems.price}",
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
                );
              },
              
            );   
          },
        ),
      ),
    );
  }
}