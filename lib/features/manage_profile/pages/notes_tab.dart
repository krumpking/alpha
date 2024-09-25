import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../custom_widgets/cards/notes_card.dart';

class NotesTab extends ConsumerWidget {
  final UserProfile selectedUser;

  const NotesTab({super.key, required this.selectedUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the shiftsProvider using the profileEmail
    final notesState = ref.watch(ProviderUtils.notesProvider(selectedUser.email!));

    return Scaffold(
      body: notesState.when(
          data: (notes) {
            if (notes.isEmpty) {
              return const Center(child: Text('No Notes Found.'));
            }

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return NotesCard(note: note, userProfile: selectedUser,);
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
