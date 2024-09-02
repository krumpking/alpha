import 'package:alpha/custom_widgets/snackbar/custom_snackbar.dart';
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
    if (userProfile.documentUrl == null) {
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



  static Future<DateTime?> pickDate({required BuildContext context, required DateTime initialDate,}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    return picked;
  }

  static Future<String> showWeekPicker(BuildContext context) async {
    final selectedDays = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedDays = [];
        List<String> weekDays = [
          'Monday', 'Tuesday', 'Wednesday', 'Thursday',
          'Friday', 'Saturday', 'Sunday'
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
            TextButton(
              onPressed: Get.back,
              child: const Text('Cancel')
            ),
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


  static List<String> addSpecialisation({required String value, required List<String> specialisations}) {
    if (value.isNotEmpty && !specialisations.contains(value)) {
        specialisations.add(value);
    }

    return specialisations;
  }


}
