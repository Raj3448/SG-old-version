// ignore_for_file: must_be_immutable

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
  CustomDropDownBox({
    required this.memberList,
    required this.updateMember,
    this.memberName,
    this.selectedMembers = const [],
    this.isRequired = false,
    this.placeHolder,
    super.key,
  });
  final List<Member> memberList;
  String? memberName;
  String? placeHolder;
  List<Member> selectedMembers = [];
  void Function(Member?) updateMember;
  final bool isRequired;

  @override
  State<CustomDropDownBox> createState() => CustomDropDownBoxState();
}

class CustomDropDownBoxState extends State<CustomDropDownBox> {
  bool isExpanding = false;
  bool showError = false;

  void disableDropDownList() {
    setState(() {
      isExpanding = false;
    });
  }

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
                color: showError ? AppColors.error : AppColors.grayscale300,
              ),
              borderRadius: BorderRadius.circular(Dimension.d2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.memberName ?? widget.placeHolder ?? 'Select',
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
                ),
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
                color: AppColors.error,
                fontSize: 12,
              ),
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
                            ? () {
                                widget.updateMember(null);
                                setState(() {
                                  isExpanding = !isExpanding;
                                });
                              }
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
                          iconUrl:
                              widget.memberList[index].subscriptions!.isNotEmpty
                                  ? widget.memberList[index].subscriptions![0]
                                      .product.icon.url
                                  : null,
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
  const _MemeberListTileComponent({
    required this.name,
    required this.imgPath,
    required this.disable,
    required this.iconUrl,
  });
  final String imgPath;

  final String name;
  final bool disable;
  final String? iconUrl;
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
        border: Border.all(color: AppColors.grayscale300),
        borderRadius: BorderRadius.circular(Dimension.d2),
      ),
      child: Row(
        children: [
          Avatar.fromSize(
            imgPath: '${Env.serverUrl}$imgPath',
            size: AvatarSize.size14,
          ),
          const SizedBox(width: Dimension.d2),
          Expanded(
            child: Text(
              name,
              style: AppTextStyle.bodyLargeMedium.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(
            width: Dimension.d1,
          ),
          if (iconUrl != null)
            Avatar.fromSize(
              imgPath: iconUrl == null ? '' : '${Env.serverUrl}$iconUrl',
              size: AvatarSize.size9,
              isImageSquare: true,
            )
        ],
      ),
    );
  }
}
