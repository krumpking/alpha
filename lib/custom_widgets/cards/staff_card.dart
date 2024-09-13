import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/utils/routes.dart';
import 'package:alpha/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffCard extends StatelessWidget {
  final UserProfile user;
  const StaffCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutesHelper.userProfileScreen, arguments: user.email);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                  user.name!,
                  style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              subtitle: Text(
                user.post!,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: PopupMenuButton<int>(
                onSelected: (int selectedValue) {
                  // Handle the selected value
                  switch (selectedValue) {
                    case 0:
                      // Perform some action for Edit
                      break;
                    case 1:
                      // Perform some action for Delete
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  buildPopUpOption(
                    title: 'View Profile',
                    icon: Icons.remove_red_eye_outlined,
                    value: 0,
                    onTap: () {
                      Get.toNamed(RoutesHelper.userProfileScreen,
                          arguments: user.email);
                    },
                  ),


                  buildPopUpOption(
                      title: 'Add Shift',
                      icon: Icons.calendar_month,
                      value: 1,
                      onTap: () => Get.toNamed(RoutesHelper.addShiftsScreen,
                          arguments: user
                      )
                  ),

                  buildPopUpOption(
                      title: 'Add Hours worked',
                      icon: Icons.calendar_month,
                      value: 2,
                      onTap: () => Get.toNamed(RoutesHelper.addShiftsDoneScreen,
                          arguments: user
                      )
                  ),
                  buildPopUpOption(
                      title: 'Add Feedback',
                      icon: Icons.feedback,
                      value: 3,
                      onTap: () => Get.toNamed(
                          RoutesHelper.addUserFeedbackScreen,
                          arguments: user
                      )
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                        text: 'Shift:  ',
                        style: TextStyle(fontSize: 12, color: Colors.black)),
                    TextSpan(
                        text:
                            '12/34/56',
                        style: TextStyle(
                            fontSize: 12, color: Pallete.primaryColor)),
                  ]),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Alpha',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  dynamic buildPopUpOption(
      {required String title,
      required IconData icon,
      required int value,
      required void Function() onTap}) {
    return PopupMenuItem<int>(
      onTap: onTap,
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
