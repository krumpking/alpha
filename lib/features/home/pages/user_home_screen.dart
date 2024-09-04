import 'dart:math';

import 'package:alpha/core/constants/color_constants.dart';
import 'package:alpha/custom_widgets/cards/category_card.dart';
import 'package:alpha/custom_widgets/cards/task_item.dart';
import 'package:alpha/custom_widgets/text_fields/custom_text_field.dart';
import 'package:alpha/features/home/services/dummy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/dimensions.dart';
import '../../../custom_widgets/sidebar/user_drawer.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      key: _key,
      drawer: Dimensions.isSmallScreen ? UserDrawer(user: user!,) : null,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: Padding(
            padding:const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    if(Dimensions.isSmallScreen)IconButton(
                      onPressed: (){
                        _key.currentState!.openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Max Rosco',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          'Mental Health Nurse',
                          style: TextStyle(
                            fontSize: 12
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  height: 16,
                ),

                const CustomTextField(
                    labelText: 'Find some shifts',
                    prefixIcon: Icon(
                      Icons.search
                    )
                ),
              ],
            )
          )
        ),
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
              unselectedLabelStyle: TextStyle(
                color: Pallete.greyAccent,
                fontSize: 14
              ),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'Shifts'),
                Tab(text: 'Documents Expiring'),
                Tab(text: 'Shifts Done'),
              ],
            ),
            SizedBox(
                height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabCategory(),
                  _buildTabCategory(),
                  _buildTabCategory(),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabCategory(){
    return SizedBox(
      height: 800,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          TaskItemCard(
            name: 'NHS Shifts',
            role: 'Hospital',
            time: '12/08/24 1:00pm - 2:00pm',
            type: 'Available',
          ),

          TaskItemCard(
            name: 'NHS Shifts',
            role: 'Hospital',
            time: '12/08/24 1:00pm - 2:00pm',
            type: 'Available',
          ),

          TaskItemCard(
            name: 'NHS Shifts',
            role: 'Hospital',
            time: '12/08/24 1:00pm - 2:00pm',
            type: 'Available',
          ),

          TaskItemCard(
            name: 'NHS Shifts',
            role: 'Hospital',
            time: '12/08/24 1:00pm - 2:00pm',
            type: 'Available',
          ),
        ],
      ),
    );
  }

}