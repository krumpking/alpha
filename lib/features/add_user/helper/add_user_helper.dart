import 'package:alpha/custom_widgets/snackbar/custom_snackbar.dart';
import 'package:alpha/features/add_user/services/add_user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
      CustomSnackBar.showErrorSnackbar(message: 'Password is required.');
      return;
    }

    if (password.length < 8) {
      CustomSnackBar.showErrorSnackbar(message: 'Password is too short.');
      return;
    }

    // Validate Email
    if (!GetUtils.isEmail(email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return;
    }

    // Validate Phone Number
    if (phoneNumber.isEmpty || !GetUtils.isPhoneNumber(phoneNumber)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid phone number.');
      return;
    }

    // Validate Name
    if (userProfile.name.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Name is required.');
      return;
    }

    // Validate Address
    if (userProfile.address.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Address is required.');
      return;
    }

    // Validate Previous Employer
    if (userProfile.previousEmployer.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Previous Employer is required.');
      return;
    }

    // Validate Contact Information
    if (userProfile.contactInformation.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Contact Information is required.');
      return;
    }

    // Validate Role
    if (role.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Role is required.');
      return;
    }

    // Validate Specialisations
    if (userProfile.specialisations.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'At least one specialisation is required.');
      return;
    }

    // Validate Document
    if (userProfile.document == null || userProfile.document!.path.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Document upload is required.');
      return;
    }

    // Validate Document Expiry Date
    if (userProfile.expiryDate == null) {
      CustomSnackBar.showErrorSnackbar(message: 'Document expiry date is required.');
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
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(message: 'User account created successfully');
      }
    });
  }


  static Future<DateTime> pickExpiryDate({required BuildContext context, required DateTime expiryDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != expiryDate) {
        expiryDate = picked;
    }

    return expiryDate;
  }

  static Future<DateTime> pickPreferredWorkDay({required BuildContext context, required DateTime preferredWorkDay}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != preferredWorkDay) {
        preferredWorkDay = picked;
    }

    return preferredWorkDay;
  }

  static Future<String> pickDob({required BuildContext context, required DateTime dob}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != dob) {
        dob = picked;
    }

    return DateFormat('yyyy-MM-dd').format(dob);
  }

  Future<void> pickDocument() async {
    // Implement file picking logic, using file picker or image picker
  }

  Future<void> pickProfilePicture() async {
    // Implement image picking logic
  }

  static List<String> addSpecialisation({required String value, required List<String> specialisations}) {
    if (value.isNotEmpty && !specialisations.contains(value)) {
        specialisations.add(value);
    }

    return specialisations;
  }


}
