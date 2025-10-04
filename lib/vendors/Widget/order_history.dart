import 'package:apfood/vendors/Widget/order_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryWidget extends StatefulWidget {
  const OrderHistoryWidget({required this.order, super.key});

  final Map<String, dynamic> order;

  @override
  State<OrderHistoryWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderHistoryWidget> {
  var isShown = false;

  String formatTimestamp(Timestamp timestamp) {
    var format = DateFormat('y-M-d HH:mm a');
    return format.format(timestamp.toDate());
  }

  double calculateTotalPrice(List<Map<String, dynamic>> orderItems) {
    double totalPrice = 0.0;
    for (var item in orderItems) {
      totalPrice += (item['price'] as num) * (item['quantity'] as num);
    }
    return totalPrice;
  }

  void acceptOrder(String orderId) {
    FirebaseFirestore.instance.collection("order").doc(orderId).update(
      {'status': 'accepted'},
    );
  }

  void cancelOrder(String orderId) {
    FirebaseFirestore.instance.collection("order").doc(orderId).update(
      {'status': 'cancelled'},
    );
  }

  void comlpleteOrder(String orderId) {
    FirebaseFirestore.instance.collection("order").doc(orderId).update(
      {'status': 'completed'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderItems =
        (widget.order['orderItems'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(1),
          ),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: const Color.fromARGB(255, 190, 215, 237),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.order['username'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const Spacer(),
                        Text(
                          "Order ID: ${widget.order["orderId"]}",
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formatTimestamp(
                            widget.order['orderTime'],
                          ),
                        ),
                        const Spacer(),
                        Text("Total: RM ${calculateTotalPrice(orderItems)}")
                      ],
                    ),
                    if (isShown)
                      Text(
                        "Payment Option: ${widget.order["paymentOption"]}",
                      ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                return OrderItemWidget(
                    orderItem: orderItems[index], isShown: isShown);
              },
            ),
            const Divider(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Additional Notes: ${widget.order['additionalNotes']}",
                maxLines: isShown ? 10 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        isShown = !isShown;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 59, 115),
                      splashFactory: NoSplash.splashFactory,
                      padding: const EdgeInsets.all(3),
                    ),
                    icon: isShown
                        ? const Icon(Icons.keyboard_arrow_up)
                        : const Icon(Icons.keyboard_arrow_down),
                    label: isShown
                        ? const Text("Hide Details")
                        : const Text(
                            "Show Details",
                          ),
                    iconAlignment: IconAlignment.end,
                  ),
                  const Spacer(),
                  Text(
                    "Status: ${widget.order["status"]}",
                    style: TextStyle(
                      color: widget.order["status"] == "cancelled"
                          ? Colors.red
                          : Colors.green,
                    ),
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
