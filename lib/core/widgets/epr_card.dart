import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class EPRCard extends StatelessWidget {
  const EPRCard({
    required this.dateUpdated,
    required this.ontap,
    super.key});

  final String dateUpdated;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimension.d3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Patient record (EPR)',
            style: AppTextStyle.bodyLargeMedium,
          ),
          const SizedBox(height: Dimension.d3,),
          Row(
            children: [
              const Text('Last updated : ',
              style:AppTextStyle.bodyMediumMedium),
              const SizedBox(width:Dimension.d2),
              Text(
                dateUpdated,
                style: AppTextStyle.bodyMediumMedium,),
              
            ],
          ),
          const SizedBox(height: Dimension.d3,),
          CustomButton(
                ontap: ontap,
                title: 'View EPR', 
                showIcon: true, 
                iconPath: AppIcons.add, 
                size: ButtonSize.small, 
                type: ButtonType.primary, 
                expanded: false),
        ],
      ),
    );
  }
}
