import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';

class EditLecturerController extends GetxController {
  final AdminApi _api = AdminApi();

  // ── Readonly ─────────────────────────────────────────────
  late final String lecturerId;
  late final String readonlyEmail;

  // ── Editable ─────────────────────────────────────────────
  final nameController     = TextEditingController();
  final passwordController = TextEditingController();
  final Rx<Department?> selectedDepartment = Rx<Department?>(null);

  var isUpdating       = false.obs;
  var isPasswordHidden = true.obs;

  // ── Errors ───────────────────────────────────────────────
  var nameError       = ''.obs;
  var departmentError = ''.obs;
  var passwordError   = ''.obs;

  void initFromLecturer(AdminUser lecturer) {
    lecturerId               = lecturer.id;
    readonlyEmail            = lecturer.email;
    nameController.text      = lecturer.name;
    selectedDepartment.value = Department.fromLabel(lecturer.department ?? '');
    passwordController.clear(); // always blank — optional field
  }

  bool _validate() {
    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required'; valid = false;
    } else { nameError.value = ''; }

    if (selectedDepartment.value == null) {
      departmentError.value = 'Please select a department'; valid = false;
    } else { departmentError.value = ''; }

    // Password is optional — but if filled it must be at least 6 chars
    final pw = passwordController.text.trim();
    if (pw.isNotEmpty && pw.length < 6) {
      passwordError.value = 'Password must be at least 6 characters'; valid = false;
    } else { passwordError.value = ''; }

    return valid;
  }

  Future<void> updateLecturer() async {
    if (!_validate()) return;
    try {
      isUpdating.value = true;

      final pw = passwordController.text.trim();

      final res = await _api.updateUser(
        id:         lecturerId,
        name:       nameController.text.trim(),
        department: selectedDepartment.value!.label,
        // Only send password if the admin typed one
        password:   pw.isNotEmpty ? pw : null,
      );

      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Auditor updated successfully');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Update failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}