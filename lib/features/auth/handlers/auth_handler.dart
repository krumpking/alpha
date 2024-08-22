import 'package:alpha/features/auth/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/pages/home_screen.dart';
import '../helpers/helpers.dart';
import '../state/authentication_provider.dart';

class AuthHandler extends ConsumerWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            ref.read(userProvider.notifier).updateUser(user);
            if (!user.emailVerified) {
              AuthHelpers.handleEmailVerification(
                user: user
              );
            }
          });

          return HomeScreen();

        }else{
          return const LoginScreen();
        }
      },
    );
  }
}
