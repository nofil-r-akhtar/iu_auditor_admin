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
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: 'Manage Senior Lecturers'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Responsive header ──────────────────────────────────
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextBold(
                        text: 'Senior Lecturers (Auditors)',
                        fontSize: isMobile ? 18 : 22,
                      ),
                      AppTextRegular(
                        text: 'Manage senior faculty members who will conduct audits.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  onPress: () {},
                  icon: const Icon(Icons.add, color: whiteColor, size: 18),
                  txt: isMobile ? '' : 'Add Auditor',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Info banner ────────────────────────────────────────
            AppContainer(
              padding: const EdgeInsets.all(14),
              borderRadius: BorderRadius.circular(8),
              bgColor: const Color(0xFFEFF6FF),
              child: Row(
                children: [
                  const Icon(Icons.school_outlined, color: primaryColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextBold(text: 'Auditor Access', color: primaryColor, fontSize: 13),
                        AppTextRegular(
                          text: 'Senior lecturers here will have access to the Auditor App to evaluate new teachers.',
                          color: primaryColor,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ScreenSearchBar(
              searchFieldController: controller.searchController,
              searchFieldDummyText: 'Search auditors...',
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