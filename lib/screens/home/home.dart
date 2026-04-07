import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/components/home_components/side_bar.dart';
import 'package:iu_auditor_admin/screens/home/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final width = MediaQuery.of(context).size.width;
    final bool isTablet = width >= 768 && width < 1200;
    final bool isMobile = width < 768;

    return Scaffold(
      // Drawer is available on mobile — each screen's AppBar will open it
      drawer: isMobile
          ? Drawer(
              child: SideBar(
                listItems: controller.menuItems,
                isCollapsed: false,
              ),
            )
          : null,

      body: Row(
        children: [
          // Persistent sidebar on tablet and desktop
          if (!isMobile)
            SideBar(
              listItems: controller.menuItems,
              isCollapsed: isTablet,
            ),

          Expanded(
            child: Obx(() => IndexedStack(
              index: controller.selectedIndex.value,
              children: controller.pages,
            )),
          ),
        ],
      ),
    );
  }
}