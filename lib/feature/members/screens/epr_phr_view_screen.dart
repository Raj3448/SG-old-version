import 'package:flutter/material.dart';
import 'package:silver_genie/core/widgets/page_appbar.dart';

class EPRPHRViewScreen extends StatelessWidget {
  const EPRPHRViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PageAppbar(title: 'EPR/PHR Web View'),
      body: Center(
        child: Text('Web view / PDF will be shown here'),
      ),
    );
  }
}
