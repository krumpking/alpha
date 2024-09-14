import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alpha/custom_widgets/cards/shifts_card.dart';

import '../../../custom_widgets/cards/feedbackcard.dart';

class NotesTab extends ConsumerWidget {
  final UserProfile selectedUser;

  const NotesTab({super.key, required this.selectedUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the shiftsProvider using the profileEmail
    final notessAsyncValue = ref.watch(ProviderUtils.feedbackProvider(selectedUser.email!));

    return Scaffold(
      body: notessAsyncValue.when(
          data: (feedbacks) {
            if (feedbacks.isEmpty) {
              return const Center(child: Text('No Feedback Found.'));
            }

            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                return FeedbackCard(
                  feedback: feedback
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            DevLogs.logError(error.toString());
            return Center(
              child: Text('Error: $error'),
            );
          }
      ),
    );
  }
}
