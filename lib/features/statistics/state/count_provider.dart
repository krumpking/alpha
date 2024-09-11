import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workers/services/add_user_services.dart';

class StaffCountNotifier extends StateNotifier<AsyncValue<Map<String, int>>> {
  StaffCountNotifier() : super(const AsyncValue.loading()) {
    fetchCounts();
  }

  Future<void> fetchCounts() async {
    state = const AsyncValue.loading();

    try {
      final response = await StaffServices.countUsersByRole();

      if (response.success) {
        state = AsyncValue.data(response.data ?? {});
      } else {
        state = AsyncValue.error(response.message ?? 'Failed to fetch counts', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
