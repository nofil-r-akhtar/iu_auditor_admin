import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class AddLecturerController extends GetxController {
  final AdminApi _api = AdminApi();

  final nameController     = TextEditingController();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  final Rx<Department?> selectedDepartment = Rx<Department?>(null);

  // role is always senior_lecturer — no need for the user to select it
  final UserRole role = UserRole.seniorLecturer;

  var isCreating = false.obs;
  var isPasswordHidden = true.obs;

  // Field errors
  var nameError       = ''.obs;
  var emailError      = ''.obs;
  var passwordError   = ''.obs;
  var departmentError = ''.obs;

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

    if (selectedDepartment.value == null) {
      departmentError.value = 'Please select a department'; valid = false;
    } else { departmentError.value = ''; }

    return valid;
  }

  Future<void> createLecturer() async {
    if (!_validate()) return;
    try {
      isCreating.value = true;
      final res = await _api.createUser(
        name:       nameController.text.trim(),
        email:      emailController.text.trim(),
        password:   passwordController.text.trim(),
        role:       role.apiValue,             // always 'senior_lecturer'
        department: selectedDepartment.value!.label,
      );
      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Auditor created successfully');
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