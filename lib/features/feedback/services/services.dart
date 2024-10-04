import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/api_response.dart';
import '../../../global/global.dart';
import '../../manage_profile/models/user_profile.dart';

class FeedbackServices {

  static Future<APIResponse<void>> submitFeedback({
    required User currentUser,
    required UserProfile selectedUser,
    required String description,
    required String feedbackSource,
    required String feedbackTitle,
  }) async {
    final feedback = FeedbackModel(
      date: DateTime.now().toString(),
      addedBy: currentUser.email!,
      feedbackTitle: feedbackTitle,
      feedbackSource: feedbackSource,
      description: description,
      userEmail: selectedUser.email!,
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

  // Existing method for fetching feedback by email
  static Stream<List<FeedbackModel>> streamFeedbackByEmail(
      {required String email}) {
    return FirebaseFirestore.instance
        .collection('feedback')
        .where('userEmail', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedbackModel.fromJson(doc.data()))
          .toList();
    });
  }

  static Future<APIResponse<List<FeedbackModel>>> getFeedbackByEmail({required String email}) async {
    try {
      // Query Firestore to get feedback for the user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .where('userEmail', isEqualTo: email)
          .get();

      // Map the query results to FeedbackModel objects
      final feedbackList = querySnapshot.docs
          .map((doc) => FeedbackModel.fromJson(doc.data()))
          .toList();

      return APIResponse(
        success: true,
        data: feedbackList,
        message: 'Feedback fetched successfully',
      );
    } catch (e) {
      return APIResponse(success: false, message: 'Error fetching feedback: $e');
    }
  }


  static Future<APIResponse<FeedbackModel>> getFeedbackByShift({required String feedbackSource}) async {
    try {
      // Fetch the feedback documents for the given email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .where('feedbackSource', isEqualTo: feedbackSource)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the first feedback found
        return APIResponse(
          data: FeedbackModel.fromJson(querySnapshot.docs.first.data()),
          success: true
        );
      } else {
        return APIResponse(
          message: 'No feedback found for this shift',
          success: false
        );
      }
    } catch (e) {
      return APIResponse(
          message: e.toString(),
          success: false
      );
    }
  }

  static Stream<List<FeedbackModel>> streamAllFeedback() {
    return FirebaseFirestore.instance
        .collection('feedback')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeedbackModel.fromJson(doc.data()))
          .toList();
    });
  }
}
