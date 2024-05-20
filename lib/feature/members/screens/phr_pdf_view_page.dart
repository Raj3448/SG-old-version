// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/utils/http_client.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PhrPdfViewPage extends StatefulWidget {
  const PhrPdfViewPage({super.key});

  @override
  _PhrPdfViewPageState createState() => _PhrPdfViewPageState();
}

class _PhrPdfViewPageState extends State<PhrPdfViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppbar(title: 'EPR/PHR Web view'),
      body: FutureBuilder(
        future: GetIt.I<HttpClient>().put('/api/users/1?populate=*'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              showShadow: false,
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const ErrorStateComponent(errorType: ErrorType.pageNotFound);
          }
          return SfPdfViewer.network(
            'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
            onDocumentLoadFailed: (error) {},
          );
        },
      ),
    );
  }
}
