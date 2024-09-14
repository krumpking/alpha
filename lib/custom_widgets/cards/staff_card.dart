import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/utils/routes.dart';
import '../../features/shift/services/add_shif_services.dart';
import '../../models/shift.dart';
import '../../models/user_profile.dart';

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
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
            const Divider(color: Colors.grey),
            FutureBuilder<Shift?>(
              future: ShiftServices.getNextUserShiftByEmail(
                  email: user.email!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle error here
                  return Text('Error loading next shift: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final nextShift = snapshot.data;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: 'Next Shift:  ',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black)),
                          TextSpan(
                            text: nextShift!.notes == "Today's shift"
                                ? "Today, ${nextShift!.startTime}"
                                : '${nextShift!.date}, ${nextShift!.startTime}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Pallete.primaryColor,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          nextShift!.placeName,
                          style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('No upcoming shifts');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  dynamic buildPopUpOption({
    required String title,
    required IconData icon,
    required int value,
    required void Function() onTap,
  }) {
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