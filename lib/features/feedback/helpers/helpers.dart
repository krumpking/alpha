import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/feedback/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../manage_profile/models/user_profile.dart';

class FeedbackHelper {
  static void validateAndSubmitFeedback(
      {required User currentUser,
      required UserProfile selectedUser,
      required String description,
      required String feedbackSource,
      required String feedbackTitle}) async {
    // Validate User
    if (!GetUtils.isEmail(selectedUser.email!)) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Invalid email for assigned user.');
      return;
    }

    if (description.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Description is required.');
      return;
    }

    if (feedbackTitle.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Title is required.');
      return;
    }

    // Show loader while submitting feedback
    Get.dialog(
      const CustomLoader(
        message: 'Submitting feedback',
      ),
      barrierDismissible: false,
    );

    // Submit the shift
    await FeedbackServices.submitFeedback(
            currentUser: currentUser,
            selectedUser: selectedUser,
            description: description,
            feedbackSource: feedbackSource,
            feedbackTitle: feedbackTitle)
        .then((response) {
      if (!response.success) {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Failed to submit feedback');
      } else {
        if (Get.isDialogOpen!) Get.back();
        CustomSnackBar.showSuccessSnackbar(
            message: 'Shift submitted successfully');
      }
    });
  }
}
