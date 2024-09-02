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

  static Future<APIResponse<String>> uploadImageToChat(
      {required File file, required String chatID}) async {
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
}
