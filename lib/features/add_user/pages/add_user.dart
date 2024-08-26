import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/custom_widgets/custom_button/general_button.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:extended_phone_number_input/phone_number_input.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/local_image_constants.dart';
import '../../../custom_widgets/custom_dropdown.dart';
import '../helper/add_user_helper.dart';

class AdminAddUser extends StatefulWidget {
  const AdminAddUser({super.key});

  @override
  State<AdminAddUser> createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  String selectedRole = 'User';
  PhoneNumberInputController? phoneNumberController;
  TextEditingController emailController = TextEditingController();


  @override
  void initState() {
    super.initState();
    phoneNumberController = PhoneNumberInputController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add User',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            ClipOval(
              child: Image.asset(
                LocalImageConstants.addUser,
                width: MediaQuery.of(context).size.height * 0.18,
                height: MediaQuery.of(context).size.height * 0.18,
              ),
            ),
            const SizedBox(height: 50),
            CustomDropDown(
                prefixIcon: Icons.person,
                items: const ['Admin', 'User'],
                selectedValue: selectedRole,
                onChanged: (value){
                  setState(() {
                    selectedRole = value!;
                  });
                },
                isEnabled: true
            ),
            const SizedBox(height: 10),
            CustomTextField(
              controller: emailController,
              labelText: 'Email Address',
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),

            PhoneNumberInput(
              initialCountry: 'ZW',
              locale: 'fr',
              errorText: 'Invalid Phone Number',
              controller: phoneNumberController,
              countryListMode: CountryListMode.bottomSheet,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Pallete.primaryColor)
              ),
              allowPickFromContacts: false,
            ),

            const SizedBox(height: 30),


            Center(
              child: GeneralButton(
                onTap: () => AddUserHelper.validateAndSubmitForm(email: emailController.text.trim(), phoneNUmber: phoneNumberController!.fullPhoneNumber.trim(), password: "alpha1234", role: selectedRole),
                borderRadius: 10,
                btnColor: Pallete.primaryColor,
                width: 150,
                child: const Text(
                  "Add User",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
