import 'dart:math';
import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/constants/local_image_constants.dart';
import 'package:alpha/core/routes/routes.dart';
import 'package:alpha/custom_widgets/cards/category_card.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:alpha/features/feedback/models/feedback_model.dart';
import 'package:alpha/features/home/helpers/helper.dart';
import 'package:alpha/features/home/pages/user_tabs/previous_shifts_tab.dart';
import 'package:alpha/features/home/pages/user_tabs/upcoming_shifts_tab.dart';
import 'package:alpha/features/home/services/dummy.dart';
import 'package:alpha/features/manage_profile/pages/documents_tab.dart';
import 'package:alpha/features/manage_profile/pages/notes_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/providers.dart';
import '../../../custom_widgets/sidebar/user_drawer.dart';
import '../../manage_profile/models/user_profile.dart';
import '../../not_found/user_profile_not_found.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String searchTerm = '';
  late TabController _tabController;
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.amber
  ];
  final _key = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  List<FeedbackModel> feedback = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(ProviderUtils.profileProvider(user!.email!));

    ref.listen<AsyncValue<UserProfile>>(ProviderUtils.profileProvider(user!.email!), (previous, next) {
      next.whenData((userProfile) {
        ref.read(ProviderUtils.expiringDocumentsProvider.notifier).checkExpiringDocuments(userProfile);

        final expiringDocuments = ref.read(ProviderUtils.expiringDocumentsProvider);
        if (expiringDocuments.isNotEmpty) {
          Future.delayed(const Duration(seconds: 20), () {
            HomeHelper.showExpiringDocuments(
                message: 'The following documents are expiring or have expired:',
                documents: expiringDocuments
            );
          });

        }
      });
    });

    return userProfileAsync.hasValue
        ? Scaffold(
      key: _key,
      drawer: Dimensions.isSmallScreen
          ? UserDrawer(
              user: user!,
            )
          : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (Dimensions.isSmallScreen)
                          IconButton(
                            onPressed: () {
                              _key.currentState!.openDrawer();
                            },
                            icon: const Icon(Icons.menu),
                          ),
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: user!.photoURL ?? '',
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
                              user!.displayName ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            userProfileAsync.when(
                              data: (userProfile) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userProfile.post!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              loading: () => const Skeletonizer(
                                  child: Text(
                                'Post  ',
                                style: TextStyle(fontSize: 12),
                              )),
                              error: (error, stackTrace) =>
                                  Text('Error: $error'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomTextField(
                      labelText: 'Find some shifts',
                      prefixIcon: const Icon(Icons.search),
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value!;
                        });
                      },
                    ),
                  ],
                ))),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shifts report',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 235,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: jsonData.length,
                itemBuilder: (context, index) {
                  final stuffCard = jsonData[index];
                  final randomColor = colors[Random().nextInt(colors.length)];

                  List<String>? imagesLinks = List<String>.from(stuffCard['images']);

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesHelper.seeUserFeedbackScreen, arguments: user!.email!);
                    },
                    child: CategoryCard(
                      color: randomColor,
                      title: 'Alpha Feeback',
                      count: feedback.length,
                      percentage: int.parse(stuffCard['percentage'].toString()),
                      images: imagesLinks,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'My Tasks',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TabBar(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              isScrollable: true,
              unselectedLabelStyle:
                  TextStyle(color: Pallete.greyAccent, fontSize: 14),
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'Upcoming Shifts'),
                Tab(text: 'Shifts Done'),
                Tab(text: 'Documents Expiring'),
                Tab(text: 'Notes'),
              ],
            ),
            SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    MyUpcomingShiftsTab(currentUser: user!, searchTerm: searchTerm),
                    MyPreviousShiftsTab(currentUser: user!, searchTerm: searchTerm),
                    DocumentsTab(ref: ref, profile: userProfileAsync.value!, documents: ref.read(ProviderUtils.expiringDocumentsProvider)),
                    NotesTab(selectedUser: userProfileAsync.value!)
                  ],
                )),
          ],
        ),
      ),
    )
        : const UserProfileNotFound();
  }
}
