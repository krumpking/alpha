import 'package:alpha/features/shift/services/add_shif_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/api_response.dart';
import '../../../models/shift.dart';

class PreviousShiftsNotifier extends StateNotifier<AsyncValue<List<Shift>>> {
  final String profileEmail;

  PreviousShiftsNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUserPreviousShifts(profileEmail: profileEmail);
  }

  Future<void> fetchUserPreviousShifts({required String profileEmail}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      final APIResponse<List<Shift>> response = await ShiftServices.getAllPreviousShiftsByEmail(email: profileEmail);

      if (response.success) {
        // Update state with user shifts data if successful
        state = AsyncValue.data(response.data!);
      } else {
        // Update state with error message if not successful
        state = AsyncValue.error(
            response.message ?? 'Failed to fetch user shifts', StackTrace.current);
      }
    } catch (e, stackTrace) {
      // Handle unexpected errors and include stack trace
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
