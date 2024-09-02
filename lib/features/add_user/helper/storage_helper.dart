import 'dart:io';
import 'package:get/get.dart';

import '../../../core/utils/logs.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../services/media_services.dart';
import '../services/storage_services.dart';
import 'package:path/path.dart' as path;


class StorageHelper{
  static Future<String?> triggerDocUpload() async{
    final selectedFile = await MediaServices.pickDocument();

    if (selectedFile != null) {

      Get.dialog(
        const CustomLoader(
          message: 'Uploading Document',
        ),
        barrierDismissible: false,
      );


      // Convert the file to Base64 string
      final base64String = await MediaServices.fileToBase64(selectedFile);

      final response = await StorageServices.uploadFileAsBase64(
        base64String: base64String,
        fileName: path.basename(selectedFile.path),
      );

      if (response.success) {
        DevLogs.logSuccess("File uploaded successfully: ${response.data}");

        if (Get.isDialogOpen!) Get.back();

        CustomSnackBar.showSuccessSnackbar(message: 'Document uploaded Successfully');

        return response.data!;
      } else {
        DevLogs.logError("File upload failed: ${response.message}");

      }
    }
    return null;
  }
}