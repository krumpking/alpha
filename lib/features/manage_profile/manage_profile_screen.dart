import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/dimensions.dart';
import '../../custom_widgets/cards/task_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;


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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if(Dimensions.isSmallScreen)IconButton(
                          onPressed: (){
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back),
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
                  ],
                )
            )
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                tabAlignment: TabAlignment.center,
                tabs: const [
                  Tab(text: 'Documents'),
                  Tab(text: 'Assigned Shifts'),
                  Tab(text: 'Noted'),
                ],
              ),

              SizedBox(
                  height: 600,
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