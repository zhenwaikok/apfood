import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackViewModel extends ChangeNotifier{
  var dropDownSelectedValue = 'Good Review';

  var dropDownItems = [
    'Bad Review',
    'Good Review',
  ];

  final TextEditingController feedback = TextEditingController();
  Map<String, dynamic> studentsInfo = {};


  FeedbackViewModel(){
    fetchStudentsInfo();
  }

  void setSelectedValue(String value){
    dropDownSelectedValue = value;
    notifyListeners();
  }

  Future<void> fetchStudentsInfo() async{
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final db = FirebaseFirestore.instance;

    await db.collection("users").doc(currentUserId).get().then(
      (DocumentSnapshot doc){
        final Map<String, dynamic> studentData = doc.data() as Map<String, dynamic>;
        studentsInfo = {
          "studentId":currentUserId,
          "studentName":studentData["username"],
        };
      }
    );
  }


  Future<void> saveFeedback(BuildContext context) async{
    if (feedback.text.isNotEmpty)
    {
      try
      {
        await FirebaseFirestore.instance.collection("feedback").add({
          "comments":feedback.text,
          "feedback type":dropDownSelectedValue,
          "students":studentsInfo,
          "created date": DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback submitted successfully!")),
        );

        Navigator.pop(context);

      }
      catch(e)
      {
        print("Error: $e");
      }
      finally
      {
        notifyListeners();
      }
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your comments.")),
      );
    }
  }
}