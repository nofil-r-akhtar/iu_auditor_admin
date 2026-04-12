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
import 'user_management_controller.dart';

class UserManagement extends StatelessWidget {
  const UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller      = Get.put(UserManagementController());
    final tableController = Get.put(ScreenTableController());
    final isMobile        = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: 'User Management'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header — title LEFT, button EXTREME RIGHT ─────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextBold(
                        text: 'User Management',
                        fontSize: isMobile ? 18 : 22,
                      ),
                      AppTextRegular(
                        text: 'Manage admin portal users and their roles.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  onPress: () => controller.openAddDialog(),
                  icon: const Icon(Icons.person_add_outlined,
                      color: whiteColor, size: 18),
                  txt: isMobile ? '' : 'Add User',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── RBAC Info Banner ───────────────────────────────
            AppContainer(
              padding: const EdgeInsets.all(14),
              borderRadius: BorderRadius.circular(8),
              bgColor: const Color(0xFFEFF6FF),
              child: Row(children: [
                const Icon(Icons.shield_outlined,
                    color: primaryColor, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextBold(
                      text: 'Role-Based Access Control',
                      color: primaryColor,
                      fontSize: 13,
                    ),
                    AppTextRegular(
                      text: 'Super Admin has full access · Admin manages content · Department Head manages their department.',
                      color: primaryColor,
                      fontSize: 12,
                    ),
                  ],
                )),
              ]),
            ),
            const SizedBox(height: 20),

            ScreenSearchBar(
              searchFieldController: controller.searchController,
              searchFieldDummyText: 'Search by name, email, or role...',
            ),
            const SizedBox(height: 20),

            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (controller.col.isEmpty) return const SizedBox.shrink();
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