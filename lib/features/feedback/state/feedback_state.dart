import 'dart:async';
import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/features/feedback/services/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class FeedbackNotifier extends StateNotifier<AsyncValue<List<FeedbackModel>>> {
  final String profileEmail;
  StreamSubscription<List<FeedbackModel>>? _feedbackSubscription;

  FeedbackNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    streamFeedbacks(profileEmail: profileEmail);
  }

  // Stream user shifts in real-time
  void streamFeedbacks({required String profileEmail}) {
    _feedbackSubscription?.cancel();

    _feedbackSubscription =
        FeedbackServices.streamFeedbackByEmail(email: profileEmail).listen(
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
    _feedbackSubscription?.cancel();
    super.dispose();
  }
}