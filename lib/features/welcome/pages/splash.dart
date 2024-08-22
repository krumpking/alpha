import 'package:alpha/features/welcome/helpers/welcome_helpers.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WelcomeHelpers.checkForWelcome();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          // Background image covering the whole screen
          Image.asset(
            'assets/images/welcome_bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          // Centered logos
          Center(
            child:
                // First logo
                Image.asset(
              'assets/images/logo_white.png',
              width: 200, // Set width as needed
              height: 200, // Set height as needed
            ),
          ),
        ],
      ),
    );
  }
}
