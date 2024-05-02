import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/feature/emergency_services/model/emergency_service_model.dart';

class PlanDisplayComponent extends StatelessWidget {
  const PlanDisplayComponent({required this.plan, super.key});
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayscale400),
        color: AppColors.grayscale300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.title,
                style: AppTextStyle.bodyMediumMedium.copyWith(
                  color: AppColors.grayscale900,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 2.6,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dimension.d1),
                decoration: BoxDecoration(
                    color: AppColors.warning2,
                    borderRadius: BorderRadius.circular(Dimension.d2)),
                child: Text(
                  '10% off',
                  style: AppTextStyle.bodySmallBold
                      .copyWith(height: 1.6, color: AppColors.grayscale100),
                ),
              )
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      plan.descrip,
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale700,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.46,
                      ),
                    ),
                  ),
                  Text(
                    plan.duration,
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale900,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.46,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${plan.amount.toStringAsFixed(2)} Rs',
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale700,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.46,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    '${plan.discountamount.toStringAsFixed(2)}Rs',
                    style: AppTextStyle.bodyMediumMedium.copyWith(
                      color: AppColors.grayscale900,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.46,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
