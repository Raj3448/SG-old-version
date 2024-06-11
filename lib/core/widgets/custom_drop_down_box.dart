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
  String? memberName;
  List<Member> selectedMembers = [];
  void Function(Member) updateMember;
  final bool isRequired;

  CustomDropDownBox({
    required this.memberList,
    required this.updateMember,
    this.memberName,
    this.selectedMembers = const [],
    this.isRequired = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDropDownBox> createState() => CustomDropDownBoxState();
}

class CustomDropDownBoxState extends State<CustomDropDownBox> {
  bool isExpanding = false;
  bool showError = false;

  bool validate() {
    if (widget.isRequired && widget.memberName == null) {
      setState(() {
        showError = true;
      });
      return false;
    }
    setState(() {
      showError = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: showError
                    ? const Color(0xFF9E2F27)
                    : AppColors.grayscale300,
              ),
              borderRadius: BorderRadius.circular(Dimension.d2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.memberName ?? 'Select',
                  style: AppTextStyle.bodyLargeMedium.copyWith(
                    height: 2.4,
                    color: widget.memberName == null
                        ? AppColors.grayscale600
                        : AppColors.grayscale900,
                  ),
                ),
                Icon(
                  isExpanding ? AppIcons.arrow_up_ios : AppIcons.arrow_down_ios,
                  size: 7,
                  color: AppColors.grayscale700,
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: showError && widget.isRequired,
          child: const Padding(
            padding: EdgeInsets.only(top: Dimension.d2, left: Dimension.d4),
            child: Text(
              'Please select a member',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xFF9E2F27),
                fontSize: 12,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: isExpanding ? 210 : 0,
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
                      color: AppColors.black.withOpacity(0.25),
                    ),
                  ],
                )
              : null,
          child: isExpanding
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      widget.memberList.length,
                      (index) => GestureDetector(
                        onTap: widget.selectedMembers.any(
                          (selectedMember) =>
                              selectedMember.id == widget.memberList[index].id,
                        )
                            ? null
                            : () {
                                widget.updateMember(
                                  widget.memberList[index],
                                );
                                widget.memberName =
                                    widget.memberList[index].name;
                                setState(() {
                                  isExpanding = !isExpanding;
                                  showError = false;
                                });
                              },
                        child: _MemeberListTileComponent(
                          disable: widget.selectedMembers.any(
                            (selectedMember) =>
                                selectedMember.id ==
                                widget.memberList[index].id,
                          ),
                          name: widget.memberList[index].name,
                          imgPath:
                              widget.memberList[index].profileImg?.url ?? '',
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        ),
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
    Key? key,
  }) : super(key: key);

  final String name;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: Dimension.d2,
        right: Dimension.d2,
        top: Dimension.d2,
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimension.d2),
      decoration: BoxDecoration(
        color: disable ? AppColors.grayscale400 : AppColors.grayscale200,
        border: Border.all(width: 1, color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Row(
        children: [
          Avatar.fromSize(
            imgPath: imgPath.isNotEmpty ? '${Env.serverUrl}$imgPath' : '',
            size: AvatarSize.size14,
          ),
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
