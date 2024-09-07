import 'package:alpha/custom_widgets/snackbar/custom_snackbar.dart';
import 'package:alpha/features/workers/services/add_user_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../models/user_profile.dart';

class AddUserHelper {
  static void validateAndSubmitForm({
    required UserProfile userProfile,
  }) async {
    // Validate Email
    if (!GetUtils.isEmail(userProfile.email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return;
    }

    // Validate Phone Number
    if (userProfile.phoneNumber.isEmpty ||
        !GetUtils.isPhoneNumber(userProfile.phoneNumber)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input a valid phone number.');
      return;
    }

    // Validate Name
    if (userProfile.name.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Name is required.');
      return;
    }

    if (userProfile.city.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'City is required.');
      return;
    }

    if (userProfile.state.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'State is required.');
      return;
    }

    if (userProfile.country.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Country is required.');
      return;
    }

    // Validate Name
    if (userProfile.preferredWorkDays.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Input working days');
      return;
    }

    // Validate Address
    if (userProfile.address.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Address is required.');
      return;
    }

    // Validate Previous Employer
    if (userProfile.previousEmployer.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Previous Employer is required.');
      return;
    }

    // Validate Contact Information
    if (userProfile.contactInformation.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Contact Information is required.');
      return;
    }

    // Validate Role
    if (userProfile.role.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Role is required.');
      return;
    }

    // Validate Specialisations
    if (userProfile.specialisations.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'At least one specialisation is required.');
      return;
    }

    // Validate Document
    if (userProfile.documents.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Document upload is required.');
      return;
    }

    // Show loader while creating user
    Get.dialog(
      const CustomLoader(
        message: 'Creating user',
      ),
      barrierDismissible: false,
    );

    await StaffServices.addStuffToFirebase(userProfile: userProfile)
        .then((response) {
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Something went wrong');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(
            message: 'User account created successfully');
      }
    });
  }

  static Future<DateTime?> pickDate(
      {required BuildContext context,
      required DateTime initialDate,
      DateTime? firstDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );

    return picked;
  }

  static Future<TimeOfDay?> pickTime({
    required BuildContext context,
  }) async {
    final picked = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 6, minute: 00));

    return picked;
  }

  static Future<String> showWeekPicker(BuildContext context) async {
    final selectedDays = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedDays = [];
        List<String> weekDays = [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday'
        ];

        return AlertDialog(
          title: const Text('Select Preferred Work Days'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: weekDays.map((day) {
                  return CheckboxListTile(
                    title: Text(day),
                    value: selectedDays.contains(day),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          actions: <Widget>[
            TextButton(onPressed: Get.back, child: const Text('Cancel')),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(selectedDays);
              },
            ),
          ],
        );
      },
    );

    return selectedDays!.join(', ');
  }

  static List<String> addSpecialisation(
      {required String value, required List<String> specialisations}) {
    if (value.isNotEmpty && !specialisations.contains(value)) {
      specialisations.add(value);
    }
    return specialisations;
  }
}
