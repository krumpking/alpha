import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/color_constants.dart';


class MyFeedbackScreen extends ConsumerWidget {
  final String userEmail;

  const MyFeedbackScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Listen to the shiftsProvider using the profileEmail
    final feedbackAsyncValue = ref.watch(ProviderUtils.feedbackProvider(userEmail));


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My feedback',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: feedbackAsyncValue.when(
          data: (feedbacks) {
            if (feedbacks.isEmpty) {
              return const Center(child: Text('No Feedback Found.'));
            }

            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Pallete.primaryColor.withOpacity(0.2))),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.person,
                      color: Pallete.primaryColor,
                    ),
                    title: Text(
                      feedback.addedBy,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      feedback.feedbackTitle,
                      style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    trailing: Text(
                      feedback.description,
                      style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                );

                //return FeedbackCard(feedback: feedback);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            DevLogs.logError(error.toString());
            return Center(
              child: Text('Error: $error'),
            );
          }),

    );
  }
}
