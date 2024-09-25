import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  static void deleteNote({
    required Note note
  }) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note"),
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
                const CustomLoader(message: 'Deleting Note'),
                barrierDismissible: false,
              );


              // Update the user's profile in Firestore
              final response = await NotesServices.deleteNoteFromFirebase(noteID: note.noteID);

              // Close the loader dialog
              if (Get.isDialogOpen!) Get.back();

              // Show a success or error message
              if (response.success) {
                CustomSnackBar.showSuccessSnackbar(
                    message: 'Note deleted successfully');
              } else {
                CustomSnackBar.showErrorSnackbar(
                    message: response.message ?? 'Failed to delete note');
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


}
