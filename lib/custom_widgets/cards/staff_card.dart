import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/routes/routes.dart';
import '../../features/shift/models/shift.dart';
import '../../features/manage_profile/models/user_profile.dart';
import '../../features/shift/services/shift_services.dart';

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
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.email!,
                    style:const TextStyle(fontSize: 12),
                  ),
                  Text(
                    user.phoneNumber!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              subtitle: Text(
                user.post!,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: PopupMenuButton<int>(
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
                          arguments: user)),
                  buildPopUpOption(
                      title: 'Add Hours Worked',
                      icon: Icons.watch_later_outlined,
                      value: 2,
                      onTap: () => Get.toNamed(
                          RoutesHelper.addHoursWorkedScreen,
                          arguments: [user])),
                  buildPopUpOption(
                      title: 'Add Document',
                      icon: Icons.file_copy,
                      value: 2,
                      onTap: () => Get.toNamed(
                          RoutesHelper.addDocumentsScreen,
                          arguments: [user])),

                  buildPopUpOption(
                      title: 'Add Notes',
                      icon: Icons.note_alt_outlined,
                      value: 2,
                      onTap: () => Get.toNamed(
                          RoutesHelper.addNotesScreen,
                          arguments: [user])),


                  buildPopUpOption(
                      title: 'Add Feedback',
                      icon: Icons.feedback,
                      value: 1,
                      onTap: () => Get.toNamed(
                          RoutesHelper.addUserFeedbackScreen,
                          arguments: [user, null])),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ),
            const Divider(color: Colors.grey),
            FutureBuilder<Shift?>(
              future: ShiftServices.getNextUserShiftByEmail(email: user.email!),
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black)),
                          TextSpan(
                            text: nextShift!.notes == "Today's shift"
                                ? "Today, ${nextShift.startTime}"
                                : '${nextShift.date}, ${nextShift.startTime}',
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
                          nextShift.placeName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
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
