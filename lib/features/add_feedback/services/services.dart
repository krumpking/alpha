import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/api_response.dart';
import '../../../global/global.dart';
import '../../../models/user_profile.dart';

class FeedbackServices {
  static Future<APIResponse<void>> submitShift({
    required User currentUser,
    required UserProfile selectedUser,
    required String description,
    required String shiftId,
    required String feedbackTitle,
    required FeedbackTag feedbackTag,
  }) async {

    try {
      await FirebaseFirestore.instance.collection('feedback').add({
        'date': Timestamp.now(),
        'added_by': currentUser.email,
        'shift_id': shiftId,
        'title': feedbackTitle,
        'description': description,
        'feedback_tag': feedbackTag,
        'user_email': selectedUser.email
      });
      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(success: false, message: 'Failed to submit feedback: ${e.toString()}');
    }
  }

  static Future<APIResponse<List<Map<String, dynamic>>>> fetchShifts() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('shifts').get();
      List<Map<String, dynamic>> shifts = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      return APIResponse(success: true, data: shifts);
    } catch (e) {
      return APIResponse(success: false, message: 'Failed to fetch shifts: ${e.toString()}');
    }
  }
}
