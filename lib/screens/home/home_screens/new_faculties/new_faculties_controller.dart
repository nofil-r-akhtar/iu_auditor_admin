import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';

class NewFacultiesController extends GetxController {
  final TextEditingController searchControler = TextEditingController();

  // Observable list of columns to trigger UI refresh
  RxList<TableColumnModel> col = <TableColumnModel>[].obs;

  // Observable dummy data
  RxList<Map<String, dynamic>> faculties = <Map<String, dynamic>>[
    {
      "name": "Mr. Ali Khan",
      "email": "ali.khan@iqra.edu.pk",
      "department": "Computer Science",
      "specialization": "AI/ML",
      "joiningDate": "2024-01-15",
      "status": "In Progress",
    },
    {
      "name": "Ms. Fatima Noor",
      "email": "fatima.noor@iqra.edu.pk",
      "department": "Business Admin",
      "specialization": "Marketing",
      "joiningDate": "2024-02-01",
      "status": "Pending",
    },
    {
      "name": "Dr. Bilal Raza",
      "email": "bilal.raza@iqra.edu.pk",
      "department": "Engineering",
      "specialization": "Power Systems",
      "joiningDate": "2023-12-10",
      "status": "Completed",
    },
    {
      "name": "Ms. Zainab Ahmed",
      "email": "zainab.ahmed@iqra.edu.pk",
      "department": "Social Sciences",
      "specialization": "Psychology",
      "joiningDate": "2024-03-05",
      "status": "Pending",
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Populate columns immediately on initialization
    _initializeColumns();
  }

  void _initializeColumns() {
    // Using .assignAll to safely update the RxList
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
        title: "Specialization",
        cellBuilder: (row) => AppTextRegular(text: row['specialization'] ?? ""),
      ),
      TableColumnModel(
        title: "Joining Date",
        cellBuilder: (row) => AppTextRegular(text: row['joiningDate'] ?? ""),
      ),
      TableColumnModel(
        title: "Status",
        cellBuilder: (row) {
          final status = row['status'] ?? "Pending";
          Color statusColor = status == "Completed"
              ? Colors.green
              : (status == "Pending" ? Colors.orange : Colors.blue);

          return AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            borderRadius: BorderRadius.circular(20),
            bgColor: statusColor.withValues(alpha: 0.1),
            child: AppTextMedium(
              text: status,
              color: statusColor,
              fontSize: 12,
            ),
          );
        },
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
    searchControler.dispose(); // Cleanup controllers
    super.onClose();
  }
}
