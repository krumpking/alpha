import 'dart:math';
import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/core/constants/dimensions.dart';
import 'package:alpha/custom_widgets/cards/category_card.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:alpha/features/home/services/dummy.dart';
import 'package:alpha/models/user_profile.dart';
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

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> with SingleTickerProviderStateMixin {
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
    final staffState = ref.watch(ProviderUtils.staffProvider,);

    return Scaffold(
      key: _key,
      drawer: Dimensions.isSmallScreen ? AdminDrawer(user: user!,) : null,
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
                    if(Dimensions.isSmallScreen)
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
                        "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alpha Profile',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Time to save the world',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const CustomTextField(
                  labelText: 'Find Stuff',
                  prefixIcon: Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: staffState.when(
        data: (users) => _buildContent(users),
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

                List<String>? imagesLinks = List<String>.from(stuffCard['images']);

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
            'Stuff',
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
                StaffTab(users: users.where((user) => user.post.toLowerCase() == 'nurse' && user.role.toLowerCase() == 'user').toList()),
                StaffTab(users: users.where((user) => user.post.toLowerCase() == 'social worker' && user.role.toLowerCase() == 'user').toList()),
                StaffTab(users: users.where((user) => user.post.toLowerCase() == 'care/support worker' && user.role.toLowerCase() == 'user').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
