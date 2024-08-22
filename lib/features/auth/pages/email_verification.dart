
import 'package:alpha/core/constants/route_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';
import '../helpers/helpers.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    AuthHelpers.setTimerForAutoRedirect(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.width;

    return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(screenHeight * 0.075),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Row(
              children: [
                GestureDetector(
                  onTap: ()async{
                    await AuthServices.signOut(context: context).then((value){
                      Get.toNamed(loginRoute);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Pallete.primaryColor
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),

            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Lottie.asset(
                      Assets.otpAnimation,
                      width: 200
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Verify you email address',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    '\n${widget.user.email}\n',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Text(
                    'Congratulations your account awaits. Verify your email to start Shopping and Experience a world of unrivaled Deals and personalized Offers.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  GeneralButton(
                      btnColor: Pallete.primaryColor,
                      width: screenWidth,
                      borderRadius: 10,
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),

                      onTap: () => AuthHelpers.checkEmailVerification(context: context, currentUser: _currentUser)
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

                      Get.snackbar(
                        'Email Verification',
                        'Verification Email Sent',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    },

                    child: RichText(
                      text: TextSpan(
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                          ),
                          children: [
                            const TextSpan(
                                text: "Didn't receive the email?"
                            ),

                            TextSpan(
                                text: " Resend",
                                style: GoogleFonts.poppins(
                                    color: Pallete.primaryColor,
                                    fontWeight: FontWeight.bold
                                )
                            )
                          ]
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}