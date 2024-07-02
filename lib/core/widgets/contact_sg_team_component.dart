import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/launch_dialer.dart';
import 'package:silver_genie/core/widgets/buttons.dart';

class ContactSgTeamComponent extends StatelessWidget {
  final String phoneNumber;

  const ContactSgTeamComponent({required this.phoneNumber,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(
        bottom: Dimension.d4,
        top: Dimension.d2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Contact SilverGenie team',
            style: AppTextStyle.bodyMediumMedium.copyWith(
              height: 2,
              color: AppColors.grayscale900,
            ),
          ),
          SizedBox(
            width: 120,
            height: 40,
            child: CustomButton(
              ontap: () {
                launchDialer(phoneNumber);
              },
              title: 'Call now',
              showIcon: false,
              iconPath: AppIcons.add,
              size: ButtonSize.values[0],
              type: ButtonType.primary,
              expanded: true,
              iconColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
