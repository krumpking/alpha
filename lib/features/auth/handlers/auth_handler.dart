import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../custom_widgets/circular_loader/circular_loader.dart';
import '../state/authentication_provider.dart';

class AuthHandler extends ConsumerWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CustomLoader(
                  message: 'Please wait'
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ref.read(userProvider.notifier).updateUser(user);
            if (!user.emailVerified) {
              AuthHelpers.handleEmailVerification(context, user);
            }
          });

          return AuthHelpers.getSelectedUserRole();
        } else {
          return userRole != null
              ? (hasSeenOnboarding! == true
              ? const Login()
              : SelectedRoleOnLanding(selectedRole: userRole!))
              : (isStarted!
              ? AuthHelpers.getSelectedUserRole()
              : const MajorOnLandingPage());
        }
      },
    );
  }
}
