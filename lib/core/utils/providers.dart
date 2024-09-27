import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/features/feedback/state/feedback_state.dart';
import 'package:alpha/features/notes/state/notes_notifier.dart';
import 'package:alpha/features/shift/state/upcoming_shifts_provider.dart';
import 'package:alpha/features/shift/models/shift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import '../../features/home/state/document_expiry_notifier.dart';
import '../../features/home/state/search_notifier.dart';
import '../../features/documents/models/document.dart';
import '../../features/hours_worked/services/hours_worked_services.dart';
import '../../features/notes/models/note.dart';
import '../../features/shift/services/shift_services.dart';
import '../../features/shift/state/previous_shifts_provider.dart';
import '../../features/statistics/state/count_provider.dart';
import '../../features/workers/state/stuff_provider.dart';
import '../../features/auth/state/authentication_provider.dart';
import '../../features/manage_profile/state/user_profile_provider.dart';
import '../../features/manage_profile/models/user_profile.dart';
import '../../global/global.dart';

class ProviderUtils {
  static final staffProfilePicProvider = StateProvider<String?>((ref) => null);

  static final staffProvider =
      StateNotifierProvider<StaffNotifier, AsyncValue<List<UserProfile>>>(
          (ref) {
    return StaffNotifier();
  });

  static final feedbackProvider = StateNotifierProvider.family<FeedbackNotifier,
      AsyncValue<List<FeedbackModel>>, String>((ref, profileEmail) {
    return FeedbackNotifier(profileEmail: profileEmail);
  });

  static final notesProvider = StateNotifierProvider.family<NotesNotifier,
      AsyncValue<List<Note>>, String>((ref, profileEmail) {
    return NotesNotifier(profileEmail: profileEmail);
  });

  static final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
    return UserNotifier();
  });

  static final profileProvider = StateNotifierProvider.family<ProfileNotifier,
      AsyncValue<UserProfile>, String>((ref, profileEmail) {
    return ProfileNotifier(profileEmail: profileEmail);
  });

  static final previousShiftsProvider = StateNotifierProvider.family<
      PreviousShiftsNotifier,
      AsyncValue<List<Shift>>,
      String>((ref, profileEmail) {
    return PreviousShiftsNotifier(profileEmail: profileEmail);
  });

  static final upcomingShiftsProvider = StateNotifierProvider.family<
      UpcomingShiftsNotifier,
      AsyncValue<List<Shift>>,
      String>((ref, profileEmail) {
    return UpcomingShiftsNotifier(profileEmail: profileEmail);
  });

  static final staffCountProvider =
      StateNotifierProvider<StaffCountNotifier, AsyncValue<Map<String, int>>>(
          (ref) {
    return StaffCountNotifier();
  });

  static final searchProvider = StateNotifierProvider<SearchStaffNotifier, List<UserProfile>>((ref) {
    return SearchStaffNotifier();
  });

  static final hoursWorkedProvider = FutureProvider.family<Map<String, Duration>, Tuple2<String, String?>>((ref, params) async {
    final period = params.item1;
    final email = params.item2;


    final response = await HoursWorkedService.getHoursWorked(period: period, staffEmail: email);

    if (response.success) {
      return response.data!;
    } else {
      throw Exception(response.message);
    }
  });

  static final expiringDocumentsProvider = StateNotifierProvider<ExpiringDocumentsNotifier, List<Document>>((ref) {
    return ExpiringDocumentsNotifier();
  });


  static final userRoleProvider = StateProvider<UserRole?>((ref) {
    return null;
  });
}
