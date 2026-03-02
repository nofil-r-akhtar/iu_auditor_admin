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
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/senior_lectuers_controller.dart';

class SeniorLectueres extends StatelessWidget {
  const SeniorLectueres({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeniorLectueresController());
    final tableController = Get.put(ScreenTableController());

    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: "Manage Senior Lecturers"),
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
                    AppTextBold(
                      text: "Senior Lecturers (Auditors)",
                      fontSize: 22,
                    ),
                    AppTextRegular(
                      text:
                          "Manage senior faculty members who will conduct audits.",
                      color: descriptiveColor,
                    ),
                  ],
                ),
                AppButton(
                  onPress: () {},
                  icon: const Icon(Icons.add, color: whiteColor, size: 20),
                  txt: "Add Auditor",
                ),
              ],
            ),
            const SizedBox(height: 25),

            AppContainer(
              padding: const EdgeInsets.all(16),
              borderRadius: BorderRadius.circular(8),
              bgColor: const Color(0xFFEFF6FF),
              child: Row(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    color: primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextBold(
                          text: "Auditor Access",
                          color: primaryColor,
                          fontSize: 14,
                        ),
                        AppTextRegular(
                          text:
                              "Senior lecturers listed here will have access to the separate Auditor App to evaluate new teachers.",
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

            ScreenSearchBar(
              searchFieldController: controller.searchController,
              searchFieldDummyText: "Search auditors...",
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
                  data: controller.lecturers,
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
