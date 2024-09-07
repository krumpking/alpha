import 'package:alpha/features/feedback/services/services.dart';
import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/api_response.dart';

class FeedbackNotifier extends StateNotifier<AsyncValue<List<FeedbackModel>>> {
  FeedbackNotifier() : super(const AsyncValue.loading()) {
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String email = user.email ?? 'anelesiwawa';
// Fetch users from the service
        final APIResponse<List<FeedbackModel>> response =
            await FeedbackServices.fetchAllFeedback(email);

        if (response.success) {
          // Update state with user data if successful
          state = AsyncValue.data(response.data ?? []);
        } else {
          // Update state with error message and stack trace if not successful
          state = AsyncValue.error(
              response.message ?? 'Failed to fetch users', StackTrace.current);
        }
      }
    } catch (e, stackTrace) {
      // Handle unexpected errors and include stack trace
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
