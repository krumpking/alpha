import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../models/hours_worked.dart';
import '../services/hours_worked_services.dart';

class AddHoursWorkedHelper {

  static void validateAndSubmitHoursWorked({required HoursWorked hoursWorked}) async {
    if (hoursWorked.documents.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Please upload at least one document');
      return;
    }

    if (!GetUtils.isEmail(hoursWorked.staffEmail)) {
      CustomSnackBar.showErrorSnackbar(message: 'Invalid staff');
      return;
    }

    if (hoursWorked.hoursWorked < 1) {
      CustomSnackBar.showErrorSnackbar(message: 'Please enter hours');
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Adding hours worked',
      ),
      barrierDismissible: false,
    );

    try {
      final response = await HoursWorkedService.addHoursWorked(
        hoursWorked: hoursWorked,
      );

      if (!response.success) {
        if (Get.isDialogOpen == true) Get.back(); // Ensure the dialog is closed before showing the snackbar
        CustomSnackBar.showErrorSnackbar(
          message: response.message ?? 'Failed to submit hours worked',
        );
      } else {
        if (Get.isDialogOpen == true) Get.back(); // Close the dialog after success
        CustomSnackBar.showSuccessSnackbar(
          message: 'Hours worked added successfully',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back(); // Close the dialog in case of error
      CustomSnackBar.showErrorSnackbar(message: 'An error occurred: ${e.toString()}');
    }
  }
}
