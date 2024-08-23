import 'package:alpha/core/constants/local_image_constants.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import '../../auth/handlers/auth_handler.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: LocalImageAsset.logo,
      splashIconSize: 100,
      screenFunction: () async {

        return const AuthHandler();
      },
      splashTransition: SplashTransition.rotationTransition,
    );
  }
}

