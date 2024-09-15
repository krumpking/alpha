import 'dart:math';

import 'package:alpha/core/utils/validator.dart';
import 'package:alpha/features/shift/services/add_shif_services.dart';
import 'package:alpha/models/shift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../../models/user_profile.dart';

class ShiftHelpers {
  static void validateAndSubmitShift({
    required Shift shift,
  }) async {

    // Validate Email
    if (!Validator.isValidTimeFormat(shift.duration)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid time.');
      return;
    }

    // Show loader while submitting shift
    Get.dialog(
      const CustomLoader(
        message: 'Submitting shift',
      ),
      barrierDismissible: false,
    );

    await ShiftServices.updateShift(
      shiftId: shift.shiftId,
      updatedShift: shift,
    ).then((response) {
      if (!response.success) {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Failed to submit shift');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(
            message: 'Shift updated successfully');
      }
    });
  }


  static void addUserShift({
    required Shift shift
  }) async {
    // Validate Place Name
    if (shift.placeName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Place name is required.');
      return;
    }

    // Validate Start Time
    if (shift.startTime.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Start time is required.');
      return;
    }

    // Validate End Time
    if (shift.endTime.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'End time is required.');
      return;
    }

    // Validate Date
    if (shift.date.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Shift date is required.');
      return;
    }

    // Validate Contact Person
    if (shift.contactPersonNumber.isEmpty || !GetUtils.isPhoneNumber(shift.contactPersonNumber)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Valid contact person number is required.');
      return;
    }

    // Validate Alternative Contact (Optional but still checked if provided)
    if (shift.contactPersonAltNumber.isNotEmpty && !GetUtils.isPhoneNumber(shift.contactPersonAltNumber)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Valid alternative contact number is required.');
      return;
    }

    // Show loader while submitting shift
    Get.dialog(
      const CustomLoader(
        message: 'Submitting shift',
      ),
      barrierDismissible: false,
    );

    // Submit the shift
    await ShiftServices.submitUserShift(
      shift: shift
    ).then((response) {
      if (!response.success) {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Failed to submit shift');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(
            message: 'Shift added successfully');
      }
    });
  }

  static String calculateDuration({required String shiftStartTime, required String shiftEndTime}) {
    if (shiftStartTime.isNotEmpty && shiftStartTime.isNotEmpty) {
      final format = DateFormat('HH:mm');
      final startTime = format.parse(shiftStartTime);
      final endTime = format.parse(shiftEndTime);

      // Calculate the difference in minutes
      final difference = endTime.difference(startTime);

      // Set the duration in hours and minutes
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      return '${hours}h ${minutes}m';
    }

    return '';
  }

  static String generateRandomId(String email) {
    final now = DateTime.now();

    final emailLetters = email.replaceAll(RegExp(r'[^a-zA-Z]'), '');

    final random = Random(now.millisecondsSinceEpoch);

    final pool = '${emailLetters.isEmpty ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : emailLetters}abcdefghijklmnopqrstuvwxyz';

    // Generate a 15-character long ID using random letters from the pool
    String generateId() {
      return List.generate(15, (index) => pool[random.nextInt(pool.length)]).join();
    }

    return generateId();
  }
}
