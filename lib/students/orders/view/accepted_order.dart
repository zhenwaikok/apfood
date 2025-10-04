import 'package:apfood/students/orders/viewmodel/orders_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptedOrdersTab extends StatelessWidget {
  const AcceptedOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersViewModel("accepted"),
      child: Consumer<OrdersViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.orderItems.isEmpty) {
            return const Center(
              child: Text(
                "Your have no accepted orders.",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.orderItems.length,
            itemBuilder: (context, index) {

              final orderItems = viewModel.orderItems[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Order Date Time
                      Text(
                        "Order DateTime: ${viewModel.formateDateTime(orderItems.orderTime)}",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 10,),

                      //Orders details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          //food image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 110,
                              height: 110,
                              child: Image.network(
                                  orderItems.image_url),
                            ),
                          ),
                      
                          const SizedBox(
                            width: 13,
                          ),
                      
                          //food details
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //food name
                                Text(
                                  orderItems.itemName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                      
                                //price
                                Text(
                                  "RM${viewModel.formatPrice(orderItems.price)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                      
                                const SizedBox(
                                  height: 30,
                                ),
                      
                                //quantity
                                Text(
                                  "Qty: ${orderItems.quantity}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                      
                                //status
                                const Text(
                                  "Status: accepted",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      
                          //total price
                          Text(
                            "Total: RM${viewModel.formatPrice(orderItems.price * orderItems.quantity)}",
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
