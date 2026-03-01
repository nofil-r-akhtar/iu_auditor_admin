import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
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

    // Define breakpoints
    bool isMobile = screenWidth < 600;

    return Scaffold(
      appBar: appBar(context, title: "New Faculty"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: isMobile ? 25 : 50,
        ),
        child: Column(
          children: [
            // Button row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  onPress: () {},
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 10 : 15,
                    vertical: isMobile ? 5 : 10,
                  ),
                  icon: Icon(
                    Icons.add,
                    fontWeight: FontWeight.w400,
                    color: whiteColor,
                    size: isMobile ? 16 : 20,
                  ),
                  txt: "Add New Faculty",
                  txtColor: whiteColor,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 15 : 25),

            // Search bar
            Align(
              alignment: Alignment.centerLeft,
              child: ScreenSearchBar(
                searchFieldController: controller.searchControler,
                searchFieldDummyText: "Search by name or department...",
              ),
            ),
            SizedBox(height: isMobile ? 20 : 35),

            // Table
            ScreenTable(
              columns: controller.col,
              controller: tableController,
            ),
          ],
        ),
      ),
    );
  }
}