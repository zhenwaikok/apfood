import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'generatereport.dart';

class AdminReport extends StatefulWidget {
  const AdminReport({super.key});

  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  String selectedReportType = 'Sales';
  String selectedPeriod = 'Daily';
  String selectedYear = '2024';
  String selectedMonth = 'January';
  DateTime selectedWeekStartDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String sortOption = 'None';

  final List<String> reportTypes = ['Sales', 'General'];
  final List<String> periods = ['Yearly', 'Monthly', 'Weekly', 'Daily'];
  final List<String> years = ['2024', '2023', '2022'];
  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December'];

  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filterAndSortData();
  }

  void filterAndSortData() async {
    setState(() {
      filteredData.clear();
    });

    DateTime startDate;
    DateTime endDate;

    if (selectedPeriod == 'Yearly') {
      startDate = DateTime(int.parse(selectedYear));
      endDate = DateTime(int.parse(selectedYear) + 1);
    } else if (selectedPeriod == 'Monthly') {
      int monthIndex = months.indexOf(selectedMonth) + 1;
      startDate = DateTime(int.parse(selectedYear), monthIndex);
      endDate = DateTime(int.parse(selectedYear), monthIndex + 1);
    } else if (selectedPeriod == 'Weekly') {
      startDate = selectedWeekStartDate;
      endDate = selectedWeekStartDate.add(const Duration(days: 7));
    } else {
      startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      endDate = startDate.add(const Duration(days: 1));
    }

    if (selectedReportType == 'Sales') {
      QuerySnapshot orderSnapshot = await FirebaseFirestore.instance.collection('order').get();
      List<Map<String, dynamic>> orders = orderSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      double totalSales = 0;

      for (var order in orders) {
        DateTime orderTime = (order['orderTime'] as Timestamp).toDate();
        if (orderTime.isAfter(startDate) && orderTime.isBefore(endDate)) {
          totalSales += calculateTotalSales(order);
        }
      }

      setState(() {
        filteredData = [
          {
            'data': 'Total Sales: RM${totalSales.toStringAsFixed(2)}'
          }
        ];
      });
    } else if (selectedReportType == 'General') {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<Map<String, dynamic>> users = userSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      int totalStudents = users.where((user) => user['role'] == 'Student').length;
      int totalVendors = users.where((user) => user['role'] == 'Vendor').length;
      int totalAdmins = users.where((user) => user['role'] == 'Admin').length;

      setState(() {
        filteredData = [
          {
            'data': 'Total Students: $totalStudents\nTotal Vendors: $totalVendors\nTotal Admins: $totalAdmins'
          }
        ];
      });
    }
  }

  double calculateTotalSales(Map<String, dynamic> order) {
    double totalSales = 0;
    for (var item in order['orderItems']) {
      totalSales += item['price'] * item['quantity'];
    }
    return totalSales;
  }

  void showNoDataAlert(BuildContext context, [String message = 'No data available to generate the report.']) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Selection'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            underline: Container(),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            items: items.map((String item) {
              bool isDisabled = false;
              if (label == 'Month' && selectedYear == DateTime.now().year.toString()) {
                int monthIndex = months.indexOf(item) + 1;
                if (monthIndex > DateTime.now().month) {
                  isDisabled = true;
                }
              }
              return DropdownMenuItem<String>(
                value: item,
                enabled: !isDisabled,
                child: Text(
                  item,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : Colors.black,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0XFF003B73),
        foregroundColor: Colors.white,
        title: const Text(
          "Report",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDropdown('Report Type', selectedReportType, reportTypes, (String? newValue) {
              setState(() {
                selectedReportType = newValue!;
                filterAndSortData();
              });
            }),
            const SizedBox(height: 10),
            if (selectedReportType == 'Sales') ...[
              buildDropdown('Period', selectedPeriod, periods, (String? newValue) {
                setState(() {
                  selectedPeriod = newValue!;
                  filterAndSortData();
                });
              }),
              const SizedBox(height: 10),
              if (selectedPeriod == 'Yearly')
                buildDropdown('Year', selectedYear, years, (String? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                    filterAndSortData();
                  });
                }),
              if (selectedPeriod == 'Monthly')
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown('Month', selectedMonth, months, (String? newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                          int monthIndex = months.indexOf(selectedMonth) + 1;
                          if (monthIndex > DateTime.now().month && selectedYear == DateTime.now().year.toString()) {
                            selectedMonth = months[DateTime.now().month - 1];
                            showNoDataAlert(context, "You cannot select a future month.");
                          } else {
                            filterAndSortData();
                          }
                        });
                      }),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: buildDropdown('Year', selectedYear, years, (String? newValue) {
                        setState(() {
                          selectedYear = newValue!;
                          filterAndSortData();
                        });
                      }),
                    ),
                  ],
                ),
              if (selectedPeriod == 'Weekly')
                buildWeekPicker(context, selectedWeekStartDate, (DateTime? newDate) {
                  setState(() {
                    if (newDate != null) {
                      selectedWeekStartDate = newDate;
                      filterAndSortData();
                    }
                  });
                }),
              if (selectedPeriod == 'Daily')
                buildDatePicker(context, selectedDate, (DateTime? newDate) {
                  setState(() {
                    if (newDate != null) {
                      selectedDate = newDate;
                      filterAndSortData();
                    }
                  });
                }),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                if (filteredData.isEmpty) {
                  showNoDataAlert(context);
                } else {
                  String reportTitle = '';
                  if (selectedPeriod == 'Yearly') {
                    reportTitle = 'Yearly $selectedYear Sales Report';
                  } else if (selectedPeriod == 'Monthly') {
                    reportTitle = '$selectedMonth $selectedYear Sales Report';
                  } else if (selectedPeriod == 'Weekly') {
                    reportTitle = 'Sales Report - Week of ${DateFormat('MMM d, yyyy').format(selectedWeekStartDate)}';
                  } else if (selectedPeriod == 'Daily') {
                    reportTitle = 'Sales Report - ${DateFormat('dd/MM/yyyy').format(selectedDate)}';
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateReport(
                        reportData: filteredData,
                        reportTitle: reportTitle,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF003B73),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Center(child: Text('Generate Report')),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredData.isEmpty
                  ? const Center(
                      child: Text(
                        'No Data Available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              filteredData[index]['data']!,
                            ),
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

 Widget buildDatePicker(BuildContext context, DateTime selectedDate, ValueChanged<DateTime?> onDateChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Select Date',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            onDateChanged(picked);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(selectedDate),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    ],
  );
}


  Widget buildWeekPicker(BuildContext context, DateTime selectedDate, ValueChanged<DateTime?> onDateChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Week Starting Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              onDateChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM d, yyyy').format(selectedDate)),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }
}