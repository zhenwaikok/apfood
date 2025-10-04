import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminViewOrder extends StatefulWidget {
  const AdminViewOrder({super.key});

  @override
  _AdminViewOrderState createState() => _AdminViewOrderState();
}

class _AdminViewOrderState extends State<AdminViewOrder> {
  String _selectedFilter = 'All';
  String _searchQuery = '';

  List<Map<String, dynamic>> _orders = [];

  Future<void> _fetchOrders() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('order').get();
    final List<Map<String, dynamic>> fetchedOrders = [];

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      var orderItems = data['orderItems'] as List<dynamic>;
      String vendorId = data['vendorId'];

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(vendorId).get();
      String vendorName = userDoc['username'];

      for (var item in orderItems) {
        DateTime orderTime = (data['orderTime'] as Timestamp).toDate();

        fetchedOrders.add({
          'orderId': doc.id,
          'itemName': item['itemName'],
          'price': double.parse(item['price'].toString()),
          'orderTime': orderTime,
          'status': data['status'],
          'username': vendorName,
          'vendorName': vendorName,
        });
      }
    }

    setState(() {
      _orders = fetchedOrders;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    List<Map<String, dynamic>> filteredOrders = _orders;
    if (_selectedFilter != 'All') {
      filteredOrders = filteredOrders.where((order) {
        return order['status'] == _selectedFilter || order['pickupType'] == _selectedFilter;
      }).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders.where((order) {
        return order['orderId'].contains(_searchQuery) ||
            order['username'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            order['itemName'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    return filteredOrders;
  }

  Future<void> _generateReport() async {
    final pdf = pw.Document();
    final imageLogo = pw.MemoryImage(
      (await rootBundle.load('Images/APFood.png')).buffer.asUint8List(), 
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Image(imageLogo, width: 100, height: 100),
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Sales Report - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              ..._filteredOrders.map((order) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Order ID: ${order['orderId']}'),
                    pw.Text('Customer: ${order['username']}'),
                    pw.Text('Items: ${order['itemName']}'),
                    pw.Text('Total Price: RM${order['price'].toStringAsFixed(2)}'),
                    pw.Text('Order Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(order['orderTime'])}'),
                    pw.Text('Status: ${order['status']}'),
                    pw.Text('Vendor: ${order['vendorName']}'),
                    pw.SizedBox(height: 10),
                  ],
                );
              }).toList(),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Text('Date Created: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),
              ),
            ],
          ),
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
        title: const Text('View Orders'),
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
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: <String>['All', 'pending', 'completed', 'accepted','cancelled'].map((String filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _orders.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text.rich(
                              TextSpan(
                                text: 'Order ID: ',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: order['orderId'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer: ${order['username']}'),
                                Text('Items: ${order['itemName']}'),
                                Text('Total Price: RM${order['price'].toStringAsFixed(2)}'),
                                Text('Order Time: ${DateFormat('dd MMM yyyy, hh:mm a').format(order['orderTime'])}'),
                                Text('Status: ${order['status']}'),
                                Text('Vendor: ${order['vendorName']}'),
                              ],
                            ),
                            trailing: order['status'] == 'completed'
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
