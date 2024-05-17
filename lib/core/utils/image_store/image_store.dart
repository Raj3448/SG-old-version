import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;
import 'package:silver_genie/core/constants/colors.dart';

part 'image_store.g.dart';

class ImageStore = _ImageStoreBase with _$ImageStore;

abstract class _ImageStoreBase with Store {
  @observable
  File? storedProfileImage;

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

  Future<void> _saveImageToDirectory(File imageFile) async {
    final appDirectory =
        await sysPathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final storageResponse =
        await imageFile.copy('${appDirectory.path}/$fileName');
    print("Image Added Successfully at: $storageResponse");
    storedProfileImage = storageResponse;
  }

  @action
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
        await _saveImageToDirectory(storedProfileImage!);
        if (!storedProfileImage!.existsSync()) {
          print("Cropped file does not exist: ${storedProfileImage!.path}");
        }
      }
    } catch (e) {
      print("Error taking photo: $e");
    }
  }

  @action
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
        await _saveImageToDirectory(storedProfileImage!);
        if (!storedProfileImage!.existsSync()) {
          print("Cropped file does not exist: ${storedProfileImage!.path}");
        }
      }
    } catch (e) {
      print("Error choosing image: $e");
    }
  }

  @action
  Future<void> removeProfileImage() async {
    storedProfileImage = null;
  }
}
