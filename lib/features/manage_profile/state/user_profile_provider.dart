import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/features/workers/services/add_user_services.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/api_response.dart';
import '../../documents/models/document.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  final String profileEmail;

  ProfileNotifier({required this.profileEmail})
      : super(const AsyncValue.loading()) {
    fetchUser(profileEmail: profileEmail);
  }

  Future<void> fetchUser({required String profileEmail}) async {
    // Set loading state
    state = const AsyncValue.loading();

    try {
      // Fetch user profile from the service
      final APIResponse<UserProfile> response = await StaffServices.fetchUserProfile(profileEmail: profileEmail);

      if (response.success) {
        state = AsyncValue.data(response.data!);
      } else {
        state = AsyncValue.error(
            response.message ?? 'Failed to fetch user', StackTrace.current
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
    }
  }

  // Update the state with a new profile
  void updateProfile(UserProfile updatedProfile) {
    state = AsyncValue.data(updatedProfile);
  }

  // Update the profile picture
  Future<void> updateProfilePicture(String newProfilePictureUrl) async {
    final currentProfile = state.value;

    if (currentProfile == null) return;

    // Create an updated profile with the new profile picture URL
    final updatedProfile = currentProfile.copyWith(profilePicture: newProfilePictureUrl);

    // Update the state with the new profile
    state = AsyncValue.data(updatedProfile);

    // If you have a method to update the profile in the backend, call it here
    final response = await StaffServices.updateUserProfile(
      email: currentProfile.email!,
      updatedProfile: updatedProfile,
    );

    if (!response.success) {
      // Handle the error if the backend update fails
      state = AsyncValue.error(response.message ?? 'Failed to update profile picture', StackTrace.current);
    }
  }

  // Handle document deletion
  Future<void> deleteDocument(Document document) async {
    final currentProfile = state.value;

    if (currentProfile == null) return;

    final updatedDocuments = currentProfile.documents
        .where((doc) => doc.docID != document.docID)
        .toList();

    final updatedProfile = currentProfile.copyWith(documents: updatedDocuments);

    state = AsyncValue.data(updatedProfile);
  }

  // Handle document addition
  Future<void> addDocument(Document newDocument) async {
    final currentProfile = state.value;

    if (currentProfile == null) return;

    final updatedDocuments = [...currentProfile.documents, newDocument];
    final updatedProfile = currentProfile.copyWith(documents: updatedDocuments);

    state = AsyncValue.data(updatedProfile);
  }

  // Handle document update
  Future<void> updateDocument(Document updatedDocument) async {
    final currentProfile = state.value;

    if (currentProfile == null) return;

    // Update the specific document in the documents list
    final updatedDocuments = currentProfile.documents.map((doc) {
      return doc.docID == updatedDocument.docID ? updatedDocument : doc;
    }).toList();

    // Create an updated profile with the modified document list
    final updatedProfile = currentProfile.copyWith(documents: updatedDocuments);

    // Update the state with the new profile
    state = AsyncValue.data(updatedProfile);
  }
}
