import 'package:alpha/core/utils/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/api_response.dart';
import '../../documents/models/document.dart';
import '../../manage_profile/models/user_profile.dart';

class StaffServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a user to Firebase Firestore
  static Future<APIResponse<String?>> addStuffToFirebase({
    required UserProfile userProfile,
  }) async {
    try {
      // Query Firestore to check if a user with the same email already exists
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: userProfile.email)
          .get();

      // If a user with the same email exists, return an error
      if (querySnapshot.docs.isNotEmpty) {
        return APIResponse(
            success: false, message: 'User with the same email already exists');
      }

      // If no user with the same email, proceed with adding the user
      final userData = userProfile.toJson();
      await _firestore.collection('users').add(userData);

      // Add user to temp
      await _firestore.collection('temp_users').add({
        'email': userProfile.email,
      });

      return APIResponse(
          success: true, data: '', message: 'User added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to search staff by name
  static Future<APIResponse<List<UserProfile>>> searchStaffByName({
    required String name,
  }) async {
    try {
      // Query Firestore to find users whose names contain the search string
      final querySnapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: '$name\uf8ff')
          .get();

      // Check if any documents are found
      if (querySnapshot.docs.isNotEmpty) {
        // Map the query results to UserProfile objects
        final userList = querySnapshot.docs
            .map((doc) => UserProfile.fromJson(doc.data()))
            .toList();

        return APIResponse(
          success: true,
          data: userList,
          message: 'Users found successfully',
        );
      } else {
        return APIResponse(
          success: false,
          message: 'No users found with the given name',
        );
      }
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  static Future<APIResponse<dynamic>> fetchTempUser(
      {required String profileEmail}) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('temp_users');

      final querySnapshot =
          await usersRef.where('email', isEqualTo: profileEmail).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();

        if (userDoc.isNotEmpty) {
          // Delete the document after fetching
          for (var docSnapshot in querySnapshot.docs) {
            await usersRef.doc(docSnapshot.id).delete();
          }

          return APIResponse(
            success: true,
            data: {"email": profileEmail},
            message: 'User fetched successfully',
          );
        } else {
          DevLogs.logError(
              'PROFILE with email $profileEmail NOT FOUND: User fetching failed: Document data is null or malformed');
          return APIResponse(
            success: false,
            message: 'User fetching failed: Document data is null or malformed',
          );
        }
      } else {
        DevLogs.logError(
            'User fetching failed: No user found with the specified email');
        return APIResponse(
          success: false,
          message:
              'User fetching failed: No user found with the specified email',
        );
      }
    } catch (e) {
      DevLogs.logError('User fetching failed: ${e.toString()}');

      return APIResponse(
        success: false,
        message: 'An error occurred while fetching the user: ${e.toString()}',
      );
    }
  }

  static Future<APIResponse<UserProfile>> fetchUserProfile(
      {required String profileEmail}) async {
    try {
      final usersRef = FirebaseFirestore.instance.collection('users');

      final querySnapshot =
          await usersRef.where('email', isEqualTo: profileEmail).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first.data();

        if (userDoc.isNotEmpty) {
          final userProfile = UserProfile.fromJson(userDoc);

          DevLogs.logInfo('PROFILE with email $profileEmail FOUND');

          return APIResponse(
            success: true,
            data: userProfile,
            message: 'User fetched successfully',
          );
        } else {
          DevLogs.logError(
              'PROFILE with email $profileEmail NOT FOUND: User fetching failed: Document data is null or malformed');
          return APIResponse(
            success: false,
            message: 'User fetching failed: Document data is null or malformed',
          );
        }
      } else {
        DevLogs.logError(
            'User fetching failed: No user found with the specified email');
        return APIResponse(
          success: false,
          message:
              'User fetching failed: No user found with the specified email',
        );
      }
    } catch (e) {
      DevLogs.logError('User fetching failed: ${e.toString()}');

      return APIResponse(
        success: false,
        message: 'An error occurred while fetching the user: ${e.toString()}',
      );
    }
  }

// Method to fetch all users from Firebase Firestore
  static Stream<List<UserProfile>> streamAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .toList();
    });
  }

  // Method to count users based on posts
  static Future<APIResponse<Map<String, int>>> countUsersByRole() async {
    try {
      final usersRef = _firestore.collection('users');

      // Queries for each role
      final careSupportWorkersCount =
          (await usersRef.where('post', isEqualTo: 'Care/Support Worker').get())
              .docs
              .length;
      final socialWorkersCount =
          (await usersRef.where('post', isEqualTo: 'Social Worker').get())
              .docs
              .length;
      final nursesCount =
          (await usersRef.where('post', isEqualTo: 'Nurse').get()).docs.length;

      return APIResponse(
          success: true,
          data: {
            'Care and Support Workers': careSupportWorkersCount,
            'Social Workers': socialWorkersCount,
            'Nurses': nursesCount,
          },
          message: 'User counts retrieved successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to update an existing user's profile
  static Future<APIResponse<String>> updateUserProfile({
    required String email,
    required UserProfile updatedProfile,
  }) async {
    try {
      // Ensure the user exists by checking for their profile based on email
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return APIResponse(
            success: false, message: 'No user found with the specified email');
      }

      final docId = querySnapshot.docs.first.id;

      final updatedData = updatedProfile.toJson();

      await _firestore.collection('users').doc(docId).update(updatedData);

      // Return a success response
      return APIResponse(
          success: true,
          data: '',
          message: 'User profile updated successfully');
    } catch (e) {
      // Log the error and return a failure response with the exception message
      DevLogs.logError('UserProfile Update Error: $e');
      return APIResponse(success: false, message: 'Profile update failed: $e');
    }
  }
}
