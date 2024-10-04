import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/features/feedback/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackNotifier extends StateNotifier<AsyncValue<List<FeedbackModel>>> {
  final String profileEmail;

  FeedbackNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchFeedbacks(profileEmail: profileEmail);
  }

  // Fetch user feedbacks using a one-time get request
  void fetchFeedbacks({required String profileEmail}) async {
    try {
      // Fetch feedback using email
      final feedbackResponse = await FeedbackServices.getFeedbackByEmail(email: profileEmail);
      if (feedbackResponse.success) {
        state = AsyncValue.data(feedbackResponse.data!);
      } else {
        state = AsyncValue.error(feedbackResponse.message ?? 'Something went wrong', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
