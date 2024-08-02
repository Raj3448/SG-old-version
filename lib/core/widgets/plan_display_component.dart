// ignore_for_file: public_member_api_docs, sort_constructors_first, lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/feature/book_services/screens/service_booking_payment_detail_screen.dart';
import 'package:silver_genie/feature/genie/model/product_listing_model.dart';

class PlanDisplayComponent extends StatefulWidget {
  const PlanDisplayComponent({
    required this.planPriceDetails,
    required this.isSelected,
    super.key,
  });

  final Price? planPriceDetails;
  final bool isSelected;
  @override
  State<PlanDisplayComponent> createState() => _PlanDisplayComponentState();
}

class _PlanDisplayComponentState extends State<PlanDisplayComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isSelected ? AppColors.primary : AppColors.grayscale400,
        ),
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.planPriceDetails!.label,
                style: AppTextStyle.bodyXLSemiBold
                    .copyWith(color: AppColors.grayscale900),
              ),
              if (widget.planPriceDetails!.discountPercentage != null)
                Container(
                  padding: const EdgeInsets.all(Dimension.d1),
                  decoration: BoxDecoration(
                    color: AppColors.warning2,
                    borderRadius: BorderRadius.circular(Dimension.d2),
                  ),
                  child: Text(
                    '${widget.planPriceDetails!.discountPercentage}% off',
                    style: AppTextStyle.bodySmallBold
                        .copyWith(height: 1.6, color: AppColors.grayscale100),
                  ),
                ),
            ],
          ),
          const SizedBox(height: Dimension.d2),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Including all tax',
                      style: AppTextStyle.bodyMediumMedium
                          .copyWith(color: AppColors.grayscale700),
                    ),
                  ),
                  Text(
                    '${widget.planPriceDetails!.recurringIntervalCount} ${removeLastLy(widget.planPriceDetails!.recurringInterval!)}',
                    style: AppTextStyle.bodyXLBold
                        .copyWith(color: AppColors.grayscale900),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.planPriceDetails!.amountWithoutDiscount != null)
                    Text(
                      ' ${formatNumberWithCommas(widget.planPriceDetails?.amountWithoutDiscount ?? 0)} Rs',
                      style: AppTextStyle.bodyMediumMedium.copyWith(
                        color: AppColors.grayscale700,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    ' ${formatNumberWithCommas(widget.planPriceDetails?.unitAmount ?? 0)} Rs',
                    style: AppTextStyle.bodyXLBold
                        .copyWith(color: AppColors.grayscale900),
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

String removeLastLy(String input) {
  final lastIndex = input.lastIndexOf('ly');
  if (lastIndex == -1) return input;
  return input.substring(0, lastIndex) + input.substring(lastIndex + 2);
}
