import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeeFeedback extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(ProviderUtils.feedbackProvider);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: feedState.when(
          data: (feedback) {
            if (feedback.isEmpty) {
              return const Center(
                child: Text('No feedback found.'),
              );
            }
            return ListView.builder(
              itemCount: feedback.length,
              itemBuilder: (context, index) {
                final singleFeedback = feedback[index];
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
                      singleFeedback.addedBy,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      singleFeedback.feedackTitle,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    trailing: Text(
                      singleFeedback.description,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load feedback: $error'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to retry fetching users
                    // ref
                    //     .read(ProviderUtils.feedbackProvider.notifier)
                    //     .fetchFeedback();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
