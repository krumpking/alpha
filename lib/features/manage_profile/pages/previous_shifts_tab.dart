import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alpha/custom_widgets/cards/shifts_card.dart';

class PreviousShiftsTab extends ConsumerWidget {
  final UserProfile selectedUser;

  const PreviousShiftsTab({super.key, required this.selectedUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the shiftsProvider using the profileEmail
    final shiftsAsyncValue = ref.watch(ProviderUtils.previousShiftsProvider(selectedUser.email!));

    return Scaffold(
      body: shiftsAsyncValue.when(
          data: (shifts) {
            if (shifts.isEmpty) {
              return const Center(child: Text('No Previous shifts.'));
            }

            return ListView.builder(
              itemCount: shifts.length,
              itemBuilder: (context, index) {
                final shift = shifts[index];
                return ShiftCard(isUpcomingShift: false, shift: shift, selectedUser: selectedUser,);
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
