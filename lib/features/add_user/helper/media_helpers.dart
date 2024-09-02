import 'dart:io';

import 'package:alpha/features/auth/state/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../services/storage_services.dart';

class MediaHelpers {
  static final User? _currentUser = FirebaseAuth.instance.currentUser;

  static Future<List<File>?> onUploadMediaClick({required BuildContext context, required String documentName}) async {
    List<File>? files = [];
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return Dialog(
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
                      topLeft: Radius.circular(20)
                  )
              ),
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
                          )
                      ),
                      Expanded(flex: 3, child: Container())
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        documentName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      GestureDetector(
                        onTap: ()async{

                          if(files != null && files!.isNotEmpty){
                            showDialog(
                                context: context,
                                builder: (context){
                                  return CustomLoader(
                                      message: 'Uploading $documentName'
                                  );
                                }
                            );

                            if (documentName == 'Display Picture') {
                              String? imageUrl = await StorageServices.uploadUsedDp(
                                file: files![0],
                                uid: _currentUser!.uid,
                              );

                              await _currentUser!.updatePhotoURL(imageUrl).then((value){
                                Get.back();
                              });

                              final updatedUser = FirebaseAuth.instance.currentUser;
                              userProvider.(updatedUser);

                              CustomSnackBar.showSuccessSnackbar(message: 'Display Image updated Successfully');
                            }

                            else{

                            }

                          }else{
                            showErrorDialog(
                                'Please select your $documentName Image',
                                context
                            );
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
                                    color: Pallete.primaryColor
                                ),
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              const Icon(
                                Icons.check,
                                color: Colors.blue,
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
                                      color: Pallete.primaryColor.withOpacity(0.5)
                                  )
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Pallete.primaryColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                                'Camera',
                                style: TextStyle(
                                    color: Colors.black
                                )
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if(documentName != 'Display Picture'){
                            files = await MediaServices.getMultipleImagesFromGallery();
                          } else {
                            final file = await MediaServices.getImageFromGallery();
                            if(file != null) {
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
                                      color: Pallete.primaryColor.withOpacity(0.5)
                                  )
                              ),
                              child: Icon(
                                Icons.image_outlined,
                                color: Pallete.primaryColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text(
                                'Gallery',
                                style: TextStyle(
                                    color: Colors.black
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );

    return files!.isNotEmpty ? files : null;
  }
}