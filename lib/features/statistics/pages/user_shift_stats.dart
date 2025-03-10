import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/features/statistics/helpers/stats_helper.dart';
import 'package:alpha/global/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tuple/tuple.dart';
import '../../../core/constants/local_image_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserShiftStats extends ConsumerWidget {
  final String profileEmail;
  const UserShiftStats({super.key, required this.profileEmail, });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userRole = ref.watch(ProviderUtils.userRoleProvider);
    final String? email = userRole == UserRole.user ? profileEmail : null;

    final dailyHoursWorked = ref.watch(ProviderUtils.hoursWorkedProvider(Tuple2('day', email)));
    final weeklyHoursWorked = ref.watch(ProviderUtils.hoursWorkedProvider(Tuple2('week', email)));
    final monthlyHoursWorked = ref.watch(ProviderUtils.hoursWorkedProvider(Tuple2('month', email)));
    final yearlyHoursWorked = ref.watch(ProviderUtils.hoursWorkedProvider(Tuple2('year', email)));


    return Scaffold(
      backgroundColor: Pallete.primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Pallete.primaryColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(220),
          child: buildAppBarContent(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: displayStats(hoursWorked: dailyHoursWorked, title: "Hours Worked Today")),
                  const SizedBox(width: 16),
                  Expanded(child: displayStats(hoursWorked: weeklyHoursWorked, title: "Hours Worked This Week")),
                ],
              ),
              const SizedBox(height: 16),
              // Display monthly stats
              Row(
                children: [
                  Expanded(child: displayStats(hoursWorked: monthlyHoursWorked, title: "Hours Worked This Month")),
                  const SizedBox(width: 16),
                  Expanded(child: displayStats(hoursWorked: yearlyHoursWorked, title: "Hours Worked This Year")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Build AppBar content
  Widget buildAppBarContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Pallete.primaryColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: FirebaseAuth.instance.currentUser!.photoURL ??
                  "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              width: MediaQuery.of(context).size.height * 0.18,
              height: MediaQuery.of(context).size.height * 0.18,
              fit: BoxFit.cover,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Image.asset(LocalImageConstants.logo),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Text(
            FirebaseAuth.instance.currentUser!.displayName ?? 'Alpha Imperial',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text(
            'Shift Stats Overview',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget to display hours worked for a given period
  Widget displayStats({required AsyncValue<Map<String, Duration>> hoursWorked, required String title}) {
    return hoursWorked.when(
      data: (hours) {
        final totalDuration = hours['total'] ?? Duration.zero;
        return statWidget(
          number: StatsHelper.formatDuration(totalDuration),
          title: title,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        DevLogs.logError(error.toString());
        return Center(child: Text(error.toString()));
      },
    );
  }

  // Widget to display stats in the UI
  Widget statWidget({required String number, required String title}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
