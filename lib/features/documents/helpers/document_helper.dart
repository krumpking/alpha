import 'package:alpha/features/documents/models/document.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:alpha/features/workers/services/add_user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../core/utils/providers.dart';
import '../../../core/utils/string_methods.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';

class DocumentHelper {
  static void deleteDocument({
    required Document document,
    required UserProfile profile,
    required WidgetRef ref,
  }) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Document"),
        content: const Text("Are you sure you want to delete this document?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Dismiss the dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close the dialog

              // Show a loading indicator while processing the deletion
              Get.dialog(
                const CustomLoader(message: 'Deleting Document'),
                barrierDismissible: false,
              );

              // Remove the document from the user's document list
              final updatedDocuments = profile.documents
                  .where((doc) => doc.docID != document.docID)
                  .toList();

              // Create an updated profile without the deleted document
              final updatedProfile =
                  profile.copyWith(documents: updatedDocuments);

              // Update the user's profile in Firestore
              final response = await StaffServices.updateUserProfile(
                email: profile.email!,
                updatedProfile: updatedProfile,
              );

              // Close the loader dialog
              if (Get.isDialogOpen!) Get.back();

              // Show a success or error message
              if (response.success) {
                // Notify the provider to update the global state
                ref
                    .read(
                        ProviderUtils.profileProvider(profile.email!).notifier)
                    .deleteDocument(document);

                CustomSnackBar.showSuccessSnackbar(
                    message: 'Document deleted successfully');
              } else {
                CustomSnackBar.showErrorSnackbar(
                    message: response.message ?? 'Failed to delete document');
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
      barrierDismissible: false,
      useSafeArea: true,
      name: 'Delete Document Confirmation',
    );
  }

  static void validateAndSubmitDocument({
    required UserProfile profile,
    required String docName,
    required String docDescription,
    required String expiryDate,
    required String docLink,
  }) async {
    // Validation checks
    if (docName.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a document name');
      return;
    }

    if (docDescription.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input a document description');
      return;
    }

    if (expiryDate.isEmpty) {
      CustomSnackBar.showErrorSnackbar(
          message: 'Please input a document expiry date');
      return;
    }

    if (docLink.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Document not uploaded');
      return;
    }

    // Show loading dialog
    Get.dialog(
      const CustomLoader(message: 'Submitting Document'),
      barrierDismissible: false,
    );

    // Create an updated profile with the new document
    final updatedProfile = profile.copyWith(
      documents: [
        ...profile.documents,
        Document(
          docID: StringMethods.generateRandomString(),
          documentName: docName,
          expiryDate: expiryDate,
          documentDescription: docDescription,
          documentUrl: docLink,
        ),
      ],
    );

    try {
      final response = await StaffServices.updateUserProfile(
        email: profile.email!,
        updatedProfile: updatedProfile,
      );

      // Ensure the dialog is closed
      if (Get.isDialogOpen!) Get.back();

      if (response.success) {
        CustomSnackBar.showSuccessSnackbar(
            message: 'Document added successfully');
        Get.back(
            closeOverlays: true); // Optionally close the form/screen if needed
      } else {
        CustomSnackBar.showErrorSnackbar(
            message: response.message ?? 'Failed to submit document');
      }
    } catch (e) {
      // Handle any unexpected errors and close the dialog if open
      if (Get.isDialogOpen!) Get.back();
      CustomSnackBar.showErrorSnackbar(message: 'An error occurred: $e');
    }
  }
}
