import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alpha/custom_widgets/cards/shifts_card.dart';

class UpcomingShiftsTab extends ConsumerWidget {
  final String profileEmail;

  const UpcomingShiftsTab({super.key, required this.profileEmail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the shiftsProvider using the profileEmail
    final shiftsAsyncValue = ref.watch(ProviderUtils.upcomingShiftsProvider(profileEmail));

    return Scaffold(
      body: shiftsAsyncValue.when(
        data: (shifts) {
          if (shifts.isEmpty) {
            return const Center(child: Text('No upcoming shifts.'));
          }

          return ListView.builder(
            itemCount: shifts.length,
            itemBuilder: (context, index) {
              final shift = shifts[index];
              return ShiftCard(shift: shift);
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
