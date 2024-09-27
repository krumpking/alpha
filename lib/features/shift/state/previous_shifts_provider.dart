import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shift.dart';
import '../services/shift_services.dart';

class PreviousShiftsNotifier extends StateNotifier<AsyncValue<List<Shift>>> {
  final String profileEmail;
  StreamSubscription<List<Shift>>? _shiftSubscription;

  PreviousShiftsNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    streamUserPreviousShifts(profileEmail: profileEmail);
  }

  // Stream user shifts in real-time
  void streamUserPreviousShifts({required String profileEmail}) {
    _shiftSubscription?.cancel(); // Cancel any previous subscription

    _shiftSubscription =
        ShiftServices.streamPreviousShiftsByEmail(email: profileEmail).listen(
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
