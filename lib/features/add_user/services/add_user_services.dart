import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/api_response.dart';
import '../../../models/user_profile.dart';

class StuffServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a user to Firebase Firestore
  static Future<APIResponse<String?>> addStuffToFirebase({
    required String email,
    required String phoneNumber,
    required String selectedRole,
    required UserProfile userProfile,
  }) async {
    try {
      // Create a user data map including all fields from UserProfile
      final userData = {
        'email': email,
        'phone_number': phoneNumber,
        'role': selectedRole,
        'name': userProfile.name,
        'address': userProfile.address,
        'preferred_work_days': userProfile.preferredWorkDays?.toIso8601String(),
        'previous_employer': userProfile.previousEmployer,
        'contact_information': userProfile.contactInformation,
        'current_role': userProfile.currentRole,
        'specialisations': userProfile.specialisations,
        'profile_picture': userProfile.profilePicture,
        'document': userProfile.documentUrl,
        'document_name': userProfile.documentName,
        'document_expiry_date': userProfile.expiryDate?.toIso8601String(),
      };

      // Add user data to Firestore
      await _firestore.collection('users').add(userData);

      return APIResponse(success: true, data: '', message: 'User added successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }

  // Method to fetch all users from Firebase Firestore
  static Future<APIResponse<List<Map<String, dynamic>>>> fetchAllUsers() async {
    try {
      // Fetch all documents from the 'users' collection
      final QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('users').get();

      // Map the documents to a list of user data
      final usersData = userSnapshot.docs.map((doc) => doc.data()).toList();

      return APIResponse(success: true, data: usersData, message: 'Users retrieved successfully');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }
}

