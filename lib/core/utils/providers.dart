import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/add_user/state/stuff_provider.dart';
import '../../features/auth/state/authentication_provider.dart';
import '../../features/manage_profile/state/user_profile_provider.dart';
import '../../models/user_profile.dart';

class ProviderUtils{
  static final staffProfilePicProvider = StateProvider<String?>((ref) => null);


  static final staffProvider = StateNotifierProvider<StaffNotifier, AsyncValue<List<UserProfile>>>((ref) {
    return StaffNotifier();
  });


  static final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
    return UserNotifier();
  });


  static final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfile>>((ref) {
    return ProfileNotifier();
  });

}