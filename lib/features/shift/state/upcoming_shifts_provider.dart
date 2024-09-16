import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alpha/features/shift/models/shift.dart';
import '../../hours_worked/services/add_shif_services.dart';

class UpcomingShiftsNotifier extends StateNotifier<AsyncValue<List<Shift>>> {
  final String profileEmail;
  StreamSubscription<List<Shift>>? _shiftSubscription;

  UpcomingShiftsNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    streamUserUpcomingShifts(profileEmail: profileEmail);
  }

  // Stream user shifts in real-time
  void streamUserUpcomingShifts({required String profileEmail}) {
    _shiftSubscription?.cancel(); // Cancel any previous subscription

    _shiftSubscription =
        ShiftServices.streamUpcomingShiftsByEmail(email: profileEmail).listen(
      (shifts) {
        state = AsyncValue.data(shifts);
      },
      onError: (error) {
        state = AsyncValue.error(
            'Failed to fetch user shifts: $error', StackTrace.current);
      },
    );
  }

  // Cleanup: Cancel the stream subscription when no longer needed
  @override
  void dispose() {
    _shiftSubscription?.cancel();
    super.dispose();
  }
}
