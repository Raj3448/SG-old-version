import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';

class CustomizeTabviewComponent extends StatelessWidget {
  const CustomizeTabviewComponent(
      {required this.controller,
      required this.tabCount,
      required this.widgetList,
      Key? key})
      : super(key: key);
  final TabController controller;
  final int tabCount;
  final List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabCount,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: TabBar(
                controller: controller,
                dividerColor: AppColors.secondary,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.grayscale900,
                tabs: widgetList),
          ),
        ));
  }
}
