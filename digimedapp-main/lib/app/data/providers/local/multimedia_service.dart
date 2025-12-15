import 'dart:io';

import 'package:digimed/app/presentation/global/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MultimediaService {
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  MultimediaService(this._imagePicker, this._imageCropper);

  Future<File?> getImageMultimedia(ImageSource source) async {
    final pickedImage =
        await _imagePicker.pickImage(source: source);
    if(pickedImage != null){
      return await _cropImage(pickedImage.path);
    }
    return null;
  }

  Future<File?> _cropImage(String path) async{
    final crop = await _imageCropper.cropImage(
        sourcePath: path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Editor de Imagen',
              toolbarColor: AppColors.backgroundColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              hideBottomControls: true,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Editor de Imagen',
            doneButtonTitle: "Ok",
            cancelButtonTitle: "Cancelar"
          )
        ]
    );

    if(crop != null){
      return File(crop.path);
    }
    return null;
  }
}
