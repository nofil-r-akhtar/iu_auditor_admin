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
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/add_lecturers/add_lectuerers.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/add_lecturers/add_lectuerers_controller.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/edit_lecturers/edit_lectureres.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/edit_lecturers/edit_lecturers_controller.dart';


class SeniorLectueresController extends GetxController {
  final AdminApi _api = AdminApi();
  final TextEditingController searchController = TextEditingController();

  RxList<TableColumnModel> col       = <TableColumnModel>[].obs;
  RxList<AdminUser>        lecturers = <AdminUser>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeColumns();
    fetchSeniorLecturers();
  }

  // ── FETCH ──────────────────────────────────────────────────
  Future<void> fetchSeniorLecturers() async {
    try {
      isLoading.value = true;
      final r = await _api.getSeniorLecturers();
      if (!r.success) { Get.snackbar('Error', r.message); return; }
      lecturers.assignAll(r.data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── ADD ────────────────────────────────────────────────────
  void openAddDialog() {
    Get.put(AddLecturerController());
    AppDialog.show(
      title: 'Add Auditor',
      content: const AddLecturer(),
      confirmText: 'Create Auditor',
      onConfirm: () async {
        await Get.find<AddLecturerController>().createLecturer();
        await fetchSeniorLecturers();
        Get.delete<AddLecturerController>();
      },
      onCancel: () {
        Get.back();
        Get.delete<AddLecturerController>();
      },
    );
  }

  // ── EDIT ───────────────────────────────────────────────────
  void openEditDialog(AdminUser lecturer) {
    final editCtrl = Get.put(EditLecturerController(), tag: lecturer.id);
    editCtrl.initFromLecturer(lecturer);

    AppDialog.show(
      title: 'Edit Auditor',
      content: EditLecturer(tag: lecturer.id),
      confirmText: 'Save Changes',
      onConfirm: () async {
        await Get.find<EditLecturerController>(tag: lecturer.id).updateLecturer();
        await fetchSeniorLecturers();
        Get.delete<EditLecturerController>(tag: lecturer.id);
      },
      onCancel: () {
        Get.back();
        Get.delete<EditLecturerController>(tag: lecturer.id);
      },
    );
  }

  // ── DELETE ─────────────────────────────────────────────────
  void confirmDelete(AdminUser lecturer) {
    AppDialog.showDeleteConfirm(
      teacherName: lecturer.name,
      onConfirm: () => _performDelete(lecturer.id),
    );
  }

  Future<void> _performDelete(String id) async {
    try {
      final res = await _api.deleteUser(id);
      if (res['success'] == true) {
        Get.snackbar('Success', 'Auditor deleted successfully');
        await fetchSeniorLecturers();
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // ── TABLE COLUMNS ──────────────────────────────────────────
  void _initializeColumns() {
    col.assignAll([
      TableColumnModel(
        title: 'Name / Email',
        cellBuilder: (row) {
          final l = row as AdminUser;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextSemiBold(text: l.name, color: navyBlueColor, fontSize: 13),
              const SizedBox(height: 2),
              AppTextRegular(text: l.email, color: descriptiveColor, fontSize: 11),
            ],
          );
        },
      ),
      TableColumnModel(
        title: 'Department',
        cellBuilder: (row) {
          final l = row as AdminUser;
          return AppTextRegular(
            text: l.department ?? '—',
            color: descriptiveColor,
            fontSize: 13,
          );
        },
      ),
      TableColumnModel(
        title: 'Role',
        cellBuilder: (row) {
          final l = row as AdminUser;
          return AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(20),
            bgColor: const Color(0xFFEEF2FF),
            child: AppTextMedium(
              text: l.roleLabel,
              fontSize: 12,
              color: primaryColor,
            ),
          );
        },
      ),
      TableColumnModel(
        title: 'Joined',
        cellBuilder: (row) {
          final l = row as AdminUser;
          final date = l.createdAt.length >= 10
              ? l.createdAt.substring(0, 10)
              : l.createdAt;
          return AppTextRegular(text: date, color: descriptiveColor, fontSize: 13);
        },
      ),
      TableColumnModel(
        title: 'Actions',
        cellBuilder: (row) {
          final l = row as AdminUser;
          return Row(children: [
            AppIconButton(
              icon: Icons.edit_outlined,
              iconColor: iconColor,
              onPressed: () => openEditDialog(l),
            ),
            AppIconButton(
              icon: Icons.delete_outline,
              iconColor: redColor,
              onPressed: () => confirmDelete(l),
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