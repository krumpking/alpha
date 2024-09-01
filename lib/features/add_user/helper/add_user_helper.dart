import 'package:alpha/core/utils/routes.dart';
import 'package:alpha/features/add_user/services/add_user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../models/user_profile.dart';

class AddUserHelper {
  static void validateAndSubmitForm({
    required String password,
    required String email,
    required String phoneNumber,
    required String role,
    required UserProfile userProfile,
  }) async {
    // Validate Password
    if (password.isEmpty) {
      showErrorSnackbar('Password is required.');
      return;
    }

    if (password.length < 8) {
      showErrorSnackbar('Password is too short.');
      return;
    }

    // Validate Email
    if (!GetUtils.isEmail(email)) {
      showErrorSnackbar('Please input a valid email.');
      return;
    }

    // Validate Phone Number
    if (phoneNumber.isEmpty || !GetUtils.isPhoneNumber(phoneNumber)) {
      showErrorSnackbar('Please input a valid phone number.');
      return;
    }

    // Validate Name
    if (userProfile.name.isEmpty) {
      showErrorSnackbar('Name is required.');
      return;
    }

    // Validate Address
    if (userProfile.address.isEmpty) {
      showErrorSnackbar('Address is required.');
      return;
    }

    // Validate Previous Employer
    if (userProfile.previousEmployer.isEmpty) {
      showErrorSnackbar('Previous Employer is required.');
      return;
    }

    // Validate Contact Information
    if (userProfile.contactInformation.isEmpty) {
      showErrorSnackbar('Contact Information is required.');
      return;
    }

    // Validate Role
    if (role.isEmpty) {
      showErrorSnackbar('Role is required.');
      return;
    }

    // Validate Specialisations
    if (userProfile.specialisations.isEmpty) {
      showErrorSnackbar('At least one specialisation is required.');
      return;
    }

    // Validate Document
    if (userProfile.document == null || userProfile.document!.path.isEmpty) {
      showErrorSnackbar('Document upload is required.');
      return;
    }

    // Validate Document Expiry Date
    if (userProfile.expiryDate == null) {
      showErrorSnackbar('Document expiry date is required.');
      return;
    }

    // Show loader while creating user
    Get.dialog(
      const CustomLoader(
        message: 'Creating user',
      ),
      barrierDismissible: false,
    );

    await StuffServices.addStuffToFirebase(
      email: email,
      selectedRole: role.toLowerCase(),
      phoneNumber: phoneNumber,
      userProfile: userProfile, // Add userProfile to the service call
    ).then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        showErrorSnackbar(response.message ?? 'Something went wrong');
      } else {
        if (Get.isDialogOpen!) Get.back();
        showSuccessSnackbar('User account created successfully');
      }
    });
  }

  static void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
