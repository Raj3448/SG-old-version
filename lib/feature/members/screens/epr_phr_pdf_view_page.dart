import 'package:flutter/material.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class EprPhrPdfViewPage extends StatelessWidget {
const EprPhrPdfViewPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const PageAppbar(title: 'EPR/PHR Web view'),
      body: SfPdfViewer.network('https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'),
    );
  }
}