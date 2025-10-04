import 'package:apfood/students/balance_topup/view/top_up.dart';
import 'package:apfood/students/balance_topup/viewmodel/balance_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceScreen extends StatelessWidget{
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BalanceViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          title: const Text(
            "Balance",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer<BalanceViewModel>(
          builder: (context, viewModel, child) {

            if(viewModel.isLoading)
            {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      
                    //ap card balance details
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                      
                            const Text(
                              "AP Card Balance:",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                                  
                            const SizedBox(height: 15,),
                      
                            Text(
                              "RM ${viewModel.formatPrice(viewModel.amount)}",
                              style: const TextStyle(
                                fontSize: 23,
                              ),
                            ),
                      
                            const SizedBox(height:25,),
                      
                            SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0XFF003B73),
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(
                                      builder: (context) => const TopUpScreen()
                                    )
                                  ).then((_){
                                    viewModel.fetchBalanceDetails();
                                  });
                                }, 
                                child: const Text(
                                  "Top Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                  ),
                                ),
                            ),
                              
                          ],
                        ),
                      ),
                    ),
                      
                    const SizedBox(height: 60,),
              
                    //transaction
                    const Text(
                      "AP Card Transaction",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                      
                    const SizedBox(height: 20,),
                      
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                       itemCount: viewModel.balanceDetails.length,
                       itemBuilder: (context, index) {
                        final balanceDetails = viewModel.balanceDetails[index];

                        bool topUp = balanceDetails.type == "Top Up";
                                    
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:Colors.black,
                                  width: 1.0,
                                )
                              )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12,top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(balanceDetails.type,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                              
                                    Text(viewModel.formatDate(balanceDetails.dateTime),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                              
                                    ],
                                  ),
                              
                                  Text(
                                    topUp ?
                                    "+ RM ${viewModel.formatPrice(balanceDetails.amount)}":
                                    "- RM ${viewModel.formatPrice(balanceDetails.amount)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: topUp ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          
                        },
                        
                      ),
                    ),
                        
                  ],//
                ),
              ),
            );
          },
          
        ),
      
      ),
    );
  }
}