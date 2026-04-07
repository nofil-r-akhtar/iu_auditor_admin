import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_dialog.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'package:iu_auditor_admin/components/home_components/screen_search_bar.dart';
import 'package:iu_auditor_admin/components/home_components/screen_table/screen_table.dart';
import 'package:iu_auditor_admin/components/home_components/screen_table/screen_table_controller.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/create_faculties/create_faculties.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/create_faculties/create_faculties_controller.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/new_faculties_controller.dart';

class NewFaculties extends StatelessWidget {
  const NewFaculties({super.key});

  @override
  Widget build(BuildContext context) {
    final controller      = Get.put(NewFacultiesController());
    final tableController = Get.put(ScreenTableController());
    final isMobile        = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: 'Manage New Teachers'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header — title left, button RIGHT ────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextBold(
                        text: 'New Teachers (Auditees)',
                        fontSize: isMobile ? 18 : 22,
                      ),
                      AppTextRegular(
                        text: 'Manage new faculty members scheduled for auditing.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // ── Add button on the RIGHT ──
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  onPress: () {
                    // Fresh controller for each add
                    Get.put(CreateFacultiesController());
                    AppDialog.show(
                      title: 'Add New Teacher',
                      content: const CreateFaculties(),
                      confirmText: 'Create',
                      onConfirm: () async {
                        final createCtrl = Get.find<CreateFacultiesController>();
                        await createCtrl.createTeacher();
                        // Refresh list after create
                        await controller.fetchTeachers();
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: whiteColor, size: 18),
                  txt: isMobile ? '' : 'Add New Teacher',
                ),
              ],
            ),
            const SizedBox(height: 25),

            ScreenSearchBar(
              searchFieldController: controller.searchControler,
              searchFieldDummyText: 'Search by name or department...',
            ),
            const SizedBox(height: 25),

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