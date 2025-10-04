import 'package:apfood/students/orders/view/completed_orders.dart';
import 'package:apfood/students/orders/view/declined_order.dart';
import 'package:apfood/students/orders/view/accepted_order.dart';
import 'package:apfood/students/orders/view/pending_orders.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget{
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          title: const Text(
            "Orders",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Declined",),
                Tab(text: "Pending",),
                Tab(text: "Accepted",),
                Tab(text: "Completed",),
              ],
              indicatorColor: Color(0XFF003B73),
              labelColor: Color(0XFF003B73),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  DeclinedOrdersTab(),
                  PendingOrdersTab(),
                  AcceptedOrdersTab(),
                  CompletedOrdersTab(),
                ]
              )
            )
          ],
        ),
         
      ),
    );
  }
}