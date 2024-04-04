import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/buttons.dart';
import 'package:silver_genie/core/widgets/elder_care_sub.dart';

class AnalogComponent extends StatelessWidget {
  const AnalogComponent({required this.text1, required this.text2, super.key});

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text1,
          style: AppTextStyle.bodyMediumMedium.copyWith(color:AppColors.grayscale700),
        ),
        Text(':', style: AppTextStyle.bodyMediumMedium.copyWith(color:AppColors.grayscale700)),
        const SizedBox(
          width: Dimension.d1,
        ),
        Text(text2, style: AppTextStyle.bodyMediumMedium.copyWith(color:AppColors.grayscale700)),
      ],
    );
  }
}

class CustomComponent extends StatelessWidget {
  const CustomComponent({required this.text, required this.value, super.key});

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration:BoxDecoration(
          color: AppColors.secondary,
          border:Border.all(
            width:1,
            color:AppColors.line,
          ),
          borderRadius:BorderRadius.circular(Dimension.d1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Dimension.d3, horizontal: Dimension.d2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    text,
                    style: AppTextStyle.bodySmallSemiBold,
                  ),
                  const SizedBox(
                    width: Dimension.d1,
                  ),
                  const Icon(
                    AppIcons.ecg_heart,
                    color: AppColors.grayscale600,
                    size:Dimension.d3
                  )
                ],
              ),
              const SizedBox(
                height: Dimension.d1,
              ),
              Text(
                value,
                style: AppTextStyle.bodyMediumBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivePlanComponent extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const ActivePlanComponent({
  required this.name,
  required this.onTap, 
  super.key});

  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border:Border.all(
          color: AppColors.line,
          width: 1),
        
        borderRadius: BorderRadius.circular(Dimension.d2), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimension.d3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: AppTextStyle.bodyLargeBold,
                ),
                const ElderCareSubscription(
                    color: ElderCareColor.blue, title: 'Care Member',showIcon: false,),
              ],
            ),
            SizedBox(
              height: Dimension.d1,
            ),
            const Row(
              children: [
                AnalogComponent(text1: 'Relation', text2: 'Father'),
                SizedBox(
                  width: Dimension.d2,
                ),
                AnalogComponent(text1: 'Age', text2: '62'),
              ],
            ),
            const SizedBox(
              height: Dimension.d3,
            ),
            const Text(
              'Vital Info',
              style: AppTextStyle.bodyMediumSemiBold,
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
            const Row(
              children: [
                CustomComponent(text: 'Blood Pressure', value: '73/140mmHg'),
                SizedBox(width:Dimension.d2,),
                CustomComponent(
                  text: 'Blood Oxygen',
                  value: '98%',
                )
              ],
            ),
            const SizedBox(
              height: Dimension.d2,
            ),
             const Row(
              children: [
                CustomComponent(text: 'Heart Rate', value: '106bpm'),
                SizedBox(
                  width: Dimension.d2,
                ),
                CustomComponent(
                  text: 'Fast Glucose',
                  value: '103 mg/dl',
                ),
                
              ],
            ),
            const SizedBox(height: Dimension.d2),
                const AnalogComponent(text1: 'Last Updated', text2: 'Today at 10:15AM'),
                const SizedBox(height: Dimension.d3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height:28,
                        child: CustomButton(
                        ontap: onTap, 
                        title: 'View PHR', 
                        showIcon: false, 
                        iconPath: Icons.not_interested, 
                        size: ButtonSize.small, 
                        type: ButtonType.secondary, 
                        expanded: true),
                      ),
                    ),
                    const SizedBox(
                      width: Dimension.d4,
                    ),
                    Expanded(
                      child: SizedBox(
                        height:28,
                        child: CustomButton(
                        ontap: onTap, 
                        title: 'View EPR', 
                        showIcon: false, 
                        iconPath: Icons.not_interested, 
                        size: ButtonSize.small, 
                        type: ButtonType.secondary, 
                        expanded: true),
                      ),
                    ),
      
                  ],
                )
          ],
        ),
      ),
    );
  }
}
