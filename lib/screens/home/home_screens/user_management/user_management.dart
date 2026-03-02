import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'package:iu_auditor_admin/components/home_components/screen_search_bar.dart';
import 'package:iu_auditor_admin/components/home_components/screen_table/screen_table.dart';
import 'package:iu_auditor_admin/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/user_management/user_management_controller.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserManagementController());
    final tableController = Get.put(ScreenTableController());
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: bgColor, // Consistent silver background
      appBar: appBar(context, title: "User Management"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25, // Consistent top padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextBold(text: "User Management", fontSize: 22),
                    AppTextRegular(
                      text: "Manage admin portal users and their permissions.",
                      color: descriptiveColor,
                    ),
                  ],
                ),
                AppButton(
                  onPress: () {},
                  icon: const Icon(Icons.add, color: whiteColor, size: 20),
                  txt: "Add User",
                ),
              ],
            ),
            const SizedBox(height: 25),

            // RBAC Info Banner
            AppContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(8),
              bgColor: const Color(0xFFEFF6FF),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextBold(
                          text: "Role-Based Access Control",
                          color: primaryColor,
                          fontSize: 14,
                        ),
                        AppTextRegular(
                          text:
                              "Users can be assigned different roles with specific permissions. Super Admins have full access, while Viewers have read-only access.",
                          color: primaryColor.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Search Bar
            ScreenSearchBar(
              searchFieldController: controller.searchController,
              searchFieldDummyText: "Search by name, email, or role...",
            ),
            const SizedBox(height: 25),

            // Table
            Obx(() {
              if (controller.col.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return AppContainer(
                bgColor: whiteColor,
                borderRadius: BorderRadius.circular(12),
                child: ScreenTable(
                  columns: controller.col,
                  data: controller.users,
                  controller: tableController,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
