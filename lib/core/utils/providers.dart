import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/features/feedback/state/feedback_state.dart';
import 'package:alpha/features/shift/state/upcoming_shifts_provider.dart';
import 'package:alpha/models/shift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/shift/state/previous_shifts_provider.dart';
import '../../features/statistics/state/count_provider.dart';
import '../../features/workers/state/stuff_provider.dart';
import '../../features/auth/state/authentication_provider.dart';
import '../../features/manage_profile/state/user_profile_provider.dart';
import '../../models/user_profile.dart';

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

  static final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
    return UserNotifier();
  });

  static final profileProvider = StateNotifierProvider.family<ProfileNotifier,
      AsyncValue<UserProfile>, String>((ref, profileEmail) {
    return ProfileNotifier(profileEmail: profileEmail);
  });

  static final previousShiftsProvider = StateNotifierProvider.family<PreviousShiftsNotifier,
      AsyncValue<List<Shift>>, String>((ref, profileEmail) {
    return PreviousShiftsNotifier(profileEmail: profileEmail);
  });

  static final upcomingShiftsProvider = StateNotifierProvider.family<UpcomingShiftsNotifier, AsyncValue<List<Shift>>, String>((ref, profileEmail) {
    return UpcomingShiftsNotifier(profileEmail: profileEmail);
  });


  static final staffCountProvider = StateNotifierProvider<StaffCountNotifier, AsyncValue<Map<String, int>>>((ref) {
    return StaffCountNotifier();
  });

}
