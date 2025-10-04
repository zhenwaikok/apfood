import 'package:apfood/vendors/Widget/order_history.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Order History"),
        backgroundColor: const Color.fromARGB(255, 0, 59, 115),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("order")
            .where("vendorId", isEqualTo: currentUserId)
            .where("status", whereIn: ["completed", "cancelled"])
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (ctx, orderSnapshots) {
          if (orderSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!orderSnapshots.hasData || orderSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Order"),
            );
          }

          final loadedOrders = orderSnapshots.data!.docs;

          return ListView.builder(
            itemCount: loadedOrders.length,
            itemBuilder: (ctx, index) {
              final order = loadedOrders[index].data();
              return OrderHistoryWidget(
                order: order,
              );
            },
          );
        },
      ),
    );
  }
}
