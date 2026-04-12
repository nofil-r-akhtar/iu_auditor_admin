import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';

/// Roles allowed to be created from the User Management panel.
/// senior_lecturer is managed from the Senior Lecturers panel instead.
const List<UserRole> kManageableRoles = [
  UserRole.superAdmin,
  UserRole.admin,
  UserRole.departmentHead,
];

class AddUserController extends GetxController {
  final AdminApi _api = AdminApi();

  final nameController     = TextEditingController();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final Rx<UserRole?>    selectedRole       = Rx<UserRole?>(null);
  final Rx<Department?>  selectedDepartment = Rx<Department?>(null);

  var isCreating = false.obs;

  // errors
  var nameError       = ''.obs;
  var emailError      = ''.obs;
  var passwordError   = ''.obs;
  var roleError       = ''.obs;
  var departmentError = ''.obs;

  /// Department is only required for department_head
  bool get requiresDepartment =>
      selectedRole.value == UserRole.departmentHead;

  bool _validate() {
    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Name is required'; valid = false;
    } else { nameError.value = ''; }

    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required'; valid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email'; valid = false;
    } else { emailError.value = ''; }

    if (passwordController.text.trim().length < 6) {
      passwordError.value = 'Password must be at least 6 characters'; valid = false;
    } else { passwordError.value = ''; }

    if (selectedRole.value == null) {
      roleError.value = 'Please select a role'; valid = false;
    } else { roleError.value = ''; }

    if (requiresDepartment && selectedDepartment.value == null) {
      departmentError.value = 'Department is required for Department Head'; valid = false;
    } else { departmentError.value = ''; }

    return valid;
  }

  Future<void> createUser() async {
    if (!_validate()) return;
    try {
      isCreating.value = true;
      final res = await _api.createUser(
        name:       nameController.text.trim(),
        email:      emailController.text.trim(),
        password:   passwordController.text.trim(),
        role:       selectedRole.value!.apiValue,
        department: requiresDepartment
            ? selectedDepartment.value?.label
            : null,
      );
      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'User created successfully');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Create failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}