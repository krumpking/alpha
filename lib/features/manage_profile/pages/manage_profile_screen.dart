import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/features/manage_profile/pages/documents_tab.dart';
import 'package:alpha/features/manage_profile/pages/notes_tab.dart';
import 'package:alpha/features/manage_profile/pages/upcoming_shifts_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/local_image_constants.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String profileEmail;
  const UserProfileScreen({
    super.key,
    required this.profileEmail,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync =
        ref.watch(ProviderUtils.profileProvider(widget.profileEmail));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    if (Dimensions.isSmallScreen)
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    userProfileAsync.when(
                      data: (userProfile) => Row(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: userProfile.profilePicture!,
                              placeholder: (context, url) => Skeletonizer(
                                enabled: true,
                                child: SizedBox(
                                  child: Image.asset(
                                    LocalImageConstants.logo,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              errorListener: (e) {
                                DevLogs.logError('Error: $e');
                              },
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProfile.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                userProfile.post!,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      loading: () => Skeletonizer(
                          child: Row(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(
                              LocalImageConstants.logo,
                              width: 120,
                              height: 120,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "userProfile.name",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "userProfile.post",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      )),
                      error: (error, stackTrace) => Text('Error: $error'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: userProfileAsync.when(
            data: (userProfile) => Column(
              children: [
                // Tab bar for Documents, Shifts, and Notes
                TabBar(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  isScrollable: true,
                  unselectedLabelStyle:
                      TextStyle(color: Pallete.greyAccent, fontSize: 14),
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  tabAlignment: TabAlignment.center,
                  tabs: const [
                    Tab(text: 'Documents'),
                    Tab(text: 'Assigned Shifts'),
                    Tab(text: 'Notes'),
                  ],
                ),
                SizedBox(
                  height: 600, // Height of the TabBarView
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Documents Tab
                      DocumentsTab(documents: userProfile.documents),

                      // Shifts Tab
                      UpcomingShiftsTab(profileEmail: userProfile.email!),

                      // Notes Tab
                      const NotesTab(notes: []),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'), // Show error message
            ),
          ),
        ),
      ),
    );
  }
}
