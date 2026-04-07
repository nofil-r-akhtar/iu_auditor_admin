import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';

class UserManagementController extends GetxController {
  final AdminApi _api = AdminApi();
  final TextEditingController searchController = TextEditingController();

  RxList<TableColumnModel> col   = <TableColumnModel>[].obs;
  RxList<AdminUser>        users = <AdminUser>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() { super.onInit(); _initializeColumns(); fetchUsers(); }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final r = await _api.getAllUsers();
      if (!r.success) { Get.snackbar('Error', r.message); return; }
      users.assignAll(r.data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally { isLoading.value = false; }
  }

  Future<void> deleteUser(String id) async {
    try {
      final res = await _api.deleteUser(id);
      if (res['success'] == true) {
        users.removeWhere((u) => u.id == id);
        Get.snackbar('Success', 'User deleted successfully');
      } else { Get.snackbar('Error', res['message'] ?? 'Delete failed'); }
    } catch (e) { Get.snackbar('Error', e.toString()); }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'super_admin':     return Colors.purple;
      case 'admin':           return Colors.blue;
      case 'department_head': return Colors.teal;
      default:                return Colors.green;
    }
  }

  void _initializeColumns() {
    col.assignAll([
      TableColumnModel(title: 'User', cellBuilder: (row) {
        final u = row as AdminUser;
        return Row(children: [
          CircleAvatar(backgroundColor: navyBlueColor, radius: 18,
            child: AppTextRegular(text: u.initials, color: whiteColor, fontSize: 12)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            AppTextSemiBold(text: u.name, fontSize: 14),
            AppTextRegular(text: u.email, fontSize: 12, color: iconColor),
          ]),
        ]);
      }),
      TableColumnModel(title: 'Role', cellBuilder: (row) {
        final u = row as AdminUser; final c = _roleColor(u.role);
        return AppContainer(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          borderRadius: BorderRadius.circular(20), bgColor: c.withOpacity(0.1),
          child: AppTextMedium(text: u.roleLabel, color: c, fontSize: 11));
      }),
      TableColumnModel(title: 'Department', cellBuilder: (row) {
        final u = row as AdminUser;
        return AppTextRegular(text: u.department ?? '—', color: descriptiveColor, fontSize: 13);
      }),
      TableColumnModel(title: 'Joined', cellBuilder: (row) {
        final u = row as AdminUser;
        final date = u.createdAt.length >= 10 ? u.createdAt.substring(0, 10) : u.createdAt;
        return Row(children: [
          const Icon(Icons.access_time, size: 14, color: iconColor),
          const SizedBox(width: 6),
          AppTextRegular(text: date, fontSize: 12, color: descriptiveColor),
        ]);
      }),
      TableColumnModel(title: 'Actions', cellBuilder: (row) {
        final u = row as AdminUser;
        return Row(children: [
          AppIconButton(icon: Icons.edit_outlined, iconColor: iconColor, onPressed: () {}),
          AppIconButton(icon: Icons.delete_outline, iconColor: redColor, onPressed: () => deleteUser(u.id)),
        ]);
      }),
    ]);
  }

  @override
  void onClose() { searchController.dispose(); super.onClose(); }
}
