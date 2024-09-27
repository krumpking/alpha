import 'package:alpha/features/hours_worked/services/hours_worked_services.dart';
import 'package:get/get.dart';

import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../models/hours_worked.dart';

class AddHoursWorkedHelper{

  static void validateAndSubmitHoursWorked({required HoursWorked hoursWorked,}) async {

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

    await HoursWorkedService.addHoursWorked(
      hoursWorked: hoursWorked
    ).then((response) {
      if (!response.success) {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Failed to submit hours worked');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(
            message: 'Hours worked added successfully');
      }
    });
  }


}