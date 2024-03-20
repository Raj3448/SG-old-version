import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DividerComponent extends StatelessWidget {
  const DividerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
              height: 1.0,
              color: Colors.grey,
    );
  }
}