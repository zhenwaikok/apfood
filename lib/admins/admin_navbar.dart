import 'package:apfood/admins/admin_homepage.dart';
import 'package:apfood/admins/adminfeedback.dart';
import 'package:apfood/admins/adminreport.dart';
import 'package:apfood/admins/adminsettings.dart';
import 'package:apfood/bottom_navigation.dart';
import 'package:flutter/material.dart';

class AdminNavBar extends StatefulWidget{
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminNavBar> {
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.feedback), label: "Feedback"),
    const BottomNavigationBarItem(icon: Icon(Icons.report), label: "Report"),
    const BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
  ];

  final List<Widget> pages = [
    const AdminHomePage(),
    const AdminFeedback(),
    const AdminReport(),
    const AdminSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomNav(items: items, pages: pages, backgroundColor:Colors.white,);
  }
}