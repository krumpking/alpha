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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
           colors: [
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.white,
             Colors.blue,
             Colors.green,
           ]
        ),
      ),
      child: AnimatedSplashScreen.withScreenFunction(
        splash: LocalImageConstants.logo,
        splashIconSize: 100,
        backgroundColor: Colors.transparent,
        screenFunction: () async {

          return const AuthHandler();
        },
        splashTransition: SplashTransition.rotationTransition,
      ),
    );
  }
}

