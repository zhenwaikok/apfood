import 'package:apfood/vendors/Widget/order.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderTab extends StatelessWidget {
  OrderTab({required this.status, super.key});

  final String status;

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("order")
          .where("vendorId", isEqualTo: currentUserId)
          .where("status", isEqualTo: status)
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
            return OrderWidget(
              order: order,
              status: status,
            );
          },
        );
      },
    );
  }
}
