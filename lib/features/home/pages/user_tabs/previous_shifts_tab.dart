import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/custom_widgets/cards/task_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MyPreviousShiftsTab extends ConsumerWidget {
  final User currentUser;
  final String searchTerm; // New parameter for search

  const MyPreviousShiftsTab({super.key, required this.currentUser, required this.searchTerm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the shiftsProvider using the profileEmail
    final shiftsAsyncValue = ref.watch(ProviderUtils.previousShiftsProvider(currentUser.email!));

    return Scaffold(
      body: shiftsAsyncValue.when(
        data: (shifts) {
          if (shifts.isEmpty) {
            return const Center(child: Text('No previous shifts.'));
          }

          // Filter shifts by search term (by date or title)
          final filteredShifts = shifts.where((shift) {
            final titleMatch = shift.placeName.toLowerCase().contains(searchTerm.toLowerCase());
            final dateMatch = shift.date.contains(searchTerm); // Assuming date is in String format
            return titleMatch || dateMatch;
          }).toList();

          if (filteredShifts.isEmpty) {
            return const Center(child: Text('No matching shifts found.'));
          }

          return ListView.builder(
            itemCount: filteredShifts.length,
            itemBuilder: (context, index) {
              final shift = filteredShifts[index];
              return TaskItemCard(isUpcomingShift: false, shift: shift);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          DevLogs.logError(error.toString());
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }
}
