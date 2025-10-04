import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageFeedback extends StatefulWidget {
  final String reviewType;
  final String authorName;
  final String publishDate;
  final String feedbackContent;
  final String adminComment;

  const ManageFeedback({
    super.key,
    required this.reviewType,
    required this.authorName,
    required this.publishDate,
    required this.feedbackContent,
    required this.adminComment,
  });

  @override
  _ManageFeedbackState createState() => _ManageFeedbackState();
}

class _ManageFeedbackState extends State<ManageFeedback> {
  final TextEditingController _commentController = TextEditingController();
  bool _canReply = true;

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.adminComment;
    _canReply = widget.adminComment.isEmpty;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _updateAdminComment() async {
    if (_commentController.text.isNotEmpty) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('feedback')
            .where('comments', isEqualTo: widget.feedbackContent)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;

          await FirebaseFirestore.instance
              .collection('feedback')
              .doc(doc.id)
              .update({'admin_comment': _commentController.text});

          setState(() {
            _canReply = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin comment added successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback not found')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add admin comment: $e')),
        );
        print('Failed to update admin comment: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          foregroundColor: Colors.white,
          title: const Text(
            "APFood Feedback",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Review Type: ${widget.reviewType}",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              "Author: ${widget.authorName}",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              "Published on: ${widget.publishDate}",
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            const Text(
              "Feedback Content:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.feedbackContent,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            const Text(
              "Admin Comments:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (_canReply)
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your comments here',
                ),
              ),
            if (!_canReply)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(_commentController.text),
              ),
            const SizedBox(height: 16),
            if (_canReply)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003B73),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 10),
                  ),
                  onPressed: _updateAdminComment,
                  child: const Text('Submit'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
