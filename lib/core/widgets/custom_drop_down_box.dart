// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/routes/routes_constants.dart';
import 'package:silver_genie/core/widgets/avatar.dart';

class CustomDropDownBox extends StatefulWidget {
  final List<String> memberList;
  const CustomDropDownBox({
    required this.memberList,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropDownBox> createState() => _CustomDropDownBoxState();
}

class _CustomDropDownBoxState extends State<CustomDropDownBox> {
  bool isExpanding = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanding = !isExpanding;
              print(isExpanding);
            });
          },
          child: Container(
            height: 52,
            padding:
                const EdgeInsets.only(left: Dimension.d3, right: Dimension.d6),
            margin: const EdgeInsets.symmetric(vertical: Dimension.d2),
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.grayscale300),
                borderRadius: BorderRadius.circular(Dimension.d2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select',
                    style: AppTextStyle.bodyLargeMedium.copyWith(height: 2.4)),
                Icon(
                  isExpanding ? AppIcons.arrow_up_ios : AppIcons.arrow_down_ios,
                  size: 9,
                  color: AppColors.grayscale700,
                )
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 1),
          padding: const EdgeInsets.only(bottom: Dimension.d2),
          decoration: isExpanding
              ? BoxDecoration(
                  color: AppColors.grayscale100,
                  borderRadius: BorderRadius.circular(Dimension.d2),
                  boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                          color: AppColors.black.withOpacity(0.25))
                    ])
              : null,
          child: isExpanding
              ? Column(
                  children: [
                    const _MemeberListTileComponent(
                      name: 'Shalini nair',
                    ),
                    const _MemeberListTileComponent(
                      name: 'Varun nair',
                    ),
                    _AddMemberButton()
                  ],
                )
              : null,
        )
      ],
    );
  }
}

class _MemeberListTileComponent extends StatelessWidget {
  const _MemeberListTileComponent({required this.name, super.key});

  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      margin: const EdgeInsets.only(
          left: Dimension.d2, right: Dimension.d2, top: Dimension.d2),
      padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
      decoration: BoxDecoration(
          color: AppColors.grayscale200,
          border: Border.all(width: 1, color: AppColors.grayscale300),
          borderRadius: BorderRadius.circular(Dimension.d2)),
      child: Row(
        children: [
          Avatar.fromSize(imgPath: '', size: AvatarSize.size14),
          const SizedBox(
            width: Dimension.d2,
          ),
          Text(
            name,
            style: AppTextStyle.bodyLargeMedium,
          ),
          const Spacer(),
          const Icon(
            AppIcons.elderly_person,
            size: 18,
            color: AppColors.primary,
          )
        ],
      ),
    );
  }
}

class _AddMemberButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RoutesConstants.addEditFamilyMemberRoute,
          pathParameters: {'edit': 'false'},
        );
      },
      child: Container(
        height: 42,
        width: double.infinity,
        margin: const EdgeInsets.only(
            left: Dimension.d2, right: Dimension.d2, top: Dimension.d2),
        padding: const EdgeInsets.symmetric(horizontal: Dimension.d3),
        decoration: BoxDecoration(
            color: AppColors.grayscale200,
            border: Border.all(width: 1, color: AppColors.grayscale300),
            borderRadius: BorderRadius.circular(Dimension.d2)),
        child: const Row(
          children: [
            Icon(
              AppIcons.add,
              color: AppColors.grayscale900,
              size: 20,
            ),
            SizedBox(
              width: Dimension.d3,
            ),
            Text(
              'Add new member',
              style: AppTextStyle.bodyLargeMedium,
            ),
          ],
        ),
      ),
    );
  }
}
