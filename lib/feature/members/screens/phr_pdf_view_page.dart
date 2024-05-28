// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/widgets/error_state_component.dart';
import 'package:silver_genie/core/widgets/loading_widget.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';
import 'package:silver_genie/feature/members/repo/member_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PhrPdfViewPage extends StatelessWidget {
  final String memberPhrId;
  const PhrPdfViewPage({required this.memberPhrId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppbar(title: 'EPR/PHR Web view'),
      body: FutureBuilder(
        future: GetIt.I<MemberServices>().getPHRPdfPath(memberPhrId: memberPhrId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              showShadow: false,
            );
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const ErrorStateComponent(errorType: ErrorType.pageNotFound);
          }
          if (snapshot.data != null) {
            if (snapshot.data!.isLeft()) {
              return const ErrorStateComponent(
                  errorType: ErrorType.somethinWentWrong);
            }
          }
          final pdfPath = snapshot.data!.getOrElse((l) => throw 'Error');
          return SfPdfViewer.network(
            pdfPath,
            onDocumentLoadFailed: (error) {
              
            },
          );
        },
      ),
    );
  }
}
