import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';

class SeniorLectueresController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxList<TableColumnModel> col = <TableColumnModel>[].obs;

  RxList<Map<String, dynamic>> lecturers = <Map<String, dynamic>>[
    {
      "name": "Dr. Sarah Ahmed",
      "email": "sarah.ahmed@iqra.edu.pk",
      "department": "Computer Science",
      "designation": "Associate Professor",
      "experience": "12 Years",
    },
    {
      "name": "Prof. John Doe",
      "email": "john.doe@iqra.edu.pk",
      "department": "Engineering",
      "designation": "Professor & HOD",
      "experience": "20 Years",
    },
    {
      "name": "Dr. Ayesha Khan",
      "email": "ayesha.khan@iqra.edu.pk",
      "department": "Business Admin",
      "designation": "Assistant Professor",
      "experience": "8 Years",
    },
    {
      "name": "Mr. Kamran Ali",
      "email": "kamran.ali@iqra.edu.pk",
      "department": "Social Sciences",
      "designation": "Senior Lecturer",
      "experience": "15 Years",
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeColumns();
  }

  void _initializeColumns() {
    col.assignAll([
      TableColumnModel(
        title: "Name / Email",
        cellBuilder: (row) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextSemiBold(
              text: row['name'] ?? "",
              color: navyBlueColor,
              fontSize: 14,
            ),
            AppTextRegular(
              text: row['email'] ?? "",
              color: descriptiveColor,
              fontSize: 12,
            ),
          ],
        ),
      ),
      TableColumnModel(
        title: "Department",
        cellBuilder: (row) => AppTextRegular(text: row['department'] ?? ""),
      ),
      TableColumnModel(
        title: "Designation",
        cellBuilder: (row) => AppContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          borderRadius: BorderRadius.circular(4),
          bgColor: bgColor,
          child: AppTextMedium(
            text: row['designation'] ?? "",
            fontSize: 12,
            color: navyBlueColor,
          ),
        ),
      ),
      TableColumnModel(
        title: "Experience",
        cellBuilder: (row) => AppTextRegular(text: row['experience'] ?? ""),
      ),
      TableColumnModel(
        title: "Actions",
        cellBuilder: (row) => Row(
          children: [
            AppIconButton(
              icon: Icons.edit_outlined,
              iconColor: iconColor,
              onPressed: () {},
            ),
            AppIconButton(
              icon: Icons.delete_outline,
              iconColor: redColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
