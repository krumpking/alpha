import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/add_user_services.dart';

class StaffNotifier extends StateNotifier<AsyncValue<List<UserProfile>>> {
  StaffNotifier() : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  // Fetch users using a one-time get request
  void fetchUsers() async {
    try {
      // Fetch all users from Firestore
      final usersResponse = await StaffServices.getAllUsers();
      if (usersResponse.success) {
        state = AsyncValue.data(usersResponse.data!);
      } else {
        state = AsyncValue.error(usersResponse.message ?? 'Something went wrong', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
