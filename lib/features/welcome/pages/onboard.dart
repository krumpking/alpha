import 'package:alpha/core/utils/shared_pref.dart';
import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/routes.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({super.key});

  final List<SingleIntroScreen> pages = [
    const SingleIntroScreen(
      sideDotsBgColor: Colors.green,
      title: 'Alpha',
      description: 'All you want ',
      imageAsset: 'assets/images/add_user.png',
      imageHeightMultiple: 10.0,
    ),
    const SingleIntroScreen(
      sideDotsBgColor: Colors.green,
      title: 'Alpha Staffing',
      description: 'All you want ',
      imageAsset: 'assets/images/add_user.png',
      imageHeightMultiple: 10.0,
    ),
    const SingleIntroScreen(
      sideDotsBgColor: Colors.green,
      title: 'Alpha',
      description: 'All you want ',
      imageAsset: 'assets/images/add_user.png',
      imageHeightMultiple: 10.0,
    ),
    const SingleIntroScreen(
      title: 'Alpha',
      sideDotsBgColor: Colors.green,
      description: 'All you want ',
      imageAsset: 'assets/images/add_user.png',
      imageHeightMultiple: 10.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
        footerBgColor: Colors.green,
        isFullScreen: true,
        slides: pages,
        indicatorType: IndicatorType.circle,
        onDone: () async {
          await CacheUtils.updateOnboardingStatus(true).then((value) {
            Get.offAllNamed(RoutesHelper.loginScreen);
          });
        });
  }
}
