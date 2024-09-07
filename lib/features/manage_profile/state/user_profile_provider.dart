import 'package:alpha/features/workers/services/add_user_services.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/api_response.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  final String profileEmail;

  ProfileNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUser(profileEmail: profileEmail);
  }

  Future<void> fetchUser({required String profileEmail}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Fetch user profile from the service
      final APIResponse<UserProfile> response =
          await StaffServices.fetchUserProfile(profileEmail: profileEmail);

      if (response.success) {
        // Update state with user data if successful
        state = AsyncValue.data(response.data!);
      } else {
        // Update state with error message if not successful
        state = AsyncValue.error(
            response.message ?? 'Failed to fetch user', StackTrace.current);
      }
    } catch (e, stackTrace) {
      // Handle unexpected errors and include stack trace
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
