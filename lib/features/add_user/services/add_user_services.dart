import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/api_response.dart';

class StuffServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<String?>> addStuffToFirebase({
    required String email,
    required String phoneNumber,
    required String selectedRole,
  }) async {
    try {
      await _firestore.collection('users').add({
        'email': email,
        'phone_number': phoneNumber,
        'role': selectedRole,
      });

      return APIResponse(success: true, data: '', message: 'Role fetched successful');
    } catch (e) {
      return APIResponse(success: false, message: e.toString());
    }
  }


  static Future<APIResponse<List<Map<String, dynamic>>>> fetchAllUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> userSnapshot = await _firestore.collection('users').get();
      return APIResponse(success: true, data: userSnapshot.docs.map((doc) => doc.data()).toList(), message: 'Stuff retrieved Successfully');
    } catch (e) {
      throw Exception('Failed to fetch users');
    }
  }
}