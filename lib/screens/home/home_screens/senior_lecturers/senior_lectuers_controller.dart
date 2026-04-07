import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/table/table_model.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';

class SeniorLectueresController extends GetxController {
  final AdminApi _api = AdminApi();
  final TextEditingController searchController = TextEditingController();

  RxList<TableColumnModel> col       = <TableColumnModel>[].obs;
  RxList<AdminUser>        lecturers = <AdminUser>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() { super.onInit(); _initializeColumns(); fetchSeniorLecturers(); }

  Future<void> fetchSeniorLecturers() async {
    try {
      isLoading.value = true;
      final r = await _api.getSeniorLecturers();
      if (!r.success) { Get.snackbar('Error', r.message); return; }
      lecturers.assignAll(r.data);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally { isLoading.value = false; }
  }

  Future<void> deleteLecturer(String id) async {
    try {
      final res = await _api.deleteUser(id);
      if (res['success'] == true) {
        lecturers.removeWhere((l) => l.id == id);
        Get.snackbar('Success', 'Senior Lecturer deleted successfully');
      } else { Get.snackbar('Error', res['message'] ?? 'Delete failed'); }
    } catch (e) { Get.snackbar('Error', e.toString()); }
  }

  void _initializeColumns() {
    col.assignAll([
      TableColumnModel(title: 'Name / Email', cellBuilder: (row) {
        final l = row as AdminUser;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          AppTextSemiBold(text: l.name, color: navyBlueColor, fontSize: 14),
          AppTextRegular(text: l.email, color: descriptiveColor, fontSize: 12),
        ]);
      }),
      TableColumnModel(title: 'Department', cellBuilder: (row) {
        final l = row as AdminUser;
        return AppTextRegular(text: l.department ?? '—', color: descriptiveColor);
      }),
      TableColumnModel(title: 'Role', cellBuilder: (row) {
        final l = row as AdminUser;
        return AppContainer(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          borderRadius: BorderRadius.circular(4), bgColor: bgColor,
          child: AppTextMedium(text: l.roleLabel, fontSize: 12, color: navyBlueColor));
      }),
      TableColumnModel(title: 'Joined', cellBuilder: (row) {
        final l = row as AdminUser;
        final date = l.createdAt.length >= 10 ? l.createdAt.substring(0, 10) : l.createdAt;
        return AppTextRegular(text: date, color: descriptiveColor);
      }),
      TableColumnModel(title: 'Actions', cellBuilder: (row) {
        final l = row as AdminUser;
        return Row(children: [
          AppIconButton(icon: Icons.edit_outlined, iconColor: iconColor, onPressed: () {}),
          AppIconButton(icon: Icons.delete_outline, iconColor: redColor, onPressed: () => deleteLecturer(l.id)),
        ]);
      }),
    ]);
  }

  @override
  void onClose() { searchController.dispose(); super.onClose(); }
}
