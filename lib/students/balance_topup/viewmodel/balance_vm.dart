import 'package:apfood/students/balance_topup/model/balance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BalanceViewModel extends ChangeNotifier{

  double _amount = 0;
  List<BalanceDetails> _balanceDetails = [];
  bool _isLoading = true;

  String selectedPaymentoption = "E-wallet";
  TextEditingController amountController = TextEditingController(text: "0");


  double get amount => _amount;
  List<BalanceDetails> get balanceDetails => _balanceDetails;
  bool get isLoading => _isLoading;

  BalanceViewModel(){
    fetchBalanceDetails();
  }


  void setselectedPaymentoptionState(value)
  {
    selectedPaymentoption = value;
    notifyListeners();
  }

  void updateEnteredAmount(String newAmount){

    amountController.text = newAmount;
    notifyListeners();
  }

  String formatDate(DateTime date)
  {
    return DateFormat("yyyy-MM-dd HH:mm").format(date);
  }

  String formatPrice(double price)
  {
    final NumberFormat formatter = NumberFormat("0.00");
    return formatter.format(price);
  }

  //add top up details to firstore
  Future<void> topUpAPCard(double amount, String paymentMethod) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      final balanceRef = FirebaseFirestore.instance.collection("APbalance").doc(currentUserId);

      final topUpDetails ={
        "dateTime":DateTime.now(),
        "amount":amount,
        "type": "Top Up",
        "paymentMethod":paymentMethod,
      };

      try
      {
        //use run transaction to perform multiple read and write in single operation
        await FirebaseFirestore.instance.runTransaction((transaction) async{
          final balanceDoc = await transaction.get(balanceRef);

          //initialize the document if user top up for first time
          if(!balanceDoc.exists)
          {
            transaction.set(
              balanceRef, 
              {
                "balance": amount,
                "transaction":[topUpDetails],
              }
            );
          }
          else
          {
            // get cuurent balance
            double currentBalance = balanceDoc.data() ? ["balance"]?.toDouble() ?? 0.0;

            double newBalance = currentBalance + amount;

            //update the document
            transaction.update(
              balanceRef, 
              {
                "balance":newBalance,
                "transaction": FieldValue.arrayUnion([topUpDetails]),
              }
            );
          }
        });
                
        await fetchBalanceDetails();
      }
      finally
      {
        notifyListeners();
      }
    }
  }

  //retrieve balance details
  Future<void> fetchBalanceDetails() async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      try{
        final docSnapshot = await FirebaseFirestore.instance.collection("APbalance").doc(currentUserId).get();

        if(docSnapshot.exists)
        {
          final data = docSnapshot.data();

          if(data != null && data.containsKey("transaction"))
          {
            _amount = data["balance"]?.toDouble() ?? 0.0;
            final List balance = data["transaction"];
            _balanceDetails = balance.map((item) => BalanceDetails.fromMap(item as Map<String,dynamic>)).toList();
          }

        }
      }
      finally
      {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  //deduct ap balance 
  Future<void> deductAPBalance(BuildContext context, double total) async{
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if(currentUserId != null)
    {
      final balanceRef = FirebaseFirestore.instance.collection("APbalance").doc(currentUserId);

      final balanceDetails ={
        "dateTime":DateTime.now(),
        "amount":total,
        "type": "Paid",
      };

      try
      {
        await FirebaseFirestore.instance.runTransaction((transaction) async{
          final balanceDoc = await transaction.get(balanceRef);

          double currentBalance = balanceDoc.data()? ["balance"]?.toDouble() ?? 0.0;

          double newBalance = currentBalance - total;
          transaction.update(balanceRef, {
            "balance": newBalance,
            "transaction":FieldValue.arrayUnion([balanceDetails]),
          });

          fetchBalanceDetails();
        });
      }
      finally
      {
        notifyListeners();
      }

    }
  }
}