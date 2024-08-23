import 'package:shared_preferences/shared_preferences.dart';


class CacheUtils{
  static Future<bool> checkOnBoardingStatus() async {

    bool hasSeenOnboarding;

    const key = 'hasSeenOnboarding';
    final prefs = await SharedPreferences.getInstance();
   hasSeenOnboarding = prefs.getBool(key) ?? false;


    return hasSeenOnboarding;
  }

  static Future<bool> updateOnboardingStatus(bool status) async {
    bool hasSeenOnboarding = status;

    const key = 'hasSeenOnboarding';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, status);
    hasSeenOnboarding = await checkOnBoardingStatus();

    return hasSeenOnboarding;
  }


}