import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/global/global.dart';
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

  static Future<void> saveUserRoleToCache(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  static Future<UserRole?> getUserRoleFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    String role = prefs.getString('user_role') ?? '';

    if(role == 'admin'){
      DevLogs.logInfo(role);
      return UserRole.admin;
    }else if(role == 'user'){
      DevLogs.logInfo(role);
      return UserRole.user;
    }

    return null;
  }

  static Future<void> clearUserRoleFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
  }


}