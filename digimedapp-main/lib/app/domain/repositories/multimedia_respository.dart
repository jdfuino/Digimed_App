
import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class MultimediaRepository{
  Future<File?> getImage(ImageSource source);
}