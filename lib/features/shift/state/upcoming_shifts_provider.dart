import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alpha/features/shift/models/shift.dart';
import '../services/shift_services.dart';

class UpcomingShiftsNotifier extends StateNotifier<AsyncValue<List<Shift>>> {
  final String profileEmail;

  UpcomingShiftsNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUserUpcomingShifts(profileEmail: profileEmail);
  }

  // Fetch upcoming shifts using a one-time get request
  void fetchUserUpcomingShifts({required String profileEmail}) async {
    try {
      final shiftsResponse = await ShiftServices.getUpcomingShiftsByEmail(email: profileEmail);
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
