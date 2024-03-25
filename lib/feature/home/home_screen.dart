import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Appbar(),
      body: Center(
        child: Text(
          'Home Screen',
          style: AppTextStyle.heading3Bold,
          // ).tr(),
        ),
      ),
    );
  }
}
