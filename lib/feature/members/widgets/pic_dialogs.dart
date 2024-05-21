// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: inference_failure_on_function_invocation, deprecated_member_use, lines_longer_than_80_chars

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:silver_genie/core/constants/colors.dart';
import 'package:silver_genie/core/constants/text_styles.dart';
import 'package:silver_genie/core/icons/app_icons.dart';
import 'package:silver_genie/core/utils/image_store/image_store.dart';
import 'package:silver_genie/core/widgets/avatar.dart';
import 'package:silver_genie/core/widgets/selector.dart';

class EditPic extends StatefulWidget {
  EditPic({
    required this.storedProfileImage,
    required this.imgUrl,
    Key? key,
  }) : super(key: key);
  File? storedProfileImage;
  String? imgUrl;

  @override
  State<EditPic> createState() => _EditPicState();
}

class _EditPicState extends State<EditPic> {


  void _updateProfileImage(File? image) {
    setState(() {
      widget.storedProfileImage = image;
    });
  }

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
                  storedProfileImage: widget.storedProfileImage,
                  onImageSelected: _updateProfileImage,
                );
              },
            );
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              if (widget.imgUrl == null && widget.storedProfileImage == null)
                Avatar.fromSize(imgPath: 'imgPath', size: AvatarSize.size56)
              else
                CircleAvatar(
                  radius: 56,
                  backgroundImage: widget.storedProfileImage != null
                      ? FileImage(widget.storedProfileImage!) as ImageProvider
                      : NetworkImage(widget.imgUrl!),
                ),
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
  File? storedProfileImage;
  final Function(File) onImageSelected;
  ChangePicDialog({
    required this.storedProfileImage,
    required this.onImageSelected, Key? key,
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
                await takePhoto();
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
                await chooseImage();
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
                removeProfileImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> takePhoto() async {
    try {
      final XFile? receivedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (receivedImage == null) {
        return;
      }
      File imageFile = File(receivedImage.path);
      storedProfileImage = imageFile;

      CroppedFile? croppedFile = await _cropImage(storedProfileImage!);
      if (croppedFile != null) {
        storedProfileImage = File(croppedFile.path);
        onImageSelected(await saveImageToDirectory(storedProfileImage!));
        if (!storedProfileImage!.existsSync()) {
          print("Cropped file does not exist: ${storedProfileImage!.path}");
        }
      }
    } catch (e) {
      print("Error taking photo: $e");
    }
  }

  Future<void> chooseImage() async {
    try {
      final XFile? receivedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (receivedImage == null) {
        return;
      }
      File imageFile = File(receivedImage.path);
      storedProfileImage = imageFile;

      CroppedFile? croppedFile = await _cropImage(storedProfileImage!);
      if (croppedFile != null) {
        storedProfileImage = File(croppedFile.path);
        onImageSelected(await saveImageToDirectory(storedProfileImage!));
        if (!storedProfileImage!.existsSync()) {
          print("file does not exist: ${storedProfileImage!.path}");
        }
      }
    } catch (e) {
      print("Error choosing image: $e");
    }
  }

  Future<void> removeProfileImage() async {
    storedProfileImage = null;
  }

  Future<CroppedFile?> _cropImage(File imageFile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Profile Image',
            backgroundColor: AppColors.secondary,
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            cropFrameColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false)
      ],
    );

    return croppedImage;
  }
}
