import 'package:apfood/admins/admin_navbar.dart';
import 'package:apfood/students/student_navbar.dart';
import 'package:apfood/vendors/View/vendor_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userRole = "";

  Future<void> getRole() async {
    // get current used uid
    final String userID = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;

    String role = "";

    await db.collection("users").doc(userID).get().then((DocumentSnapshot doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      role = data['role'];
    });

    setState(() {
      userRole = role;
    });
  }

  @override
  void initState() {
    super.initState();
    getRole();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeRolePage = const Center(
      child: CircularProgressIndicator(),
    );

    if (userRole == "Vendor") {
      activeRolePage = VendorNavbar();
    } else if (userRole == "Student") {
      activeRolePage = const StudentsNavBar();
    } else if (userRole == "Admin") {
      activeRolePage = const AdminNavBar();
    }

    return Scaffold(body: activeRolePage);
  }
}
