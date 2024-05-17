// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: inference_failure_on_function_invocation, deprecated_member_use, lines_longer_than_80_chars

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/image_store/image_store.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/selector.dart';

class EditPic extends StatelessWidget {
  EditPic({
    Key? key,
  }) : super(key: key);
  final store = GetIt.I<ImageStore>();
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return ChangePicDialog(
                  imageStore: store,
                );
              },
            );
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              if (store.storedProfileImage == null) Avatar.fromSize(imgPath: 'imgPath', size: AvatarSize.size56) else CircleAvatar(radius: 56,backgroundImage: FileImage(store.storedProfileImage!),),
              Container(
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                  color: AppColors.primary,
                ),
                padding: const EdgeInsets.all(6),
                child: SvgPicture.asset(
                  
                      'assets/icon/edit.svg',
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChangePicDialog extends StatelessWidget {
  final ImageStore imageStore;
  ChangePicDialog({
    required this.imageStore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20)
            .copyWith(top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change your picture'.tr(),
              style: AppTextStyle.bodyXLBold,
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.line),
            const SizedBox(height: 15),
            Selector(
              icon: AppIcons.camera,
              title: 'Take a photo',
              selectorType: SelectorType.withBorder,
              iconColor: AppColors.grayscale900,
              textColor: AppColors.grayscale900,
              ontap: () async {
                await imageStore.takePhoto();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 15),
            Selector(
              icon: AppIcons.folder_open,
              title: 'Choose from file',
              selectorType: SelectorType.withBorder,
              iconColor: AppColors.grayscale900,
              textColor: AppColors.grayscale900,
              ontap: () async {
                await imageStore.chooseImage();
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 15),
            Selector(
              icon: AppIcons.delete,
              title: 'Remove',
              selectorType: SelectorType.withBorder,
              iconColor: AppColors.error,
              textColor: AppColors.error,
              ontap: () {
                imageStore.removeProfileImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
