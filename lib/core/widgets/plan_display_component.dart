import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/feature/emergency_services/model/emergency_service_model.dart';

class PlanDisplayComponent extends StatelessWidget {
  final Plan plan;
  const PlanDisplayComponent({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC7CFD2), width: 1),
          color: const Color(0xffE3E9EC),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(plan.title,
              style: AppTextStyle.bodyMediumMedium.copyWith(
                color: AppColors.grayscale900,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.46,
              )),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.duration,
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale900,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.46,
                      )),
                  SizedBox(
                    width: 150,
                    child: Text(plan.descrip,
                        style: AppTextStyle.bodyMediumMedium.copyWith(
                          color: AppColors.grayscale700,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.46,
                        )),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${plan.discountamount.toStringAsFixed(2)}Rs',
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale900,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.46,
                      )),
                  Text('${plan.amount.toStringAsFixed(2)} Rs',
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale700,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.46,
                        decoration: TextDecoration.lineThrough,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}