import 'package:alpha/custom_widgets/cards/staff_card.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:flutter/material.dart';

class StaffTab extends StatefulWidget {
  final List<UserProfile> users;
  const StaffTab({
    super.key,
    required this.users,
  });

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final user = widget.users[index];
        return StaffCard(user: user);
      },
    );
  }
}
