import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/side_bar.dart';
import 'package:iu_auditor_admin/screens/home/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final width = MediaQuery.of(context).size.width;
    bool isTablet = width >= 768 && width < 1200;
    bool isMobile = width < 768;

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              child: SideBar(
                listItems: controller.menuItems,
                isCollapsed: false,
              ),
            )
          : null,

      appBar: isMobile
          ? AppBar(
            iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: navyBlueColor,
              title: AppTextBold(
                  text: "Auditor Portal",
                  color: whiteColor,
                  fontSize: 16,
                ),
            )
          : null,

      body: Row(
        children: [
          /// Sidebar for Tablet & Desktop
          if (!isMobile)
            SideBar(
              listItems: controller.menuItems,
              isCollapsed: isTablet, // 👈 collapse on tablet
            ),

          /// Main Content
          Expanded(
            child: AppContainer(
              
              child: Obx(() {
                return IndexedStack(
                  index: controller.selectedIndex.value,
                  children: controller.pages,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}