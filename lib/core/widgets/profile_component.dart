import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class CustomTextIcon extends StatelessWidget {
  const CustomTextIcon({
    required this.iconpath,
    required this.title,
    super.key,
  });

  final IconData iconpath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          iconpath,
        ),
        const SizedBox(
          width: Dimension.d3,
        ),
        Expanded(
          child: Text(
            title,
            style: AppTextStyle.bodyLargeMedium,
          ),
        ),
      ],
    );
  }
}

class ProfileComponent extends StatelessWidget {
  const ProfileComponent({
    required this.imgPath,
    required this.name,
    required this.age,
    required this.phone,
    required this.address,
    super.key,
  });

  final String name;
  final String age;
  final String phone;
  final String address;
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimension.d3),
      child: Column(
        children: [
          Row(
            children: [
              Avatar(imgPath: imgPath, maxRadius: 56),
              const SizedBox(
                width: Dimension.d2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.bodyXLSemiBold,
                  ),
                  const SizedBox(
                    height: Dimension.d2,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Age :',
                        style: AppTextStyle.bodyMediumMedium,
                      ),
                      const SizedBox(
                        width: Dimension.d2,
                      ),
                      Text(
                        age,
                        style: AppTextStyle.bodyMediumMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          CustomTextIcon(
            iconpath: AppIcons.phone,
            title: phone,
          ),
          const SizedBox(
            height: Dimension.d2,
          ),
          CustomTextIcon(
            iconpath: AppIcons.home,
            title: address,
          ),
        ],
      ),
    );
  }
}
