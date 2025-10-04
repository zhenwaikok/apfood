import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget(
      {required this.orderItem, required this.isShown, super.key});

  final Map<String, dynamic> orderItem;
  final isShown;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  orderItem['itemName'],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    orderItem['quantity'].toString(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerRight,
                  child: Text(
                    "RM ${orderItem['price'].toString()}",
                  ),
                ),
              ),
            ],
          ),
          if (isShown)
            Text(
              "${orderItem["pickupType"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
