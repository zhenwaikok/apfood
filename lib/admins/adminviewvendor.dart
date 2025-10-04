import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminViewVendors extends StatefulWidget {
  const AdminViewVendors({super.key});

  @override
  _AdminViewVendorsState createState() => _AdminViewVendorsState();
}

class _AdminViewVendorsState extends State<AdminViewVendors> {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> _generateReport() async {
    final pdf = pw.Document();
    final Vendors = await usersCollection.where('role', isEqualTo: 'Vendor').get();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Vendors Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            ...Vendors.docs.map((Vendor) {
              return pw.Container(
                margin: const pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(Vendor['username'], style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    pw.Text(Vendor['email'], style: pw.TextStyle(fontSize: 14)),
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
        title: const Text('View Vendors'),
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
        stream: usersCollection.where('role', isEqualTo: 'Vendor').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final Vendors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: Vendors.length,
            itemBuilder: (context, index) {
              final Vendor = Vendors[index];
              return ListTile(
                title: Text(Vendor['username']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editVendors(Vendor),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteVendors(Vendor),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVendors,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addVendors() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String email = '';
        return AlertDialog(
          title: const Text('Add New Vendors'),
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

  void _editVendors(DocumentSnapshot Vendor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = Vendor['username'];
        String email = Vendor['email'];
        return AlertDialog(
          title: const Text('Edit Vendors'),
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
                await usersCollection.doc(Vendor.id).update({
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

  void _deleteVendors(DocumentSnapshot Vendor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Vendors'),
          content: const Text('Are you sure you want to delete this Vendor?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await usersCollection.doc(Vendor.id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
