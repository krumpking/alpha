import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class MediaServices {
  static final ImagePicker _imagePicker = ImagePicker();


  static Future<File?> getImageFromGallery() async {
    final XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(file != null){
      return File(file.path);
    }

    return null;
  }
  static Future<List<File>?> getMultipleImagesFromGallery() async {
    final List<XFile> files = await _imagePicker.pickMultiImage();

    if (files.isNotEmpty) {
      return files.map((file) => File(file.path)).toList();
    }

    return null;
  }


  static Future<File?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  static Future<String> fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

}