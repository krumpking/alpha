import 'dart:async';

import 'package:alpha/core/constants/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:logger/logger.dart';

import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../services/auth_service.dart';

class AuthHelpers {

  static final Logger _logger = Logger();

  static Future<void> handleEmailVerification({required User user}) async {
    if (!user.emailVerified) {
      Get.offAllNamed(
        RoutesHelper.emailVerificationScreen,
        arguments: user
      );
    } else {
      Get.offAllNamed(RoutesHelper.initialScreen);
    }
  }

  static Future<void> checkEmailVerification({required User currentUser}) async {
    await currentUser.reload().then((value){
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified ?? false) {
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });

  }

  static setTimerForAutoRedirect() {
    const Duration timerPeriod = Duration(seconds: 5);
    Timer.periodic(
      timerPeriod,
          (timer) async {
        await FirebaseAuth.instance.currentUser?.reload().then((value){
          final user = FirebaseAuth.instance.currentUser;

          if (user?.emailVerified ?? false) {

            timer.cancel();

            Get.offAllNamed(RoutesHelper.successfulVerificationScreen);
          }
        });

      },
    );
  }

  static Future<String?> getCurrentUserToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        return token;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting user token: $e');
      return null;
    }
  }

  static void validateAndSubmitForm({
    required String password,
    required String email,
  }) async {
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Password is required.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        'Error',
        'Password is too short.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Error',
        'Please input a valid email.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    Get.dialog(
      const CustomLoader(
        message: 'Logging in',
      ),
      barrierDismissible: false,
    );

    await AuthServices.login(
      emailAddress: email.trim(),
      password: password.trim(),
    ).then((response){
      if (!response.success) {
        if (!Get.isSnackbarOpen) Get.back();
        Get.snackbar(
          'Error',
          response.message ?? 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        if (Get.isDialogOpen!) Get.back();
        Get.offAllNamed(RoutesHelper.initialScreen);
      }
    });
  }

}


