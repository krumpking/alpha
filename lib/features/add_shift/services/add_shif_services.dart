import 'package:alpha/core/utils/api_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_profile.dart';

class ShiftServices {
  static Future<APIResponse<void>> submitShift({
    required User currentUser,
    required UserProfile selectedUser,
    required bool isCompleted,
    required int hoursCompleted,
    required String documentName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('shifts').add({
        'date_added': Timestamp.now(),
        'added_by': currentUser.email,
        'hours_completed': hoursCompleted,
        'document_name': documentName,
        'is_completed': isCompleted,
        'assigned_user': selectedUser.email,
      });
      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(success: false, message: 'Failed to submit shift: ${e.toString()}');
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
