import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class GenerateReport extends StatelessWidget {
  final List<Map<String, String>> reportData;
  final String reportTitle;

  const GenerateReport({super.key, required this.reportData, required this.reportTitle});

  Future<pw.Document> _generatePdf() async {
    final pdf = pw.Document();
    final logo = pw.MemoryImage(
      (await rootBundle.load('Images/APFood.png')).buffer.asUint8List(),
    );
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Image(logo, width: 200, height: 200),
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                reportTitle,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  decoration: pw.TextDecoration.underline,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            ...reportData.map((report) {
              return pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  report['data']!,
                  style: const pw.TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            pw.SizedBox(height: 100),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Date Created: $currentDate',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0XFF003B73),
          foregroundColor: Colors.white,
          title: const Text(
            "Generate Report",
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
      body: FutureBuilder<pw.Document>(
        future: _generatePdf(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error generating PDF'));
          }

          final pdf = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PdfPreview(
                  build: (format) => pdf.save(),
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  pdfFileName: 'report_preview.pdf',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
