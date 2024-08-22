import 'package:alpha/core/constants/route_constants.dart';
import 'package:alpha/core/constants/shared_pref_constants.dart';
import 'package:alpha/core/utils/shared_pref.dart';
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

    _checkForWelcome(context);
  }

  Future<void> _checkForWelcome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    bool hasSeenWelcome = await getSPBoolean(opened);
    if (hasSeenWelcome) {
      Navigator.of(context).pushNamed(loginRoute);
    } else {
      saveBool(opened, true);
      // Navigate to welcome screen
      Navigator.of(context).pushNamed(welcomeRoute);
    }
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
