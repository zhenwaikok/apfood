import 'package:flutter/material.dart';
import 'viewfeedback.dart';
import 'adminviewstudents.dart';
import 'adminviewvendor.dart';
import 'adminview.dart';
import 'adminvieworder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int currentIndex = 0;
  List<Map<String, dynamic>> feedbacks = [];

  @override
  void initState() {
    super.initState();
    getFeedbackStream().listen((QuerySnapshot snapshot) {
      final List<Map<String, dynamic>> feedbackList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['createdDateFormatted'] = _formatTimestamp(data['created date']);
        return data;
      }).toList();

      setState(() {
        feedbacks = feedbackList;
      });
    });
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  int goodReviewCount() {
    return feedbacks
        .where((feedback) => feedback['feedback type'] == 'Good Review')
        .length;
  }

  int badReviewCount() {
    return feedbacks
        .where((feedback) => feedback['feedback type'] == 'Bad Review')
        .length;
  }

  Stream<QuerySnapshot> getFeedbackStream() {
    return FirebaseFirestore.instance.collection('feedback').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF003B73),
        foregroundColor: Colors.white,
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Information Management',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Table(
                children: [
                  TableRow(children: [
                    buildButton(context, "Customers", const AdminViewStudents()),
                    buildButton(context, "Vendors", const AdminViewVendors()),
                  ]),
                  TableRow(children: [
                    buildButton(context, "Administrators", const AdminView()),
                    buildButton(context, "Orders", const AdminViewOrder()),
                  ]),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feedback System',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Click on the feedback to view more',
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Image.asset(
                            'Images/Yes.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            goodReviewCount().toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            'Images/No.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            badReviewCount().toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              Table(
                children: feedbacks.take(2).map((feedback) {
                  return TableRow(
                    children: [
                      buildFeedbackButton(
                        context,
                        feedback['comments'],
                        feedback['createdDateFormatted'],
                        feedback['feedback type'],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        height: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0XFF003B73),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            shadowColor: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => page,
              ),
            );
          },
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFeedbackButton(
      BuildContext context, String comment, String date, String type) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 200,
        height: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            shadowColor: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ViewFeedback(),
              ),
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  comment.length > 20
                      ? '${comment.substring(0, 20)}...'
                      : comment,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
