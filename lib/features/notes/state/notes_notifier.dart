import 'package:alpha/features/notes/services/notes_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final String profileEmail;

  NotesNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchNotes(profileEmail: profileEmail);
  }

  // Fetch notes using a one-time get request
  void fetchNotes({required String profileEmail}) async {
    try {
      // Fetch notes using email
      final notesResponse = await NotesServices.getNotesByEmail(email: profileEmail);
      if (notesResponse.success) {
        state = AsyncValue.data(notesResponse.data!);
      } else {
        state = AsyncValue.error(notesResponse.message ?? 'Something went wrong', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }
}
