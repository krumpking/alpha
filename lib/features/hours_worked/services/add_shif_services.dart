import 'package:alpha/core/utils/api_response.dart';
import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/shift/helpers/shift_helpers.dart';
import 'package:alpha/features/hours_worked/models/hours_worked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../shift/models/shift.dart';
import '../../manage_profile/models/user_profile.dart';

class ShiftServices {
  static Future<APIResponse<void>> submitUserShift(
      {required Shift shift}) async {
    final shiftData = shift.toJson();

    try {
      // Add the shift data to Firestore
      await FirebaseFirestore.instance.collection('shifts').add(shiftData);
      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to submit user shift: ${e.toString()}');
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

  static Stream<List<Shift>> streamUpcomingShiftsByEmail(
      {required String email}) {
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

  static Stream<List<Shift>> streamPreviousShiftsByEmail(
      {required String email}) {
    final now = DateTime.now();
    final today = DateFormat('yyyy/MM/dd').format(now);

    // Return a Firestore snapshot stream for real-time updates
    return FirebaseFirestore.instance
        .collection('shifts')
        .where('staffEmail', isEqualTo: email)
        .where('day', isLessThan: today) // Past shifts
        .orderBy('day', descending: true)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Shift.fromJson(doc.data())).toList();
    });
  }

  static Future<APIResponse<void>> updateShift({
    required String shiftId,
    required Shift updatedShift,
  }) async {
    try {
      final shiftData = updatedShift.toJson();

      // Query the collection to find the document with the given shiftId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shifts')
          .where('shiftId', isEqualTo: shiftId)
          .limit(1)
          .get();

      // Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document id (docId) of the first result
        final docId = querySnapshot.docs.first.id;

        // Update the document using the docId
        await FirebaseFirestore.instance
            .collection('shifts')
            .doc(docId)
            .update(shiftData);

        return APIResponse(success: true);
      } else {
        // No document with the given shiftId was found
        return APIResponse(success: false, message: 'Shift not found');
      }
    } catch (e) {
      DevLogs.logError('Failed to update shift: $e');
      return APIResponse(
          success: false, message: 'Failed to update shift: ${e.toString()}');
    }
  }

  static Future<APIResponse<Map<String, Duration>>> getHoursWorked({
    String? staffEmail,
    required String period,
  }) async {
    try {
      final now = DateTime.now();
      DateTime startDate;

      switch (period) {
        case 'day':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'week':
          startDate = now.subtract(Duration(days: now.weekday - 1));
          break;
        case 'month':
          startDate = DateTime(now.year, now.month);
          break;
        case 'year':
          startDate = DateTime(now.year);
          break;
        default:
          throw Exception("Invalid period");
      }

      // Initialize the query
      var query = FirebaseFirestore.instance.collection('shifts')
          .where(
        'day',
        isGreaterThanOrEqualTo: DateFormat('yyyy/MM/dd').format(startDate),
      );

      // Apply the staff email filter only if it's provided
      if (staffEmail != null) {
        query = query.where('staffEmail', isEqualTo: staffEmail);
      }

      final querySnapshot = await query.get();

      // Sum the hours worked for all shifts
      Duration totalDuration = Duration.zero;

      for (var doc in querySnapshot.docs) {
        final shiftData = doc.data();
        final int hoursWorked = shiftData['hoursWorked'] ?? 0;
        totalDuration += Duration(hours: hoursWorked);
      }

      return APIResponse(success: true, data: {'total': totalDuration});
    } catch (e) {
      return APIResponse(
        success: false,
        message: 'Failed to get hours worked: ${e.toString()}',
      );
    }
  }


}
