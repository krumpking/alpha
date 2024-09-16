import 'package:alpha/features/feedback/pages/add_feedback.dart';
import 'package:alpha/features/hours_worked/pages/add_hours_worked.dart';
import 'package:alpha/features/auth/handlers/auth_handler.dart';
import 'package:alpha/features/auth/pages/email_verification.dart';
import 'package:alpha/features/auth/pages/forgot_password.dart';
import 'package:alpha/features/home/pages/admin_home_screen.dart';
import 'package:alpha/features/home/pages/user_home_screen.dart';
import 'package:alpha/features/manage_profile/pages/manage_profile_screen.dart';
import 'package:alpha/features/shift/pages/add_user_shift.dart';
import 'package:alpha/features/statistics/pages/admin_stuff_stats.dart';
import 'package:alpha/features/welcome/pages/onboard.dart';
import 'package:alpha/features/welcome/pages/splash.dart';
import 'package:alpha/features/workers/pages/add_user.dart';
import 'package:alpha/features/workers/pages/view_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/auth/pages/email_verification_success.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/resend_reset_email_screen.dart';
import '../../features/statistics/pages/admin_shift_stats.dart';
import '../../features/shift/models/shift.dart';
import '../../features/manage_profile/models/user_profile.dart';

class RoutesHelper {
  static String welcomeScreen = '/welcome';
  static String initialScreen = "/";
  static String splashScreen = "/splash";
  static String emailVerificationScreen = "/verifyEmail";
  static String successfulVerificationScreen = "/verified";
  static String loginScreen = '/login';
  static String forgotPasswordScreen = '/forgotPassword';
  static String resendVerificationEmailScreen = '/resendVerificationEmail';
  static String adminHomeScreen = '/adminHome';
  static String userHomeScreen = '/userHome';
  static String adminStaffStatsScreen = '/adminStaffStats';
  static String adminShiftStatsScreen = '/adminShiftStats';
  static String adminAddUserScreen = '/addUser';
  static String viewUserScreen = '/viewUsers';
  static String userProfileScreen = '/profile';
  static String updateShiftScreen = '/updateShift';
  static String addShiftsScreen = '/addShift';
  static String addUserFeedbackScreen = '/addFeedback';

  static List<GetPage> routes = [
    GetPage(name: welcomeScreen, page: () => WelcomePage()),
    GetPage(name: initialScreen, page: () => const AuthHandler()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(
        name: emailVerificationScreen,
        page: () {
          final user = Get.arguments as User;

          return EmailVerificationScreen(user: user);
        }),
    GetPage(
        name: resendVerificationEmailScreen,
        page: () {
          final String email = Get.arguments as String;

          return ResendResetEmailScreen(email: email);
        }),
    GetPage(name: loginScreen, page: () => const LoginScreen()),
    GetPage(name: adminHomeScreen, page: () => const AdminHomeScreen()),
    GetPage(
        name: userProfileScreen,
        page: () {
          final String email = Get.arguments as String;

          return UserProfileScreen(profileEmail: email);
        }),
    GetPage(name: adminAddUserScreen, page: () => const AdminAddUser()),
    GetPage(
        name: updateShiftScreen,
        page: () {
          final args = Get.arguments as List;
          final UserProfile selectedUser = args[0] as UserProfile;
          final Shift shift = args[1] as Shift;

          return EditShift(selectedUser: selectedUser, shift: shift);
        }),
    GetPage(
        name: addShiftsScreen,
        page: () {
          final UserProfile selectedUser = Get.arguments as UserProfile;
          return AddUserShift(selectedUser: selectedUser);
        }),
    GetPage(name: viewUserScreen, page: () => const AdminViewUsers()),
    GetPage(name: adminStaffStatsScreen, page: () => const AdminStaffStats()),
    GetPage(name: adminShiftStatsScreen, page: () => const AdminShiftStats()),
    GetPage(name: userHomeScreen, page: () => const UserHomeScreen()),
    GetPage(
        name: successfulVerificationScreen,
        page: () => const AccountVerificationSuccessful()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(
        name: addUserFeedbackScreen,
        page: () {
          final args = Get.arguments as List;
          final UserProfile selectedUser = args[0] as UserProfile;
          final Shift shift = args[1] as Shift;

          return AddFeedbackScreen(
            selectedUser: selectedUser,
            shift: shift,
          );
        }),
  ];
}
