import 'package:alpha/core/utils/routes.dart';
import 'package:alpha/features/add_user/services/add_user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';

class AddUserHelper {
  static void validateAndSubmitForm({
    required String password,
    required String email,
    required String phoneNUmber,
    required String role,
  }) async {
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Password is required.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        'Error',
        'Password is too short.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please input a valid email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Creating user',
      ),
      barrierDismissible: false,
    );

    await AddUserServices.addUserToFirebase(
      email: email,
      selectedRole: role.toLowerCase(),
      phoneNumber: phoneNUmber
    ).then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        Get.snackbar(
          'Error',
          response.message ?? 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        if (Get.isDialogOpen!) Get.back();

        // Show success snackbar
        Get.snackbar(
          'Success',
          'User account created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

}