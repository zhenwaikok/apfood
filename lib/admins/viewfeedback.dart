import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'managefeedback.dart';
import 'package:intl/intl.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({super.key});

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  bool showGoodReviewCounts = true;
  bool showBadReviewCounts = false;

  List<Map<String, dynamic>> goodReviewCounts = [];
  List<Map<String, dynamic>> badReviewCounts = [];

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('feedback').get();
    final List<Map<String, dynamic>> goodReviews = [];
    final List<Map<String, dynamic>> badReviews = [];

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      data['createdDateFormatted'] = _formatTimestamp(data['created date']);

      if (data.containsKey('students')) {
        final students = data['students'] as Map<String, dynamic>;
        data['studentId'] = students['studentId'];
        data['studentName'] = students['studentName'];
      }

      if (data['feedback type'] == 'Good Review') {
        goodReviews.add(data);
      } else if (data['feedback type'] == 'Bad Review') {
        badReviews.add(data);
      }
    }

    setState(() {
      goodReviewCounts = goodReviews;
      badReviewCounts = badReviews;
    });
  }

  String _formatTimestamp(Timestamp timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF003B73),
        foregroundColor: Colors.white,
        title: const Text(
          "Feedback",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Click on the feedback to view more details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      buildClickableHeader('Good Review', () {
                        setState(() {
                          showGoodReviewCounts = !showGoodReviewCounts;
                          showBadReviewCounts = false;
                        });
                      }, showGoodReviewCounts, Colors.green),
                      buildClickableHeader('Bad Review', () {
                        setState(() {
                          showBadReviewCounts = !showBadReviewCounts;
                          showGoodReviewCounts = false;
                        });
                      }, showBadReviewCounts, Colors.red),
                    ],
                  ),
                ],
              ),
              if (!showGoodReviewCounts && !showBadReviewCounts)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                      left: BorderSide(color: Colors.grey[300]!),
                      right: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                ),
              if (showGoodReviewCounts)
                buildReviewTable(goodReviewCounts, Colors.green),
              if (showBadReviewCounts)
                buildReviewTable(badReviewCounts, Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClickableHeader(String title, VoidCallback onTap, bool isSelected, Color color) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: isSelected ? color : Colors.grey[200],
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildReviewTable(List<Map<String, dynamic>> reviews, Color color) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      children: reviews.map((review) {
        return TableRow(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ManageFeedback(
                      reviewType: review['feedback type'],
                      authorName: review['studentName'],
                      publishDate: review['createdDateFormatted'],
                      feedbackContent: review['comments'],
                      adminComment: review['admin_comment'] ?? '',
                    ),
                  ),
                );
              },
              child: Container(
                color: color.withOpacity(0.1),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Content: ${review['comments']}'),
                    Text('Student: ${review['studentName']}'),
                    Text('Published on: ${review['createdDateFormatted']}'),
                    Text('Admin Comment: ${review['admin_comment'] ?? 'No comment'}'),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
