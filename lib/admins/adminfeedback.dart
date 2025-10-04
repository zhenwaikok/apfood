import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'managefeedback.dart';
import 'viewfeedback.dart';
import 'package:intl/intl.dart';

class AdminFeedback extends StatefulWidget {
  const AdminFeedback({super.key});

  @override
  State<AdminFeedback> createState() => _AdminFeedbackState();
}

class _AdminFeedbackState extends State<AdminFeedback> {
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
              buildPieChart(),
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
              Table(
                children: [
                  TableRow(children: [
                    buildButton(context, "View More", const ViewFeedback()),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPieChart() {
    final goodReviewCount = goodReviewCounts.length;
    final badReviewCount = badReviewCounts.length;

    return Column(
      children: [
        SfCircularChart(
          legend: const Legend(
            isVisible: true,
            position: LegendPosition.bottom,
          ),
          series: <CircularSeries>[
            PieSeries<FeedbackData, String>(
              dataSource: <FeedbackData>[
                FeedbackData('Good Review', goodReviewCount),
                FeedbackData('Bad Review', badReviewCount),
              ],
              xValueMapper: (FeedbackData feedback, _) => feedback.review,
              yValueMapper: (FeedbackData feedback, _) => feedback.reviewcounts,
              dataLabelMapper: (FeedbackData feedback, _) =>
                  'Review: ${feedback.reviewcounts}\n${((feedback.reviewcounts / totalReviewCounts()) * 100).toStringAsFixed(2)}%',
              pointColorMapper: (FeedbackData feedback, _) =>
                  feedback.review == 'Good Review' ? Colors.green : Colors.red,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelIntersectAction: LabelIntersectAction.shift,
                connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve),
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  int totalReviewCounts() {
    return goodReviewCounts.length + badReviewCounts.length;
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
                      adminComment: review['admin_comment'],
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
                    Text('Admin Comment: ${review['admin_comment']}'),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildButton(BuildContext context, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: 80, 
        height: 40, 
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
}

class FeedbackData {
  FeedbackData(this.review, this.reviewcounts);
  final String review;
  final int reviewcounts;
}
