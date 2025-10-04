import 'package:apfood/vendors/View/order.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorOrderScreen extends StatelessWidget {
  VendorOrderScreen({super.key});

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 59, 115),
          title: const Text(
            "O R D E R",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: const Color.fromARGB(255, 0, 59, 115),
              indicatorColor: const Color.fromARGB(255, 0, 59, 115),
              unselectedLabelColor: const Color.fromARGB(200, 0, 59, 115),
              tabs: [
                // use streambuilder to update order count for each tab
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("order")
                      .where("vendorId", isEqualTo: currentUserId)
                      .where("status", isEqualTo: "pending")
                      .snapshots(),
                  builder: (ctx, orderSnapshots) {
                    if (!orderSnapshots.hasData ||
                        orderSnapshots.data!.docs.isEmpty) {
                      return const Tab(
                        text: "New Orders",
                      );
                    }
                    int orderCount = orderSnapshots.data!.docs.length;
                    return Tab(
                      child: Row(
                        children: [
                          const Text("New Orders"),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 0, 59, 115),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                "$orderCount",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("order")
                      .where("vendorId", isEqualTo: currentUserId)
                      .where("status", isEqualTo: "accepted")
                      .snapshots(),
                  builder: (ctx, orderSnapshots) {
                    if (!orderSnapshots.hasData ||
                        orderSnapshots.data!.docs.isEmpty) {
                      return const Tab(
                        text: "Ongoing",
                      );
                    }
                    int orderCount = orderSnapshots.data!.docs.length;
                    return Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Ongoing"),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 0, 59, 115),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                "$orderCount",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
                const Tab(
                  text: "Past Order",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OrderTab(
                    status: "pending",
                  ),
                  OrderTab(
                    status: "accepted",
                  ),
                  OrderTab(
                    status: "completed",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
