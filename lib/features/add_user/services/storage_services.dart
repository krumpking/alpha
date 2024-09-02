import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../../core/utils/api_response.dart';

class StorageServices {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<APIResponse<String>> uploadDp({required File file}) async {
    try {
      Reference fileRef = _storage
          .ref('users/dps')
          .child('${DateTime.now().toString()}${extension(file.path)}');

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;
      if (snapshot.state == TaskState.success) {
        String downloadURL = await fileRef.getDownloadURL();
        return APIResponse<String>(data: downloadURL, success: true);
      } else {
        return APIResponse<String>(message: 'Upload failed', success: false);
      }
    } catch (e) {
      return APIResponse<String>(message: e.toString(), success: false);
    }
  }

  static Future<APIResponse<String>> uploadImageToChat({required File file, required String chatID}) async {
    try {
      Reference fileRef = _storage
          .ref('chats/$chatID')
          .child('${DateTime.now().toIso8601String()}${extension(file.path)}');

      UploadTask task = fileRef.putFile(file);

      TaskSnapshot snapshot = await task;
      if (snapshot.state == TaskState.success) {
        String downloadURL = await fileRef.getDownloadURL();
        return APIResponse<String>(data: downloadURL, success: true);
      } else {
        return APIResponse<String>(message: 'Upload failed', success: false);
      }
    } catch (e) {
      return APIResponse<String>(message: e.toString(), success: false);
    }
  }

  static Future<APIResponse<String>> uploadFileAsBase64({
    required String base64String,
    required String fileName,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('documents/$fileName');
      final uploadTask = storageRef.putString(base64String, format: PutStringFormat.base64);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return APIResponse<String>(data: downloadUrl, success: true);
    } catch (e) {
      return APIResponse<String>(message: e.toString(), success: false);
    }
  }


  static Future<APIResponse<File>> downloadAndDecodeFile(String url, String savePath) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final base64String = await ref.getData();
      if (base64String != null) {
        final bytes = base64Decode(String.fromCharCodes(base64String));
        final file = File(savePath);
        await file.writeAsBytes(bytes);
        return APIResponse<File>(data: file, success: true);
      }
      return APIResponse<File>(message: "Failed to decode the file.", success: false);
    } catch (e) {
      return APIResponse<File>(message: e.toString(), success: false);
    }
  }
}
