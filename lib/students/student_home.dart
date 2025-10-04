import 'package:apfood/students/food%20in%20category/view/food_category.dart';
import 'package:apfood/students/food%20details/view/food_details.dart';
import 'package:apfood/students/vendor_foods/view/vendor_foods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("userId", isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData && streamSnapshot.data!.docs.isNotEmpty) {
              final userDoc = streamSnapshot.data!.docs.first;


              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 130,
                      color: const Color(0XFFBED7ED),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //welcome text
                                Text(
                                  "Hi ${userDoc["username"]}, ",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0XFF003B73),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                RichText(
                                  text: const TextSpan(
                                    text: "Let's enjoy\n",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Color(0XFF003B73),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Delicious food.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //ap food logo
                          Image.asset(
                            "Images/APFood.png",
                            width: 120,
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("categories")
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {

                        if (streamSnapshot.hasData) 
                        {
                          
                            final Set<String> uniqueCategories = {};
                            final List<DocumentSnapshot> categoryDocs = streamSnapshot.data!.docs;

                            for(var doc in categoryDocs)
                            {
                              uniqueCategories.add(doc["categoryName"]);
                            }

                            final List<String> uniqueCategoriesList = uniqueCategories.toList();


                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //categories text
                                const Text(
                                  "Categories",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF003B73),
                                  ),
                                ),

                                //categories selection
                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: uniqueCategoriesList.length,
                                    itemBuilder: (context, index) {

                                      final categoryName = uniqueCategoriesList[index];
                                      
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 8),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF003B73),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FoodCategoryScreen(
                                                            categoryName: categoryName)));
                                          },
                                          child: Text(
                                            categoryName,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    //vendors selection
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where('role', isEqualTo: "Vendor")
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //vendors list
                                  const Text(
                                    "Vendors",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF003B73),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  SizedBox(
                                    height: 180,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot vendors =
                                            streamSnapshot.data!.docs[index];

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VendorFoodsScreen(
                                                          vendorId:
                                                              vendors['userId'],
                                                          vendorName: vendors[
                                                              'username'],
                                                        )));
                                          },
                                          child: Container(
                                            width: 180,
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 10,
                                                  offset: const Offset(2, 5),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: SizedBox(
                                                    width: 90,
                                                    height: 90,
                                                    child: Image.network(
                                                      vendors['image_url'] !=
                                                                  null &&
                                                              vendors['image_url']
                                                                  .isNotEmpty
                                                          ? vendors['image_url']
                                                          : 'https://i0.wp.com/khade.net/wp-content/uploads/2015/11/vendor.jpeg?w=476&ssl=1',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 30,
                                                ),

                                                Text(vendors['username']),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),

                    //recommended foods section
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("items")
                            .where('isRecommended', isEqualTo: true)
                            .where('isAvailable', isEqualTo: true)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //recommended food list
                                  const Text(
                                    "Recommended Foods",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF003B73),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 180,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          streamSnapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final DocumentSnapshot foodItems =
                                            streamSnapshot.data!.docs[index];

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FoodDetailsScreen(
                                                            itemId: foodItems[
                                                                'itemId'])));
                                          },
                                          child: Container(
                                            width: 180,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: const EdgeInsets.only(
                                                right: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  blurRadius: 10,
                                                  offset: const Offset(2, 5),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: SizedBox(
                                                      width: 90,
                                                      height: 90,
                                                      child: Image.network(
                                                        foodItems['image_url'],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          foodItems['itemName'],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "RM${foodItems['price']}",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
