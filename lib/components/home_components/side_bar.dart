import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_image.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/side_bar_item.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/screens/home/home_controller.dart';

class SideBar extends StatelessWidget {
  final List<Map<String, String>> listItems;
  final bool isCollapsed;
  const SideBar({
    required this.listItems,
    this.isCollapsed = false,
    super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    double sidebarWidth = isCollapsed ? 90 : 260;
    return AppContainer(
      width: sidebarWidth,
      borderRadius: BorderRadius.zero,
      bgColor: navyBlueColor,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
              isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              AppAssetImage(
                imagePath: logo,
                height: isCollapsed ? 35 : 50,
                width: isCollapsed ? 50 : 135,
                fit: BoxFit.contain,
              ),
              if (!isCollapsed) ...[
                SizedBox(width: 12),
                AppTextSemiBold(
                  text: "Auditor\nPortal",
                  color: whiteColor,
                  fontSize: 16,
                  h: 1.4,
                ),
              ]
            ],
          ),
          SizedBox(height: 40),
          Expanded(
            flex:  2,
            child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  var item = listItems[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedIndex.value == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.changeIndex(index);
                          // Close drawer if on mobile
                            if (Scaffold.of(context).isDrawerOpen) {
                              Navigator.of(context).pop();
                            }
                        },
                        child: SideBarItem(
                          icon: item["logo"] ?? "",
                          name: isCollapsed ? "" : item["name"] ?? "",
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  });
                }
              )
          ),
          Spacer(),
          SideBarItem(
            icon: signOut, 
            name: isCollapsed ? "" : "Sign Out")
        ],
      ),
    );
  }
}