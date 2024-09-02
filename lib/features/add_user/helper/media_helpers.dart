import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alpha/features/add_user/services/storage_services.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../auth/state/authentication_provider.dart';
import '../services/media_services.dart';
import '../state/profilr_pic_provider.dart';

class MediaHelpers {

  static Future<List<File>?> onUploadMediaClick({required bool isStaffProfile, required String documentName, required WidgetRef ref}) async {
    List<File>? files = [];
    Get.dialog(
      Dialog(
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 200,
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(flex: 3, child: Container()),
                  const Expanded(
                      flex: 1,
                      child: Divider(
                        thickness: 5,
                        color: Colors.grey,
                      )),
                  Expanded(flex: 3, child: Container())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    documentName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (files != null && files!.isNotEmpty) {
                        Get.dialog(
                          const CustomLoader(
                            message: 'Logging in',
                          ),
                          barrierDismissible: false,
                        );

                        if (documentName == 'Display Picture') {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          // Use the new function to upload staff profile picture
                          final response = await StorageServices.uploadDp(
                            file: files![0],
                          );

                          if (response.success  && isStaffProfile) {
                            ref.read(staffProfilePicProvider.notifier).state = response.data;


                            if (Get.isDialogOpen!) Get.back();

                            CustomSnackBar.showSuccessSnackbar(message: 'Display Image updated Successfully');

                          } else if (response.success && !isStaffProfile) {

                            await currentUser!.updatePhotoURL(response.data).then((value){
                              Get.back();
                            });

                            final updatedUser = FirebaseAuth.instance.currentUser;


                            ref.read(userProvider.notifier).updateUser(updatedUser);

                            if (Get.isDialogOpen!) Get.back();

                            CustomSnackBar.showSuccessSnackbar(message: 'Display Image updated Successfully');
                          } else {
                            CustomSnackBar.showErrorSnackbar(message: 'Failed to upload image');
                          }

                          Get.back();
                        } else {
                          // Handle other document types if necessary
                        }
                      } else {
                        CustomSnackBar.showErrorSnackbar(message: 'Please select your $documentName Image');
                        return;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Pallete.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Done',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Pallete.primaryColor),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.check,
                            color: Pallete.primaryColor,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Pallete.primaryColor.withOpacity(0.5))),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Pallete.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('Camera',
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (documentName != 'Display Picture') {
                        files = await MediaServices.getMultipleImagesFromGallery();
                      } else {
                        final file = await MediaServices.getImageFromGallery();
                        if (file != null) {
                          files!.add(file);
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Pallete.primaryColor.withOpacity(0.5))),
                          child: Icon(
                            Icons.image_outlined,
                            color: Pallete.primaryColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('Gallery',
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return files!.isNotEmpty ? files : null;
  }
}
