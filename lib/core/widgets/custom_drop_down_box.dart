// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/dimensions.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/env.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/feature/members/model/member_model.dart';
import 'package:silver_genie/feature/members/store/members_store.dart';

class CustomDropDownBox extends StatefulWidget {
  final List<Member> memberList;
  final String? memberName;
  List<Member> selectedMembers = [];
  void Function(Member?) updateMember;
  CustomDropDownBox({
    required this.memberList,
    required this.updateMember,
    this.memberName,
    required this.selectedMembers,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropDownBox> createState() => CustomDropDownBoxState();
}

class CustomDropDownBoxState extends State<CustomDropDownBox> {
  bool isExpanding = false;

  void disableDropDownList() {
    setState(() {
      isExpanding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanding = !isExpanding;
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
                Text(widget.memberName ?? 'Select',
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
          height: isExpanding
              ? ((widget.memberList.length > 4)
                  ? 210
                  : widget.memberList.length * 54)
              : 0,
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
              ? SingleChildScrollView(
                  child: Column(
                      children: List.generate(
                          widget.memberList.length,
                          (index) => GestureDetector(
                                onTap: widget.selectedMembers.any(
                                        (selectedMember) =>
                                            selectedMember.id ==
                                            widget.memberList[index].id)
                                    ? () {
                                        widget.updateMember(null);
                                        setState(() {
                                          isExpanding = !isExpanding;
                                        });
                                      }
                                    : () {
                                        widget.updateMember(
                                            widget.memberList[index]);
                                        setState(() {
                                          isExpanding = !isExpanding;
                                        });
                                      },
                                child: _MemeberListTileComponent(
                                    disable: widget.selectedMembers.any(
                                        (selectedMember) =>
                                            selectedMember.id ==
                                            widget.memberList[index].id),
                                    name: widget.memberList[index].name,
                                    imgPath: widget.memberList[index].profileImg
                                            ?.url ??
                                        ''),
                              ))),
                )
              : null,
        )
      ],
    );
  }
}

class _MemeberListTileComponent extends StatelessWidget {
  final String imgPath;

  const _MemeberListTileComponent({
    required this.name,
    required this.imgPath,
    required this.disable,
    super.key,
  });

  final String name;
  final bool disable;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      margin: const EdgeInsets.only(
          left: Dimension.d2, right: Dimension.d2, top: Dimension.d2),
      padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
      decoration: BoxDecoration(
          color: disable ? AppColors.grayscale400 : AppColors.grayscale200,
          border: Border.all(width: 1, color: AppColors.grayscale300),
          borderRadius: BorderRadius.circular(Dimension.d2)),
      child: Row(
        children: [
          Avatar.fromSize(
              imgPath: '${Env.serverUrl}$imgPath', size: AvatarSize.size14),
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
