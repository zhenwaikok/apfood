import 'package:apfood/bottom_navigation.dart';
import 'package:apfood/students/balance_topup/view/balance.dart';
import 'package:apfood/students/cart/view/cart.dart';
import 'package:apfood/students/favourite/view/favourite.dart';
import 'package:apfood/students/student_home.dart';
import 'package:apfood/students/profile/view/profile.dart';
import 'package:flutter/material.dart';

class StudentsNavBar extends StatefulWidget{
  const StudentsNavBar({super.key});

  @override
  State<StudentsNavBar> createState() => _StudentsHomeScreenState();
}

class _StudentsHomeScreenState extends State<StudentsNavBar> {
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
    const BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: "Balance"),
    const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
  ];

  final List<Widget> pages = [
    const StudentHomeScreen(),
    const CartScreen(),
    const BalanceScreen(),
    const FavouriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomNav(items: items, pages: pages, backgroundColor:Colors.white,);
  }
}