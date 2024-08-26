import 'package:alpha/core/utils/shared_pref.dart';
import 'package:alpha/features/auth/pages/login_page.dart';
import 'package:alpha/features/welcome/pages/onboard.dart';
import 'package:alpha/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../sidebarx_feat/pages/main_screen.dart';
import '../helpers/helpers.dart';
import '../state/authentication_provider.dart';

class AuthHandler extends ConsumerWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: CacheUtils.checkOnBoardingStatus(),
      builder: (context, onboardingSnapshot) {
        if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hasSeenOnboarding = onboardingSnapshot.data ?? false;

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasData) {
              final user = snapshot.data!;

              return FutureBuilder<UserRole?>(
                future: AuthHelpers.getUserRole(user),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final userRole = roleSnapshot.data;

                  // Handle email verification
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    ref.read(userProvider.notifier).updateUser(user);

                    if (user.providerData.any((info) => info.providerId == 'phone')) {
                      // Phone authenticated user, handle accordingly
                      Get.snackbar(
                        'Welcome',
                        'Logged in with phone number successfully.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else if (!user.emailVerified) {
                      // Handle email verification
                      AuthHelpers.handleEmailVerification(user: user);
                    }
                  });

                  return MainScreen(selectedRole: userRole!);

                },
              );
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
