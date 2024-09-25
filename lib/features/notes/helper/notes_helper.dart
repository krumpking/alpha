import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../models/comment.dart';
import '../models/note.dart';
import '../services/notes_services.dart';

class NotesHelper {
  static Future<void> validateAndSubmitNotes({
    required Note note,
  }) async {
    // Validate Email
    if (!GetUtils.isEmail(note.email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return;
    }

    // Validate Title
    if (note.title.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Title is required.');
      return;
    }

    // Validate Description
    if (note.description.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Description is required.');
      return;
    }

    // Validate Content
    if (note.content.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Note content is required.');
      return;
    }

    // Show Loading Dialog
    Get.dialog(
      const CustomLoader(
        message: 'Adding Note',
      ),
      barrierDismissible: false,
    );

    try {
      final response = await NotesServices.addNotesToFirebase(note: note);

      // Close the loading dialog
      if (Get.isDialogOpen!) Get.back();

      if (response.success) {
        // Show success snackbar
        CustomSnackBar.showSuccessSnackbar(message: response.message ?? 'Note added successfully');
        Get.back();
      } else {
        // Show error snackbar
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      CustomSnackBar.showErrorSnackbar(message: 'An error occurred: $e');
    }
  }

  static Future<void> validateAndUpdateNotes({
    required Note note,
  }) async {
    // Validate Email
    if (!GetUtils.isEmail(note.email)) {
      CustomSnackBar.showErrorSnackbar(message: 'Please input a valid email.');
      return;
    }

    // Validate Title
    if (note.title.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Title is required.');
      return;
    }

    // Validate Description
    if (note.description.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Description is required.');
      return;
    }

    // Validate Content
    if (note.content.isEmpty) {
      CustomSnackBar.showErrorSnackbar(message: 'Note content is required.');
      return;
    }

    // Show Loading Dialog
    Get.dialog(
      const CustomLoader(
        message: 'Updating Note',
      ),
      barrierDismissible: false,
    );

    try {
      final response = await NotesServices.updateNoteInFirebase(noteID: note.noteID ,updatedNote: note);

      // Close the loading dialog
      if (Get.isDialogOpen!) Get.back();

      if (response.success) {
        // Show success snackbar
        CustomSnackBar.showSuccessSnackbar(message: response.message ?? 'Note updated successfully');
        Get.back();
      } else {
        // Show error snackbar
        CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Something went wrong');
      }
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();
      CustomSnackBar.showErrorSnackbar(message: 'An error occurred: $e');
    }
  }


  static void addComment({required Note note, required String comment, required User user}) {
    if (comment.isNotEmpty) {
      final newComment = Comment(
        addedBy: user.displayName ?? 'Unknown',
        description: comment,
        dateAdded: DateTime.now(),
      );

      final comments = note.comments;

      comments.add(newComment);

      final updateNote = note.copyWith(
          comments: comments
      );

      NotesHelper.validateAndUpdateNotes(
          note: updateNote
      );
    }
  }


}
