import 'package:apfood/bottom_navigation.dart';
import 'package:apfood/vendors/View/vendor_menu.dart';
import 'package:apfood/vendors/View/vendor_order.dart';
import 'package:apfood/vendors/View/vendor_profile.dart';
import 'package:flutter/material.dart';

class VendorNavbar extends StatelessWidget {
  VendorNavbar({super.key});

  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.stay_primary_landscape_sharp), label: "Order"),
    const BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Menu"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
  ];

  final List<Widget> pages = [
    VendorOrderScreen(),
    const VendorMenuScreen(),
    const VendorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomNav(
      items: items,
      pages: pages,
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
    );
  }
}
