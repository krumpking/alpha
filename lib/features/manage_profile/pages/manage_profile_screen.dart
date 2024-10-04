import 'package:alpha/core/routes/routes.dart';
import 'package:alpha/core/utils/logs.dart';
import 'package:alpha/core/utils/providers.dart';
import 'package:alpha/features/feedback/pages/see_feedback.dart';
import 'package:alpha/features/manage_profile/pages/documents_tab.dart';
import 'package:alpha/features/manage_profile/pages/feedback_tab.dart';
import 'package:alpha/features/manage_profile/pages/notes_tab.dart';
import 'package:alpha/features/manage_profile/pages/previous_shifts_tab.dart';
import 'package:alpha/features/manage_profile/pages/upcoming_shifts_tab.dart';
import 'package:alpha/global/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/local_image_constants.dart';
import '../../../custom_widgets/circular_loader/circular_loader.dart';
import '../../../custom_widgets/snackbar/custom_snackbar.dart';
import '../../workers/services/add_user_services.dart';
import '../../workers/services/media_services.dart';
import '../../workers/services/storage_services.dart';

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
  dynamic pickedImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserRole = ref.watch(ProviderUtils.userRoleProvider);

    final selectedUserProfileAsync = ref.watch(ProviderUtils.profileProvider(widget.profileEmail));

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
                    selectedUserProfileAsync.when(
                      data: (selectedUserProfile) => Row(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: selectedUserProfile.profilePicture!,
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
                          SizedBox(
                            width: 250,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedUserProfile.name!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      selectedUserProfile.email!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      selectedUserProfile.phoneNumber!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      selectedUserProfile.post!,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),

                                if(currentUserRole == UserRole.user)PopupMenuButton<int>(
                                  itemBuilder: (BuildContext context) => [
                                    buildPopUpOption(
                                      title: 'Update Profile Picture',
                                      icon: Icons.image,
                                      value: 0,
                                      onTap: () async {
                                        await MediaServices.getImageFromGallery().then((file) {
                                          setState(() {
                                            pickedImage = file;
                                          });
                                        });

                                        if (pickedImage != null) {
                                          // Show loading indicator
                                          Get.dialog(const CustomLoader(message: 'Uploading Image'), barrierDismissible: false);

                                          // Convert image to bytes
                                          final pickedImageBytes = await pickedImage.readAsBytes();
                                          String? profilePictureUrl;
                                          String? fileName = pickedImage.path.split('/').last; // Get file name

                                          // Upload the image
                                          final uploadResponse = await StorageServices.uploadDocumentAsUint8List(
                                            location: 'users/dps',
                                            uploadfile: pickedImageBytes,
                                            fileName: fileName!,
                                          );

                                          // Handle upload response
                                          if (!uploadResponse.success) {
                                            if (!Get.isSnackbarOpen) Get.back();
                                            CustomSnackBar.showErrorSnackbar(
                                                message: uploadResponse.message ?? 'Failed to upload image, Please try again'
                                            );
                                            return;
                                          }

                                          profilePictureUrl = uploadResponse.data;

                                          // Update the user's profile in Firestore
                                          final updatedProfile = selectedUserProfile.copyWith(profilePicture: profilePictureUrl);
                                          final response = await StaffServices.updateUserProfile(
                                            email: selectedUserProfile.email!,
                                            updatedProfile: updatedProfile,
                                          );

                                          // Update Firebase Auth profile picture
                                          if (user != null && user!.email == selectedUserProfile.email) {
                                            await user!.updateProfile(photoURL: profilePictureUrl);
                                          }

                                          // Close the loader dialog
                                          if (Get.isDialogOpen!) Get.back();

                                          // Show a success or error message
                                          if (response.success) {
                                            // Notify the provider to update the global state
                                            ref.read(ProviderUtils.profileProvider(selectedUserProfile.email!).notifier)
                                                .updateProfilePicture(profilePictureUrl!);
                                            CustomSnackBar.showSuccessSnackbar(message: 'Profile picture updated successfully');
                                          } else {
                                            CustomSnackBar.showErrorSnackbar(message: response.message ?? 'Failed to update profile picture');
                                          }
                                        }
                                      },
                                    ),
                                    buildPopUpOption(
                                        title: 'Change Password',
                                        icon: Icons.lock,
                                        value: 1,
                                        onTap: (){
                                          Get.toNamed(RoutesHelper.updatePasswordScreen);
                                        }
                                        ),
                                    buildPopUpOption(
                                        title: 'Update Profile',
                                        icon: Icons.edit,
                                        value: 2,
                                        onTap: () {
                                          Get.toNamed(RoutesHelper.editUserProfileScreen, arguments: selectedUserProfile);
                                        },
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ],
                            ),
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
          child: selectedUserProfileAsync.when(
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
                    Tab(text: 'Previous Shifts'),
                    Tab(text: 'Feedback'),
                    Tab(text: 'Notes'),
                  ],
                ),
                SizedBox(
                  height: 600, // Height of the TabBarView
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Documents Tab
                      DocumentsTab(documents: userProfile.documents, profile: userProfile, ref: ref,),

                      // Upcoming Shifts Tab
                      UpcomingShiftsTab(selectedUser: userProfile),

                      // Previous Shifts Tab
                      PreviousShiftsTab(selectedUser: userProfile),

                      // Feedback
                      FeedbackTab(selectedUser: userProfile),

                      // Notes Tab
                      NotesTab(selectedUser: userProfile),
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
