import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tranquil_life/general_widgets/custom_loader.dart';
import 'package:tranquil_life/general_widgets/custom_snackbar.dart';

class MediaService {
  Future<File?> selectImageFromCamera() async {
    CustomLoader.showDialog();
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera, imageQuality: 85 // compress image
        );
    if (pickedFile == null) return null;
    return cropImage(File(pickedFile.path));
  }

  Future<File?> selectImageFromGallery() async {
    CustomLoader.showDialog();
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedFile == null) return null;
    return cropImage(File(pickedFile.path));
  }

  // crop image
  Future<File?> cropImage(File file) async {
    var croppedFile = await ImageCropper().cropImage(sourcePath: file.path);
    if (croppedFile == null) return null;
    CustomLoader.cancelDialog();
    return File(croppedFile.path);
  }

  // pick image file or document
  Future<File?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    CustomLoader.cancelDialog();
    return File(result!.files.single.path!);
  }
}

