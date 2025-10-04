import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final List<BottomNavigationBarItem> items;
  final List<Widget> pages;
  final Color backgroundColor;

  const CustomBottomNav(
      {super.key,
      required this.items,
      required this.pages,
      required this.backgroundColor});

  @override
  State<CustomBottomNav> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<CustomBottomNav> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(3, 13),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF003B73),
            unselectedItemColor: Colors.black,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: widget.items,
          ),
        ),
      ),
      body: widget.pages[currentIndex],
    );
  }
}
