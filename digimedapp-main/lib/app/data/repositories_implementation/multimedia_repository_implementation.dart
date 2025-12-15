
import 'dart:io';

import 'package:digimed/app/data/providers/local/multimedia_service.dart';
import 'package:digimed/app/domain/repositories/multimedia_respository.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class MultimediaRepositoryImplementation implements MultimediaRepository{

  final MultimediaService multimediaService;

  MultimediaRepositoryImplementation({required this.multimediaService});


  @override
  Future<File?> getImage(ImageSource source) {
    return multimediaService.getImageMultimedia(source);
  }

}