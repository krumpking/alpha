import 'package:alpha/core/utils/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/utils/api_response.dart';
import '../../../models/user_profile.dart';

class StaffServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a user to Firebase Firestore
  static Future<APIResponse<String?>> addStuffToFirebase({
    required UserProfile userProfile,
  }) async {
    try {

      final userData = userProfile.toJson();
      // Add user data to Firestore
      await _firestore.collection('users').add(userData);

      return APIResponse(success: true, data: '', message: 'User added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  static Future<APIResponse<UserProfile>> fetchUserProfile({required String profileEmail}) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    // Query the collection to find a user document with the specified email
    final querySnapshot = await usersRef.where('email', isEqualTo: profileEmail).get();

    // Check if any documents are found
    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document found (assuming email is unique)
      final userDoc = querySnapshot.docs.first.data();

      final userProfile = UserProfile.fromJson(userDoc);

      return APIResponse(success: true, data: userProfile, message: 'User fetched successfully');
    } else {
      return APIResponse(success: false, message: 'User fetching failed: no user found with the specified email');
    }
  }


// Method to fetch all users from Firebase Firestore
  static Future<APIResponse<List<UserProfile>>> fetchAllUsers() async {
    try {
      // Fetch all documents from the 'users' collection
      final QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('users').get();

      // Map the documents to a list of UserProfile objects
      final List<UserProfile> users = userSnapshot.docs
          .map((doc) => UserProfile.fromJson(doc.data()))
          .toList();

      return APIResponse(success: true, data: users, message: 'Users retrieved successfully');
    } catch (e) {
      DevLogs.logError(e.toString());
      return APIResponse(success: false, message: e.toString());
    }
  }


  // Method to count users based on posts
  static Future<APIResponse<Map<String, int>>> countUsersByRole() async {
    try {
      final usersRef = _firestore.collection('users');

      // Queries for each role
      final careSupportWorkersCount = (await usersRef.where(
          'post', isEqualTo: 'Care/Support Worker').get()).docs.length;
      final socialWorkersCount = (await usersRef.where(
          'post', isEqualTo: 'Social Worker').get()).docs.length;
      final nursesCount = (await usersRef.where('post', isEqualTo: 'Nurse')
          .get()).docs.length;

      return APIResponse(success: true, data: {
        'Care and Support Workers': careSupportWorkersCount,
        'Social Workers': socialWorkersCount,
        'Nurses': nursesCount,
      }, message: 'User counts retrieved successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}

