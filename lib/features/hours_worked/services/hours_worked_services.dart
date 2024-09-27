import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alpha/core/utils/api_response.dart';
import '../models/hours_worked.dart';

class HoursWorkedService {
  // Add hours worked entry to Firestore
  static Future<APIResponse<void>> addHoursWorked({
    required HoursWorked hoursWorked,
  }) async {
    try {
      final hoursWorkedData = hoursWorked.toJson();

      // Add the hours worked data to Firestore
      await FirebaseFirestore.instance
          .collection('hours_worked')
          .add(hoursWorkedData);

      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to add hours worked: ${e.toString()}');
    }
  }

  // Fetch total hours worked for a specific staff member
  static Future<APIResponse<double>> getTotalHoursWorked({
    required String staffEmail,
  }) async {
    try {
      // Query Firestore for all hours worked by a staff member
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hours_worked')
          .where('staffEmail', isEqualTo: staffEmail)
          .get();

      double totalHours = 0;
      for (var doc in querySnapshot.docs) {
        final hoursWorkedData = doc.data();
        totalHours += (hoursWorkedData['hours_worked'] as num).toDouble();
      }

      return APIResponse(success: true, data: totalHours);
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to fetch total hours worked: ${e.toString()}');
    }
  }

  // Fetch a stream of all hours worked documents for a specific staff member
  static Stream<List<HoursWorked>> streamHoursWorkedByStaff({
    required String staffEmail,
  }) {
    return FirebaseFirestore.instance
        .collection('hours_worked')
        .where('staffEmail', isEqualTo: staffEmail)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => HoursWorked.fromJson(doc.data()))
          .toList();
    });
  }

  // Update an existing hours worked entry
  static Future<APIResponse<void>> updateHoursWorked({
    required String hoursWorkedId,
    required HoursWorked updatedHoursWorked,
  }) async {
    try {
      final hoursWorkedData = updatedHoursWorked.toJson();

      // Update the hours worked document in Firestore using the document ID
      await FirebaseFirestore.instance
          .collection('hours_worked')
          .doc(hoursWorkedId)
          .update(hoursWorkedData);

      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to update hours worked: ${e.toString()}');
    }
  }

  // Delete an hours worked entry
  static Future<APIResponse<void>> deleteHoursWorked({
    required String hoursWorkedId,
  }) async {
    try {
      // Delete the hours worked document from Firestore
      await FirebaseFirestore.instance
          .collection('hours_worked')
          .doc(hoursWorkedId)
          .delete();

      return APIResponse(success: true);
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to delete hours worked: ${e.toString()}');
    }
  }

  // Fetch and calculate total hours worked for all staff or individual staff by day/week/month/year
  static Future<APIResponse<Map<String, Duration>>> getHoursWorked({
    String? staffEmail,
    required String period, // "day", "week", "month", or "year"
  }) async {
    try {
      final now = DateTime.now();
      DateTime startDate;

      switch (period) {
        case 'day':
          startDate = DateTime(now.year, now.month, now.day);
          break;
        case 'week':
          startDate = now.subtract(Duration(days: now.weekday - 1)); // Start of week
          break;
        case 'month':
          startDate = DateTime(now.year, now.month); // Start of month
          break;
        case 'year':
          startDate = DateTime(now.year); // Start of year
          break;
        default:
          throw Exception("Invalid period");
      }

      // Query hours worked for the given staff or all staff if no email is provided
      var query = FirebaseFirestore.instance
          .collection('hours_worked')
          .where('dateAdded', isGreaterThanOrEqualTo: startDate);

      if (staffEmail != null) {
        query = query.where('staffEmail', isEqualTo: staffEmail);
      }

      final querySnapshot = await query.get();

      // Sum the hours worked
      Duration totalDuration = Duration.zero;

      for (var doc in querySnapshot.docs) {
        final hoursWorkedData = doc.data();
        final double hoursWorked = hoursWorkedData['hoursWorked'] as double;
        totalDuration += Duration(hours: hoursWorked.toInt(), minutes: ((hoursWorked % 1) * 60).toInt());
      }

      return APIResponse(success: true, data: {'total': totalDuration});
    } catch (e) {
      return APIResponse(
          success: false,
          message: 'Failed to get hours worked: ${e.toString()}');
    }
  }
}
