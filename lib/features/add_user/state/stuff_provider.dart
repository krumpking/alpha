
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/api_response.dart';
import '../services/add_user_services.dart';

// Define a provider for the list of users
final stuffProvider = StateNotifierProvider<StuffNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  return StuffNotifier();
});

class StuffNotifier extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  StuffNotifier() : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Fetch users from the service
      final APIResponse<List<Map<String, dynamic>>> response = await StuffServices.fetchAllUsers();

      if (response.success) {
        // Update state with user data if successful
        state = AsyncValue.data(response.data ?? []);
      } else {
        // Update state with error message and stack trace if not successful
        state = AsyncValue.error(response.message ?? 'Failed to fetch users', StackTrace.current);
      }
    } catch (e, stackTrace) {
      // Handle unexpected errors and include stack trace
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
