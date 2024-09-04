import 'package:alpha/features/add_shift/services/add_shif_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../../models/user_profile.dart';

class ShiftHelpers{
  static void validateAndSubmitShift({
    required User currentUser,
    required UserProfile selectedUser,
    required bool isCompleted,
    required int hoursCompleted,
    required String documentName,
  }) async {
    // Validate User
    if (!GetUtils.isEmail(selectedUser.email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Invalid email for assigned user.');
      return;
    }

    if (selectedUser.name.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Assigned user name is required.');
      return;
    }

    // Validate Hours Completed
    if (hoursCompleted <= 0) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input valid hours completed.');
      return;
    }

    // Validate Document Name
    if (documentName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Document name is required.');
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
    await ShiftServices.submitShift(
      currentUser: currentUser,
      selectedUser: selectedUser,
      isCompleted: isCompleted,
      hoursCompleted: hoursCompleted,
      documentName: documentName,
    ).then((response) {
      if (!response.success) {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Failed to submit shift');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(message: 'Shift submitted successfully');
      }
    });
  }
}
