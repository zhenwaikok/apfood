import 'package:apfood/students/balance_topup/viewmodel/balance_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BalanceViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          foregroundColor: Colors.white,
          title: const Text(
            "Top Up",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
        body: Consumer<BalanceViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Top up your AP card",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    const Text(
                      "Insert amount below",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [

                        const Text(
                          "RM",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),

                        Expanded(
                          child: TextFormField(
                            controller: viewModel.amountController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 8),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              )),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              )),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value){
                              viewModel.updateEnteredAmount(value);
                            },
                            style: const TextStyle(
                              color: Colors.grey,  
                            ),
                            
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    const Text(
                      "Payment Method",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    const Text(
                      "Select payment method",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    RadioListTile(
                      title: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Touch_%27n_Go_eWallet_logo.svg/768px-Touch_%27n_Go_eWallet_logo.svg.png?20200518080317",
                        height: 100,
                        width: 100,
                      ),
                      value: "E-wallet",
                      groupValue: viewModel.selectedPaymentoption,
                      onChanged: (String? value) {
                        if (value != null) {
                          viewModel.setselectedPaymentoptionState(value);
                        }
                      }
                    ),

                    RadioListTile(
                      title: Image.network(
                        "https://vectorise.net/logo/wp-content/uploads/2019/09/Logo-FPX.png",
                        height: 100,
                        width: 100,
                      ),
                      value: "Online Banking",
                      groupValue: viewModel.selectedPaymentoption,
                      onChanged: (String? value) {
                        if (value != null) {
                          viewModel.setselectedPaymentoptionState(value);
                        }
                      }
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003B73),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          final amountText = viewModel.amountController.text;
                          final amount = double.tryParse(amountText) ?? 0.0;
                          if(amount > 0)
                          {
                            showPaymentDialog(context, viewModel, amount);
                          }
                          else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter a valid amount.")),
                            );
                          }
                        },
                        child: const Text(
                          "Top Up",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//dialog to prompt user payment details
void showPaymentDialog(BuildContext context, BalanceViewModel balanceViewModel, double amount)
{
  final _formKey = GlobalKey<FormState>();

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
                if(balanceViewModel.selectedPaymentoption == "E-wallet")...{
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
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if(value == null || value.isEmpty)
                      {
                        return "Please enter E-wallet PIN";
                      }
                      return null;
                    },
                  ),
                }
                else if (balanceViewModel.selectedPaymentoption == "Online Banking")...{
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: "Bank account number"),
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.number,
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
                  await balanceViewModel.topUpAPCard(amount,balanceViewModel.selectedPaymentoption);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Successfully top up ur AP Card!"))
                  );

                  Navigator.pop(context);
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