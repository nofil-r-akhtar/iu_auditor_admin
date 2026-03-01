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
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/new_faculties_controller.dart';

class NewFaculties extends StatelessWidget {
  const NewFaculties({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewFacultiesController());
    final tableController = Get.put(ScreenTableController());

    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: "Manage New Teachers"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextBold(text: "New Teachers (Auditees)", fontSize: 22),
                    AppTextRegular(
                      text:
                          "Manage new faculty members scheduled for auditing.",
                      color: descriptiveColor,
                    ),
                  ],
                ),
                AppButton(
                  onPress: () {},
                  icon: const Icon(Icons.add, color: whiteColor, size: 20),
                  txt: "Add New Teacher",
                ),
              ],
            ),
            const SizedBox(height: 25),

            AppContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(8),
              bgColor: const Color(0xFFFFFBEB),
              border: Border.all(color: Colors.orange.shade200),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Colors.brown,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextBold(
                          text: "No Portal Access",
                          color: Colors.brown,
                          fontSize: 14,
                        ),
                        AppTextRegular(
                          text:
                              "Teachers added here are for auditing purposes only. They will NOT receive login credentials and cannot access this portal.",
                          color: Colors.brown.shade400,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            ScreenSearchBar(
              searchFieldController: controller.searchControler,
              searchFieldDummyText: "Search by name or department...",
            ),
            const SizedBox(height: 25),

            Obx(() {
              if (controller.col.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return AppContainer(
                bgColor: whiteColor,
                borderRadius: BorderRadius.circular(12),
                child: ScreenTable(
                  columns: controller.col,
                  data: controller.faculties,
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
