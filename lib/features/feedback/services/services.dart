import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/api_response.dart';
import '../../../global/global.dart';
import '../../manage_profile/models/user_profile.dart';

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

  static Stream<List<FeedbackModel>> streamFeedbackByEmail(
      {required String email}) {
    // Return a Firestore snapshot stream for real-time updates
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
}
