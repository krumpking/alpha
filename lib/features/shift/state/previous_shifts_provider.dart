import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shift.dart';
import '../services/shift_services.dart';

class PreviousShiftsNotifier extends StateNotifier<AsyncValue<List<Shift>>> {
  final String profileEmail;

  PreviousShiftsNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUserPreviousShifts(profileEmail: profileEmail);
  }

  // Fetch previous shifts using a one-time get request
  void fetchUserPreviousShifts({required String profileEmail}) async {
    try {
      // Fetch shifts using the email
      final shiftsResponse = await ShiftServices.getPreviousShiftsByEmail(email: profileEmail);
      if (shiftsResponse.success) {
        state = AsyncValue.data(shiftsResponse.data!);
      } else {
        state = AsyncValue.error(shiftsResponse.message ?? 'Something went wrong', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
