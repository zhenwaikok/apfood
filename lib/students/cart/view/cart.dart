import 'package:apfood/students/balance_topup/viewmodel/balance_vm.dart';
import 'package:apfood/students/cart/viewmodel/cart_vm.dart';
import 'package:apfood/students/food%20details/view/food_details.dart';
import 'package:apfood/students/orders/viewmodel/orders_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersViewModel('')),
        ChangeNotifierProvider(create: (_) => BalanceViewModel()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          title: const Text(
            "Cart",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<CartViewModel>(
          builder: (context, viewModel, child) {

            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.cartItems.isEmpty) {
              return const Center(
                child: Text(
                  "Your cart is empty.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }

            return Consumer<OrdersViewModel>(
              builder: (context, ordersViewModel, child) {
                return Consumer<BalanceViewModel>(
                  builder: (context, balanceViewModel, child) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: ListView.builder(
                                  itemCount: viewModel.cartItems.length,
                                  itemBuilder: (context, index) {
                                    final cartItems = viewModel.cartItems[index];
                                
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (context) => FoodDetailsScreen(itemId: cartItems.itemId)
                                            )
                                          ).then((_){
                                            viewModel.fetchCartItems();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            //food image
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.network(
                                                    cartItems.image_url),
                                              ),
                                            ),
                                                                
                                            const SizedBox(
                                              width: 10,
                                            ),
                                                                
                                            //food details
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      //food name
                                                      Expanded(
                                                        child: Text(
                                                          cartItems.itemName,
                                                          style: const TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                                
                                                      //dlt button
                                                      IconButton(
                                                          onPressed: () {
                                                            viewModel.removeCartItems(cartItems.itemId);
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(content: Text("Removed from cart")),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 20,
                                                          )),
                                                    ],
                                                  ),
                                                                
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                                
                                                  //price
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "RM${viewModel.formatPrice(cartItems.price)}",
                                                          style: const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                                
                                                      //add,minus, qty
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(30),
                                                          border: Border.all(
                                                              color: const Color(0XFF003B73)),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            viewModel.updateMinusQuantity(cartItems.itemId);
                                                          },
                                                          icon: const Icon(
                                                            Icons.remove,
                                                            color: Color(0XFF003B73),
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                                
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                                
                                                      Text(
                                                        cartItems.quantity.toString(),
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                                
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                                
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(30),
                                                          border: Border.all(
                                                              color: const Color(0XFF003B73)),
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            viewModel.updateAddQuantity(cartItems.itemId);
                                                          },
                                                          icon: const Icon(
                                                            Icons.add,
                                                            color: Color(0XFF003B73),
                                                            size: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                    
                              const SizedBox(
                                height: 30,
                              ),
                    
                              //additional notes
                              SizedBox(
                                height:40,
                                width: double.infinity,
                                child: TextFormField(
                                  controller: viewModel.notesController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width:1.5,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width:1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                    hintText: "Additional notes here...",
                                    
                                  ),
                                ),
                              ),
                    
                              const SizedBox(
                                height: 30,
                              ),
                    
                              //total amount
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: const Color(0XFFBED7ED),
                                  width: double.infinity,
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Total Amount:",
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "RM${viewModel.formatPrice(viewModel.total)}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    
                              const SizedBox(
                                height: 30,
                              ),
                    
                              //payment method
                              const Text(
                                "Payment method",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                    
                              //option 1
                              RadioListTile(
                                title: const Text(
                                  "AP Card",
                                  style: TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                                value: "AP Card",
                                groupValue: viewModel.selectedPaymentOption,
                                onChanged: (String? value) {
                                  if (value != null)
                                  {
                                    viewModel.setSelectedPaymentOptionState(value);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                    
                              //option 2
                              RadioListTile(
                                title: const Text(
                                  "E-wallet",
                                  style: TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                                value: "E-wallet",
                                groupValue: viewModel.selectedPaymentOption,
                                onChanged: (String? value) {
                                  if (value != null)
                                  {
                                    viewModel.setSelectedPaymentOptionState(value);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                    
                              //option 3
                              RadioListTile(
                                title: const Text(
                                  "Online-banking",
                                  style: TextStyle(
                                    fontSize: 23,
                                  ),
                                ),
                                value: "Online-banking",
                                groupValue: viewModel.selectedPaymentOption,
                                onChanged: (String? value) {
                                  if (value != null)
                                  {
                                    viewModel.setSelectedPaymentOptionState(value);
                                  }
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                    
                              const SizedBox(
                                height: 50,
                              ),
                    
                              //checkout btn
                              Center(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF003B73),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    onPressed: () {
                                      if(viewModel.selectedPaymentOption == "E-wallet" ||
                                        viewModel.selectedPaymentOption == "Online-banking"
                                      )
                                      {
                                        showPaymentDialog(context, viewModel,viewModel.notesController.text);
                                      }
                                      else if (viewModel.selectedPaymentOption == "AP Card")
                                      {
                                        double balance = balanceViewModel.amount.toDouble();
                                        double newBalance = balance - viewModel.total;

                                        if(balance > viewModel.total)
                                        {
                                          
                                          ordersViewModel.addOrders(viewModel.cartItems, viewModel.selectedPaymentOption, viewModel.notesController.text);
                                          balanceViewModel.deductAPBalance(context, viewModel.total);
                                          viewModel.clearCartItems();

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(
                                              "Successfully paid and we have received your order. Remaining balance: RM ${viewModel.formatPrice(newBalance)}"
                                              )
                                            )
                                          );
                                        }
                                        else
                                        {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insufficient balance: RM ${viewModel.formatPrice(balance)}, please top up.")));
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Checkout",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
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

//dialog to prompt user payment details
void showPaymentDialog(BuildContext context, CartViewModel cartViewModel, String notes)
{
  final _formKey = GlobalKey<FormState>();
  final ordersViewModel = Provider.of<OrdersViewModel>(context, listen:false);

  showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Payment Details"),
            IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: const Icon(Icons.close)),
          ],
        ),
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 200,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if(cartViewModel.selectedPaymentOption == "E-wallet")...{
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "E-wallet Id"),
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Please enter E-wallet Id";
                      }
                      return null;
                    },
                  ),
            
                  const SizedBox(height: 10,),
            
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "E-wallet PIN"),
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Please enter E-wallet PIN";
                      }
                      return null;
                    },
                  ),
                }
                else if (cartViewModel.selectedPaymentOption == "Online-banking")...{
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "Bank account number"),
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Please enter bank account number";
                      }
                      return null;
                    },
                  ),
            
                  const SizedBox(height: 10,),
            
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "CVV number"),
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Please enter CVV number";
                      }
                      return null;
                    },
                  ),
                }
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B73),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 10),
              ),
              onPressed: () async{
                if(_formKey.currentState!.validate())
                {
                  await ordersViewModel.addOrders(cartViewModel.cartItems, cartViewModel.selectedPaymentOption, notes);

                  cartViewModel.clearCartItems();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Paid successfully and we have received your order!"))
                  );

                  Navigator.pop(context);
                }
              }, 
              child: const Text(
                "Pay",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }
  );
}
