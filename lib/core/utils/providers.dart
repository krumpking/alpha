import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/features/feedback/state/feedback_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  static final feedbackProvider =
      StateNotifierProvider<FeedbackNotifier, AsyncValue<List<FeedbackModel>>>(
          (ref) {
    return FeedbackNotifier();
  });

  static final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
    return UserNotifier();
  });

  static final profileProvider = StateNotifierProvider.family<ProfileNotifier,
      AsyncValue<UserProfile>, String>((ref, profileEmail) {
    return ProfileNotifier(profileEmail: profileEmail);
  });
}
