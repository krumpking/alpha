import 'package:alpha/core/utils/api_response.dart';
import 'package:alpha/features/shift/models/hours_worked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/shift.dart';
import '../../../models/user_profile.dart';

class ShiftServices {

  static Future<APIResponse<void>> submitUserShift({
    required Shift shift
  }) async {
    final shiftData = shift.toJson();

    try {
      // Add the shift data to Firestore
      await FirebaseFirestore.instance.collection('shifts').add(shiftData);
      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false, message: 'Failed to submit user shift: ${e.toString()}');
    }
  }

  static Future<APIResponse<void>> submitShift({
    required User currentUser,
    required UserProfile selectedUser,
    required bool isCompleted,
    required int hoursCompleted,
    required String documentName,
    required String documentUrl,
  }) async {
    var hoursWroked = HoursWorked(
      dateAdded: DateTime.now().toString(),
      addedBy: currentUser.email!,
      hoursCompleted: hoursCompleted.toDouble(),
      documentName: documentName,
      isCompleted: isCompleted,
      assignedUser: selectedUser.email!,
      documentUrl: documentUrl,
    );
    try {
      await FirebaseFirestore.instance
          .collection('shifts')
          .add(hoursWroked.toJson());
      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false, message: 'Failed to submit shift: ${e.toString()}');
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
}
