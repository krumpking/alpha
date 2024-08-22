
import 'package:alpha/core/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/animation_asset_constants.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/custom_button/general_button.dart';

class AccountVerificationSuccessful extends StatelessWidget {
  const AccountVerificationSuccessful({super.key});


  @override
  Widget build(BuildContext context) {String? sentTo;
  double screenWidth = Get.width;


  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),

          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Lottie.asset(
                    AnimationAsset.successfulAnimation,
                    width: 200
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  'Verification Successful',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),

                Text(
                  'Congratulations your account has been activated.Continue to start Shopping and Experience a world of unrivaled Deals and personalized Offers.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                  height: 40,
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

                    onTap: () => Get.offAllNamed(RoutesHelper.initialScreen)
                ),

                const SizedBox(
                  height: 30,
                ),

              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}
