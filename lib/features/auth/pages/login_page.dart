import 'package:alpha/core/constants/route_constants.dart';
import 'package:alpha/custom_widgets/custom_button/general_button.dart';
import 'package:alpha/features/auth/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../animations/fade_in_slide.dart';
import '../../../core/constants/color_constants.dart';
import '../../../custom_widgets/text_fields/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final screenWidth = Get.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.green, Colors.orange],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Alpha Staffing',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      FadeInSlide(
                        duration: 1.2,
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FadeInSlide(
                        duration: 1.4,
                        child: CustomTextField(
                          controller: emailController,
                          labelText: 'Email Address',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      FadeInSlide(
                        duration: 1.6,
                        child: CustomTextField(
                          controller: passwordController,
                          obscureText: true,
                          labelText: 'password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FadeInSlide(
                        duration: 1.8,
                        child: GeneralButton(
                            btnColor: Pallete.primaryColor,
                            width: screenWidth,
                            borderRadius: 10,
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),
                            ),
                            onTap: ()=> AuthHelpers.validateAndSubmitForm(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()
                            )
                        ),
                      ),


                      const SizedBox(
                        height: 16,
                      ),
                      FadeInSlide(
                        duration: 2.2,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(RoutesHelper.forgotPasswordScreen),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                      text: "Forgot Password?",
                                      style: GoogleFonts.poppins(
                                          color: Pallete.primaryColor,
                                          fontWeight: FontWeight.w400
                                      )
                                  )
                                ]
                            ),
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
      ),
    );
  }
}