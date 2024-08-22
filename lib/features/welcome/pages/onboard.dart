// Create a simple stateless widget that displays a welcome message.
import 'package:alpha/core/constants/route_constants.dart';
import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final List<SingleIntroScreen> pages = [
    const SingleIntroScreen(
      sideDotsBgColor: Colors.green,
      title: 'Farmerz Tool',
      description: 'All you want ',
      imageAsset: 'assets/images/farmer_one.png',
      imageHeightMultiple: 10.0,
    ),
    const SingleIntroScreen(
      sideDotsBgColor: Colors.green,
      title: 'Farmerz Tool',
      description: 'All you want ',
      imageAsset: 'assets/images/farmer_two.png',
      imageHeightMultiple: 10.0,
    ),
    const SingleIntroScreen(
      sideDotsBgColor: Colors.green,
      title: 'Farmerz Tool',
      description: 'All you want ',
      imageAsset: 'assets/images/farmer_three.png',
      imageHeightMultiple: 10.0,
    ),
    const SingleIntroScreen(
      title: 'Farmerz Tool',
      sideDotsBgColor: Colors.green,
      description: 'All you want ',
      imageAsset: 'assets/images/farmer_four.png',
      imageHeightMultiple: 10.0,
    ),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
      footerBgColor: Colors.green,
      isFullScreen: true,
      slides: pages,
      indicatorType: IndicatorType.circle,
      onDone: () {
        Navigator.of(context).pushNamed(loginRoute);
      },
    );
  }
}
