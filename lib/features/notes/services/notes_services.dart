import 'package:alpha/features/notes/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/utils/api_response.dart';

class NotesServices{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a user to Firebase Firestore
  static Future<APIResponse<String?>> addNotesToFirebase({
    required Note note,
  }) async {
    try {
      final userNotes = note.toJson();
      await _firestore.collection('notes').add(userNotes);

      return APIResponse(success: true, data: '', message: 'Notes added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }


  // Existing method for fetching feedback by email
  static Stream<List<Note>> streamNotesByEmail(
      {required String email}) {
    return FirebaseFirestore.instance
        .collection('notes')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Note.fromJson(doc.data()))
          .toList();
    });
  }

  // Method to fetch notes by email with a one-time get request
  static Future<APIResponse<List<Note>>> getNotesByEmail({
    required String email,
  }) async {
    try {
      // Query Firestore to get notes for the user
      final querySnapshot = await _firestore
          .collection('notes')
          .where('email', isEqualTo: email)
          .get();

      // Map the query results to Note objects
      final notesList = querySnapshot.docs
          .map((doc) => Note.fromJson(doc.data()))
          .toList();

      return APIResponse(
        success: true,
        data: notesList,
        message: 'Notes fetched successfully',
      );
    } catch (e) {
      return APIResponse(success: false, message: 'Error fetching notes: $e');
    }
  }


  static Future<APIResponse<String?>> updateNoteInFirebase({
    required String noteID,
    required Note updatedNote,
  }) async {
    try {
      // Query to find the document where noteID matches
      QuerySnapshot snapshot = await _firestore
          .collection('notes')
          .where('noteID', isEqualTo: noteID)
          .limit(1)
          .get();

      // Check if the document exists
      if (snapshot.docs.isEmpty) {
        return APIResponse(success: false, message: 'Note not found');
      }

      // Update the first matching document
      final docRef = snapshot.docs.first.reference;
      final userNotes = updatedNote.toJson();

      await docRef.update(userNotes);

      return APIResponse(success: true, data: '', message: 'Note updated successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
  static Future<APIResponse<String?>> deleteNoteFromFirebase({
    required String noteID,
  }) async {
    try {
      // Query to find the document where noteID matches
      QuerySnapshot snapshot = await _firestore
          .collection('notes')
          .where('noteID', isEqualTo: noteID)
          .limit(1)
          .get();

      // Check if the document exists
      if (snapshot.docs.isEmpty) {
        return APIResponse(success: false, message: 'Note not found');
      }

      // Delete the first matching document
      final docRef = snapshot.docs.first.reference;
      await docRef.delete();

      return APIResponse(success: true, data: '', message: 'Note deleted successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}
