import 'package:alpha/core/constants/route_constants.dart';
import 'package:get/get.dart';

import '../../../core/constants/shared_pref_constants.dart';
import '../../../core/utils/shared_pref.dart';

class WelcomeHelpers {
  static Future<void> checkForWelcome() async {
    await Future.delayed(const Duration(seconds: 3));

    bool hasSeenWelcome = await getSPBoolean(opened);
    if (hasSeenWelcome) {
      Get.toNamed(RoutesHelper.loginScreen);
    } else {
      saveBool(opened, true);
      // Navigate to welcome screen
      Get.toNamed(RoutesHelper.loginScreen);
    }
  }

}