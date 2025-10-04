import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminViewStudents extends StatefulWidget {
  const AdminViewStudents({super.key});

  @override
  _AdminViewStudentsState createState() => _AdminViewStudentsState();
}

class _AdminViewStudentsState extends State<AdminViewStudents> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _generateReport() async {
    final pdf = pw.Document();
    final students = await usersCollection.where('role', isEqualTo: 'Student').get();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Students Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            ...students.docs.map((student) {
              return pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(student['username'], style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(student['email'], style: pw.TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF003B73),
        foregroundColor: Colors.white,
        title: const Text('View Students'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _generateReport,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.where('role', isEqualTo: 'Student').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final students = snapshot.data!.docs;
          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                title: Text(student['username']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editStudents(student),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteStudents(student),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStudents,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addStudents() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String email = '';
        return AlertDialog(
          title: const Text('Add New Students'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                await usersCollection.add({
                  'username': name,
                  'email': email,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editStudents(DocumentSnapshot student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = student['username'];
        String email = student['email'];
        return AlertDialog(
          title: const Text('Edit Students'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
                controller: TextEditingController(text: name),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                controller: TextEditingController(text: email),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                await usersCollection.doc(student.id).update({
                  'username': name,
                  'email': email,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteStudents(DocumentSnapshot student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Students'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await usersCollection.doc(student.id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
