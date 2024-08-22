
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class AuthHelpers {

  static final Logger _logger = Logger();

  static Future<void> handleEmailVerification({required User user}) async {
    if (!user.emailVerified) {
      GeneralHelpers.permanentNavigator(context, EmailVerificationScreen(user: user));
    } else {
      GeneralHelpers.permanentNavigator(context, const AuthHandler());
    }
  }

  static Future<void> checkEmailVerification({required BuildContext context, required User currentUser}) async {
    await currentUser.reload().then((value){
      final user = FirebaseAuth.instance.currentUser;

      if (user?.emailVerified ?? false) {
        GeneralHelpers.permanentNavigator(context, const AuthHandler());
      }
    });

  }

  static setTimerForAutoRedirect(BuildContext context) {
    const Duration timerPeriod = Duration(seconds: 5); // Change the timer period as needed
    Timer.periodic(
      timerPeriod,
          (timer) async {
        await FirebaseAuth.instance.currentUser?.reload().then((value){
          final user = FirebaseAuth.instance.currentUser;

          if (user?.emailVerified ?? false) {

            timer.cancel(); // Stop the timer once verification is successful

            GeneralHelpers.permanentNavigator(
                context,
                const AccountVerificationSuccessful()
            );
          }
        });

      },
    );
  }

  static Future<String?> getCurrentUserToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        return token;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting user token: $e');
      return null;
    }
  }

  static Future<UserProfile?> fetchProfileDataAndCache({required BuildContext context, required bool wannaNavigate}) async {
    UserProfileProvider userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    UserProfile? userProfileData = userProfileProvider.userProfile;

    if (userProfileData == null) {
      final user = FirebaseAuth.instance.currentUser;

      final userStoredProfile = await UserProfileServices.fetchUserProfileInformation(user!.uid);
      if (userStoredProfile != null) {
        userProfileProvider.setUserProfile(userStoredProfile);
        await SharedPreferencesHelper.saveUserProfileToCache(userStoredProfile).then((_){
          if(wannaNavigate == true){
            GeneralHelpers.back(context);
            GeneralHelpers.permanentNavigator(context, const AuthHandler());
          }
        });
      }
    }

    return userProfileData;
  }


  static Widget getSelectedUserRole() {
    switch (userRole) {
      case UserRole.agent:
        return const AgentMainScreen();
      case UserRole.customer:
        return const CustomerMainScreen();
      case UserRole.delivery:
        return const DeliveryMainScreen();
      case UserRole.distributor:
        return const DistributorMainScreen();
      default:
        return const InitialRoleSelectionScreen();
    }
  }

}
