import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_dialog.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';
import 'add_user/add_user.dart';
import 'add_user/add_user_controller.dart';
import 'edit_user/edit_user.dart';
import 'edit_user/edit_user_controller.dart';

class UserManagementController extends GetxController {
  final AdminApi _api = AdminApi();
  final TextEditingController searchController = TextEditingController();

  RxList<TableColumnModel> col   = <TableColumnModel>[].obs;
  RxList<AdminUser>        users = <AdminUser>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeColumns();
    fetchUsers();
  }

  // ── FETCH ──────────────────────────────────────────────────
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final r = await _api.getAllUsers();
      if (!r.success) { Get.snackbar('Error', r.message); return; }
      // Exclude senior_lecturer — managed in Senior Lecturers panel
      users.assignAll(
        r.data.where((u) => u.role != 'senior_lecturer').toList(),
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── ADD ────────────────────────────────────────────────────
  void openAddDialog() {
    Get.put(AddUserController());
    AppDialog.show(
      title: 'Add User',
      content: const AddUser(),
      confirmText: 'Create User',
      onConfirm: () async {
        await Get.find<AddUserController>().createUser();
        await fetchUsers();
        Get.delete<AddUserController>();
      },
      onCancel: () {
        Get.back();
        Get.delete<AddUserController>();
      },
    );
  }

  // ── EDIT ───────────────────────────────────────────────────
  void openEditDialog(AdminUser user) {
    final editCtrl = Get.put(EditUserController(), tag: user.id);
    editCtrl.initFromUser(user);

    AppDialog.show(
      title: 'Edit User',
      content: EditUser(tag: user.id),
      confirmText: 'Save Changes',
      onConfirm: () async {
        await Get.find<EditUserController>(tag: user.id).updateUser();
        await fetchUsers();
        Get.delete<EditUserController>(tag: user.id);
      },
      onCancel: () {
        Get.back();
        Get.delete<EditUserController>(tag: user.id);
      },
    );
  }

  // ── DELETE ─────────────────────────────────────────────────
  void confirmDelete(AdminUser user) {
    AppDialog.showDeleteConfirm(
      teacherName: user.name,
      onConfirm: () => _performDelete(user.id),
    );
  }

  Future<void> _performDelete(String id) async {
    try {
      final res = await _api.deleteUser(id);
      if (res['success'] == true) {
        Get.snackbar('Success', 'User deleted successfully');
        await fetchUsers();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ── ROLE COLOR ─────────────────────────────────────────────
  Color _roleColor(String role) {
    switch (role) {
      case 'super_admin':     return Colors.purple;
      case 'admin':           return Colors.blue;
      case 'department_head': return Colors.teal;
      default:                return Colors.grey;
    }
  }

  // ── TABLE COLUMNS ──────────────────────────────────────────
  void _initializeColumns() {
    col.assignAll([
      TableColumnModel(
        title: 'User',
        cellBuilder: (row) {
          final u = row as AdminUser;
          return Row(children: [
            CircleAvatar(
              backgroundColor: navyBlueColor,
              radius: 18,
              child: AppTextRegular(
                  text: u.initials, color: whiteColor, fontSize: 12),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextSemiBold(text: u.name, fontSize: 13),
                AppTextRegular(
                    text: u.email, fontSize: 11, color: iconColor),
              ],
            ),
          ]);
        },
      ),
      TableColumnModel(
        title: 'Role',
        cellBuilder: (row) {
          final u = row as AdminUser;
          final c = _roleColor(u.role);
          return AppContainer(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(20),
            bgColor: c.withOpacity(0.1),
            child: AppTextMedium(
                text: u.roleLabel, color: c, fontSize: 11),
          );
        },
      ),
      TableColumnModel(
        title: 'Department',
        cellBuilder: (row) {
          final u = row as AdminUser;
          return AppTextRegular(
            text: u.department ?? '—',
            color: descriptiveColor,
            fontSize: 13,
          );
        },
      ),
      TableColumnModel(
        title: 'Joined',
        cellBuilder: (row) {
          final u = row as AdminUser;
          final date = u.createdAt.length >= 10
              ? u.createdAt.substring(0, 10)
              : u.createdAt;
          return Row(children: [
            const Icon(Icons.access_time, size: 13, color: iconColor),
            const SizedBox(width: 5),
            AppTextRegular(
                text: date, fontSize: 12, color: descriptiveColor),
          ]);
        },
      ),
      TableColumnModel(
        title: 'Actions',
        cellBuilder: (row) {
          final u = row as AdminUser;
          final isSuperAdmin = u.role == 'super_admin';
          return Row(children: [
            AppIconButton(
              icon: Icons.edit_outlined,
              iconColor: iconColor,
              onPressed: () => openEditDialog(u),
            ),
            // AppIconButton.onPressed is non-nullable (VoidCallback).
            // Use Opacity to visually disable delete for super_admin
            // and pass a no-op callback so the type is satisfied.
            Opacity(
              opacity: isSuperAdmin ? 0.3 : 1.0,
              child: AppIconButton(
                icon: Icons.delete_outline,
                iconColor: redColor,
                onPressed: isSuperAdmin
                    ? () {}                    // no-op — protected by Opacity
                    : () => confirmDelete(u),
              ),
            ),
          ]);
        },
      ),
    ]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}