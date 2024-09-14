import 'package:alpha/core/utils/api_response.dart';
import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/shift/models/hours_worked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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


  static Future<Shift?> getNextUserShiftByEmail({required String email}) async {
    try {
      final now = DateTime.now();
      final today = DateFormat('yyyy/MM/dd').format(now);

      // Query the shifts collection for shifts with the given email and not completed
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shifts')
          .where('staffEmail', isEqualTo: email)
          .where('done', isEqualTo: false)
      // Order by staffEmail first (assuming it has an index)
          .orderBy('staffEmail', descending: false)
      // Limit the results to documents where day is greater than or equal to today
          .where('day', isGreaterThanOrEqualTo: today)
      // Order by remaining fields (assuming indexes exist)
          .orderBy('startTime', descending: false)
          .limit(1) // Limit to only retrieve the first document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first shift that is closest to today
        for (var doc in querySnapshot.docs) {
          final shiftData = doc.data();
          final shiftDate = shiftData['day'] as String;

          if (shiftDate.compareTo(today) >= 0) {
            final nextShift = Shift.fromJson(shiftData);
            if (shiftDate == today) {
              nextShift.notes = 'Today\'s shift';
            }
            return nextShift;
          }
        }
      }
      return null;
    } catch (e) {
      DevLogs.logError('Failed to get next user shift: $e');
      return null;
    }
  }



  static Stream<List<Shift>> streamUpcomingShiftsByEmail({required String email}) {
    final now = DateTime.now();
    final today = DateFormat('yyyy/MM/dd').format(now);

    // Return a Firestore snapshot stream for real-time updates
    return FirebaseFirestore.instance
        .collection('shifts')
        .where('staffEmail', isEqualTo: email)
        .where('done', isEqualTo: false) // Not completed
        .where('day', isGreaterThanOrEqualTo: today) // Future or today’s shifts
        .orderBy('day', descending: false)
        .orderBy('startTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Shift.fromJson(doc.data())).toList();
    });
  }



  static Future<APIResponse<List<Shift>>> getAllPreviousShiftsByEmail({required String email}) async {
    try {
      final now = DateTime.now();
      final today = DateFormat('yyyy/MM/dd').format(now);

      // Query the shifts collection for previous shifts
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shifts')
          .where('staffEmail', isEqualTo: email)
          .where('day', isLessThan: today) // Past shifts
          .orderBy('day', descending: true)
          .orderBy('startTime', descending: true)
          .get();

      // Convert query results to a list of Shift objects
      final previousShifts = querySnapshot.docs.map((doc) {
        return Shift.fromJson(doc.data());
      }).toList();

      return APIResponse(data:  previousShifts, success: true);
    } catch (e) {
      DevLogs.logError('Failed to get previous shifts: $e');
      return APIResponse(success: false, message: 'Failed to get previous shifts' );
    }
  }



  static Future<APIResponse<void>> submitShiftsDone({
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
}
