import 'package:alpha/core/utils/shared_pref.dart';
import 'package:alpha/features/auth/pages/login_page.dart';
import 'package:alpha/features/welcome/pages/onboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/pages/home_screen.dart';
import '../helpers/helpers.dart';
import '../state/authentication_provider.dart';

class AuthHandler extends ConsumerWidget {
  const AuthHandler({super.key});

  Future<bool> _checkOnBoardingStatus() async {
    return await CacheUtils.checkOnBoardingStatus();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _checkOnBoardingStatus(),
      builder: (context, onboardingSnapshot) {
        if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final hasSeenOnboarding = onboardingSnapshot.data ?? false;

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              final user = snapshot.data!;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(userProvider.notifier).updateUser(user);

                if (!user.emailVerified) {
                  AuthHelpers.handleEmailVerification(user: user);
                }
              });

              return const HomeScreen();
            } else {
              return hasSeenOnboarding
                  ? const LoginScreen()
                  : WelcomePage();
            }
          },
        );
      },
    );
  }
}
