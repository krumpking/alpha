import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/api_response.dart';

class AddUserServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<APIResponse<String?>> addUserToFirebase({
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
}