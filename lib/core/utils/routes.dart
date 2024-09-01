import 'package:alpha/features/add_user/pages/add_user.dart';
import 'package:alpha/features/add_user/pages/view_users.dart';
import 'package:alpha/features/auth/handlers/auth_handler.dart';
import 'package:alpha/features/auth/pages/email_verification.dart';
import 'package:alpha/features/auth/pages/forgot_password.dart';
import 'package:alpha/features/home/pages/admin_home_screen.dart';
import 'package:alpha/features/home/pages/user_home_screen.dart';
import 'package:alpha/features/manage_profile/manage_profile_screen.dart';
import 'package:alpha/features/statistics/pages/admin_stuff_stats.dart';
import 'package:alpha/features/welcome/pages/onboard.dart';
import 'package:alpha/features/welcome/pages/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/auth/pages/email_verification_success.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/resend_reset_email_screen.dart';

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
  static String adminStatsScreen = '/adminStats';
  static String adminAddUserScreen = '/addUser';
  static String viewUserScreen = '/viewUsers';
  static String userProfileScreen = '/profile';


  static getWelcomeRoute (String name)=> "$welcomeScreen?name=$name";
  static getInitialRoute (String name)=> initialScreen;
  static getSplashScreenRoute (String name)=> splashScreen;
  static getEmailVerificationScreenRoute (String name)=> "$emailVerificationScreen?name=$name";
  static getSuccessfulVerificationScreenRoute (String name)=> "$successfulVerificationScreen?name=$name";
  static getLoginRoute (String name)=> "$loginScreen?name=$name";
  static getForgotPasswordRoute (String name)=> "$forgotPasswordScreen?name=$name";
  static getAdminHomeRoute (String name)=> "$adminHomeScreen?name=$name";
  static getUserHomeRoute (String name)=> "$userHomeScreen?name=$name";
  static getAdminStatsRoute (String name)=> "$adminStatsScreen?name=$name";
  static getAdminAddUserRoute (String name)=> "$adminAddUserScreen?name=$name";
  static getAdminViewUserRoute (String name)=> "$viewUserScreen?name=$name";


  static List<GetPage> routes = [
    GetPage(
        name: welcomeScreen,
        page: ()=> WelcomePage()
    ),

    GetPage(
        name: initialScreen,
        page: ()=> const AuthHandler()
    ),

    GetPage(
        name: splashScreen,
        page: ()=> const SplashScreen()
    ),


    GetPage(
        name: emailVerificationScreen,
        page: (){
          final user = Get.arguments as User;
          
          return EmailVerificationScreen(user: user);
        }
    ),

    GetPage(
        name: resendVerificationEmailScreen,
        page: (){
          final String email = Get.arguments as String;

          return ResendResetEmailScreen(email: email);
        }
    ),

    GetPage(
        name: loginScreen,
        page: ()=> const LoginScreen()
    ),


    GetPage(
        name: adminHomeScreen,
        page: ()=> const AdminHomeScreen()
    ),

    GetPage(
        name: userProfileScreen,
        page: ()=> const ProfileScreen()
    ),

    GetPage(
        name: adminAddUserScreen,
        page: ()=> const AdminAddUser()
    ),

    GetPage(
        name: viewUserScreen,
        page: ()=> const AdminViewUsers()
    ),


    GetPage(
        name: adminStatsScreen,
        page: ()=> const AdminStuffStats()
    ),


    GetPage(
        name: userHomeScreen,
        page: ()=> const UserHomeScreen()
    ),


    GetPage(
        name: successfulVerificationScreen,
        page: ()=> const AccountVerificationSuccessful()
    ),

    GetPage(
        name: forgotPasswordScreen,
        page: ()=> ForgotPasswordScreen()
    ),
  ];

}