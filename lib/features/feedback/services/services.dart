import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/api_response.dart';
import '../../../global/global.dart';
import '../../../models/user_profile.dart';

class FeedbackServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<void>> submitFeedback({
    required User currentUser,
    required UserProfile selectedUser,
    required String description,
    required String shiftId,
    required String feedbackTitle,
  }) async {
    var feedback = FeedbackModel(
      date: DateTime.now().toString(),
      addedBy: currentUser.email!,
      feedackTitle: feedbackTitle,
      description: description,
      userEmail: selectedUser.email,
    );
    try {
      await FirebaseFirestore.instance
          .collection('feedback')
          .add(feedback.toJson());
      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to submit feedback: ${e.toString()}');
    }
  }

  static Future<APIResponse<List<Map<String, dynamic>>>> fetchShifts() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('shifts').get();
      List<Map<String, dynamic>> shifts = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return APIResponse(success: true, data: shifts);
    } catch (e) {
      return APIResponse(
          success: false, message: 'Failed to fetch shifts: ${e.toString()}');
    }
  }

  // Method to fetch all users from Firebase Firestore
  static Future<APIResponse<List<FeedbackModel>>> fetchAllFeedback(
      String email) async {
    try {
      // Fetch all documents from the 'users' collection
      final QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore
          .collection('feedback')
          .where('userEmail', isEqualTo: email)
          .get();

      DevLogs.logInfo('Fetched feedback for ${userSnapshot.docs} users');

      // Map the documents to a list of UserProfile objects
      final List<FeedbackModel> feedback = userSnapshot.docs
          .map((doc) => FeedbackModel.fromJson(doc.data()))
          .toList();

      return APIResponse(
          success: true,
          data: feedback,
          message: 'Feedback retrieved successfully');
    } catch (e) {
      DevLogs.logError(e.toString());
      return APIResponse(success: false, message: e.toString());
    }
  }
}
