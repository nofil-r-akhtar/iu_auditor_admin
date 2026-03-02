import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';

class UserManagementController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxList<TableColumnModel> col = <TableColumnModel>[].obs;

  // Mock data matching the User Management screenshot
  RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[
    {
      "name": "Dr. Ahmed Hassan",
      "email": "ahmed.hassan@iqra.edu.pk",
      "initials": "DA",
      "role": "Super Admin",
      "status": "Active",
      "permissions": "9 permissions",
      "lastLogin": "2024-03-15\n09:30 AM",
    },
    {
      "name": "Ms. Sana Malik",
      "email": "sana.malik@iqra.edu.pk",
      "initials": "MS",
      "role": "Admin",
      "status": "Active",
      "permissions": "8 permissions",
      "lastLogin": "2024-03-14\n02:15 PM",
    },
    {
      "name": "Mr. Usman Ali",
      "email": "usman.ali@iqra.edu.pk",
      "initials": "MU",
      "role": "Manager",
      "status": "Active",
      "permissions": "5 permissions",
      "lastLogin": "2024-03-13\n11:45 AM",
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
        title: "User",
        cellBuilder: (row) => Row(
          children: [
            CircleAvatar(
              backgroundColor: navyBlueColor,
              radius: 18,
              child: AppTextRegular(
                text: row['initials'],
                color: whiteColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextSemiBold(text: row['name'], fontSize: 14),
                AppTextRegular(
                  text: row['email'],
                  fontSize: 12,
                  color: iconColor,
                ),
              ],
            ),
          ],
        ),
      ),
      TableColumnModel(
        title: "Role",
        cellBuilder: (row) {
          Color roleColor = row['role'] == "Super Admin"
              ? Colors.purple
              : (row['role'] == "Admin" ? Colors.blue : Colors.green);
          return AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(20),
            bgColor: roleColor.withOpacity(0.1),
            child: AppTextMedium(
              text: row['role'],
              color: roleColor,
              fontSize: 11,
            ),
          );
        },
      ),
      TableColumnModel(
        title: "Status",
        cellBuilder: (row) => AppContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          borderRadius: BorderRadius.circular(20),
          bgColor: const Color(0xFFDCFCE7),
          child: AppTextMedium(
            text: row['status'],
            color: Colors.green,
            fontSize: 11,
          ),
        ),
      ),
      TableColumnModel(
        title: "Permissions",
        cellBuilder: (row) => AppContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          bgColor: bgColor,
          borderRadius: BorderRadius.circular(4),
          child: AppTextRegular(text: row['permissions'], fontSize: 12),
        ),
      ),
      TableColumnModel(
        title: "Last Login",
        cellBuilder: (row) => Row(
          children: [
            const Icon(Icons.access_time, size: 14, color: iconColor),
            const SizedBox(width: 6),
            AppTextRegular(
              text: row['lastLogin'],
              fontSize: 12,
              color: descriptiveColor,
            ),
          ],
        ),
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
