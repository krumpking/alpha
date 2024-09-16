import 'dart:math';
import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/constants/dimensions.dart';
import 'package:alpha/custom_widgets/cards/category_card.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:alpha/features/home/services/dummy.dart';
import 'package:alpha/features/manage_profile/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/providers.dart';
import '../../../custom_widgets/sidebar/admin_drawer.dart';
import 'admin_tabs/staff_tab.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
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

  final searchStaffProvider = ProviderUtils.searchProvider;

  @override
  void initState() {
    super.initState();

    // Ensure this is called after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final staffState = ref.read(ProviderUtils.staffProvider);
      staffState.whenData((users) {
        ref.read(searchStaffProvider.notifier).setAllUsers(users);
      });
    });

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = ref.watch(searchStaffProvider);

    final staffState = ref.watch(
      ProviderUtils.staffProvider,
    );

    return Scaffold(
      key: _key,
      drawer: Dimensions.isSmallScreen
          ? AdminDrawer(
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.network(
                        user!.photoURL ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user!.displayName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user!.email ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  labelText: 'Find Staff',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) {
                    ref.read(searchStaffProvider.notifier).filterUsers(value!);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: staffState.when(
        data: (users) {
          return _buildContent(filteredUsers);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(List<UserProfile> users) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
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

                List<String>? imagesLinks =
                    List<String>.from(stuffCard['images']);

                return CategoryCard(
                  color: randomColor,
                  title: stuffCard['title'].toString(),
                  count: int.parse(stuffCard['count'].toString()),
                  percentage: int.parse(stuffCard['percentage'].toString()),
                  images: imagesLinks,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Staff',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TabBar(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            unselectedLabelStyle: TextStyle(
              color: Pallete.greyAccent,
              fontSize: 14,
            ),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Nurses'),
              Tab(text: 'Social Workers'),
              Tab(text: 'Care/Support Workers'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                StaffTab(
                    users: users
                        .where((user) =>
                            user.post!.toLowerCase() == 'nurse' &&
                            user.role!.toLowerCase() == 'user')
                        .toList()),
                StaffTab(
                    users: users
                        .where((user) =>
                            user.post!.toLowerCase() == 'social worker' &&
                            user.role!.toLowerCase() == 'user')
                        .toList()),
                StaffTab(
                    users: users
                        .where((user) =>
                            user.post!.toLowerCase() == 'care/support worker' &&
                            user.role!.toLowerCase() == 'user')
                        .toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
