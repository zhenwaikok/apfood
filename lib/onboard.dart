import 'package:flutter/material.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                //background image
                image: DecorationImage(
                  image: AssetImage("Images/onboard.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 150,
                  ),

                  //apfood logo
                  Image.asset(
                    "Images/APFood.png",
                    width: 280,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //APFood text
                  const Text(
                    "APFood",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),

                  const Text(
                    "APU Food Ordering App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 90,
                  ),

                  const Text(
                    "Enjoy the convenience of\ndining at Asia Pacific University.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                    height: 70,
                  ),

                  //get started button
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003B73),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, top: 10, bottom: 10),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
