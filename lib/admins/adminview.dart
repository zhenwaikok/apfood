import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  _AdminviewState createState() => _AdminviewState();
}

class _AdminviewState extends State<AdminView> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _generateReport() async {
    final pdf = pw.Document();
    final admin = await usersCollection.where('role', isEqualTo: 'Admin').get();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Admin Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            ...admin.docs.map((Admin) {
              return pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(Admin['username'], style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(Admin['email'], style: const pw.TextStyle(fontSize: 14)),
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
        title: const Text('View Admins'),
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
        stream: usersCollection.where('role', isEqualTo: 'Admin').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final admin = snapshot.data!.docs;
          return ListView.builder(
            itemCount: admin.length,
            itemBuilder: (context, index) {
              final Admin = admin[index];
              return ListTile(
                title: Text(Admin['username']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editadmin(Admin),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteadmin(Admin),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addadmin,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addadmin() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String email = '';
        return AlertDialog(
          title: const Text('Add New admin'),
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

  void _editadmin(DocumentSnapshot Admin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = Admin['username'];
        String email = Admin['email'];
        return AlertDialog(
          title: const Text('Edit admin'),
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
                await usersCollection.doc(Admin.id).update({
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

  void _deleteadmin(DocumentSnapshot Admin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete admin'),
          content: const Text('Are you sure you want to delete this Admin?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await usersCollection.doc(Admin.id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
