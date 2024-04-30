import 'package:flutter/material.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class EprPhrPdfViewPage extends StatefulWidget {
  const EprPhrPdfViewPage({Key? key}) : super(key: key);

  @override
  _EprPhrPdfViewPageState createState() => _EprPhrPdfViewPageState();
}

class _EprPhrPdfViewPageState extends State<EprPhrPdfViewPage> {
  bool _documentLoadFailed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppbar(title: 'EPR/PHR Web view'),
      body: _documentLoadFailed
          ? const Center(
              child: Text(
                'Failed to load PDF. Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
            )
          : SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
              onDocumentLoadFailed: (error) {
                setState(() {
                  _documentLoadFailed = true;
                });
              },
            ),
    );
  }
}