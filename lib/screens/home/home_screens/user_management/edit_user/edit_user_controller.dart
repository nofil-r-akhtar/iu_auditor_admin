import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';

class EditUserController extends GetxController {
  final AdminApi _api = AdminApi();

  // Readonly
  late final String userId;
  late final String readonlyEmail;

  // Editable
  final nameController     = TextEditingController();
  final passwordController = TextEditingController();

  final Rx<UserRole?>   selectedRole       = Rx<UserRole?>(null);
  final Rx<Department?> selectedDepartment = Rx<Department?>(null);

  var isUpdating = false.obs;

  // errors
  var nameError       = ''.obs;
  var passwordError   = ''.obs;
  var roleError       = ''.obs;
  var departmentError = ''.obs;

  bool get requiresDepartment =>
      selectedRole.value == UserRole.departmentHead;

  void initFromUser(AdminUser user) {
    userId          = user.id;
    readonlyEmail   = user.email;
    nameController.text = user.name;
    selectedRole.value  = UserRole.fromApiValue(user.role);
    selectedDepartment.value = Department.fromLabel(user.department ?? '');
    passwordController.clear();
  }

  bool _validate() {
    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required'; valid = false;
    } else { nameError.value = ''; }

    if (selectedRole.value == null) {
      roleError.value = 'Please select a role'; valid = false;
    } else { roleError.value = ''; }

    if (requiresDepartment && selectedDepartment.value == null) {
      departmentError.value = 'Department required for Department Head'; valid = false;
    } else { departmentError.value = ''; }

    final pw = passwordController.text.trim();
    if (pw.isNotEmpty && pw.length < 6) {
      passwordError.value = 'Password must be at least 6 characters'; valid = false;
    } else { passwordError.value = ''; }

    return valid;
  }

  Future<void> updateUser() async {
    if (!_validate()) return;
    try {
      isUpdating.value = true;
      final pw = passwordController.text.trim();
      final res = await _api.updateUser(
        id:         userId,
        name:       nameController.text.trim(),
        role:       selectedRole.value!.apiValue,
        department: requiresDepartment
            ? selectedDepartment.value?.label
            : null,
        password:   pw.isNotEmpty ? pw : null,
      );
      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'User updated successfully');
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