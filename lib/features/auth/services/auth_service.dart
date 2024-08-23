import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/utils/api_response.dart';

class AuthServices {

  // Sign up with email and password, with email verification
  static Future<APIResponse<String?>> signUpWithVerification({
    String? profilePic,
    required String emailAddress,
    required String password,
    required String userName,

  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      await userCredential.user!.updateDisplayName(userName);

      final String? userToken = await userCredential.user!.getIdToken();

      return APIResponse(
          success: true,
          data: userToken,
          message: 'Signup successful. Please verify your email.'
      );

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return APIResponse(success: false, message: 'Email Address already in use');
        case 'weak-password':
          return APIResponse(success: false, message: 'Your password is too weak');
        default:
          return APIResponse(success: false, message: 'Unknown error, please contact Support');
      }
    } catch (e) {
      return APIResponse(success: false, message: 'An error occurred. Please try again.');
    }
  }

  // Login with email and password
  static Future<APIResponse<User?>> login({
    required String emailAddress,
    required String password,
  }) async {
    try {
      final UserCredential loginResponse = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);

      if (loginResponse.user != null) {
        return APIResponse(success: true, data: loginResponse.user, message: 'Login successful');
      } else {
        return APIResponse(success: false, message: 'Failed to login. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return APIResponse(success: false, message: 'Invalid email address format.');
        case 'user-disabled':
          return APIResponse(success: false, message: 'User account is disabled.');
        case 'user-not-found':
          return APIResponse(success: false, message: 'No user found for that email.');
        case 'wrong-password':
          return APIResponse(success: false, message: 'Incorrect password.');
        default:
          return APIResponse(success: false, message: e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      return APIResponse(success: false, message: 'An error occurred. Please try again.');
    }
  }

  // Sign out user
  static Future<APIResponse<void>> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return APIResponse(success: true, message: 'Sign out successful');
    } catch (e) {
      return APIResponse(success: false, message: 'Failed to sign out. Please try again.');
    }
  }

  // Send password reset email
  static Future<APIResponse<void>> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return APIResponse(success: true, message: 'Password reset email sent.');
    } catch (e) {
      return APIResponse(success: false, message: 'Failed to send password reset email. Please try again.');
    }
  }

  // Future<void> saveUserToFirestore(User user, String role) async {
  //   final usersRef = FirebaseFirestore.instance.collection('users');
  //
  //   await usersRef.doc(user.uid).set({
  //     'uid': user.uid,
  //     'email': user.email,
  //     'role': role,
  //     'displayName': user.displayName,
  //     'photoURL': user.photoURL,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  // }

  static Future<APIResponse<String?>> fetchUserRole(String uid) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final userDoc = await usersRef.doc(uid).get();

    if (userDoc.exists) {
      return APIResponse(success: true, data: userDoc.data()?['role'], message: 'Role fetched successful');
    }else{
      return APIResponse(success: false, message: 'Role fetching failed');
    }
  }

}

// Custom AuthException class for better error handling
class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
