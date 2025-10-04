import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceDetails{
  final double amount;
  final DateTime dateTime;
  final String type;

  BalanceDetails({
    required this.amount,
    required this.dateTime,
    required this.type,
  });

  factory BalanceDetails.fromMap(Map<String, dynamic> data)
  {
    return BalanceDetails(
      amount: data["amount"] ?? 0.0, 
      dateTime: (data["dateTime"] as Timestamp).toDate(), 
      type: data["type"] ?? '',
    ); 
  }
}