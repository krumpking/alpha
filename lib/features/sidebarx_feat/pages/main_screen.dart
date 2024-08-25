import 'package:alpha/features/sidebarx_feat/pages/user_tabs_container.dart';
import 'package:alpha/global/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../../custom_widgets/sidebar/sidebar.dart';
import 'admin_tabs_container.dart';

class MainScreen extends StatelessWidget {
  final UserRole selectedRole;
  MainScreen({super.key, required this.selectedRole});
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = Get.width < 600;
        return Scaffold(
          key: _key,
          body: Row(
            children: [
              if (!isSmallScreen) Sidebar(controller: _controller),
              Expanded(
                child: Center(
                  child: selectedRole == UserRole.admin
                    ? AdminTabScreensContainer(
                        controller: _controller,
                      )
                    : UserTabScreensContainer(
                        controller: _controller,
                      ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
