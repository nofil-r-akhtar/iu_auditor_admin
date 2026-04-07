import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/new_faculty/new_faculty_apis.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class CreateFacultiesController extends GetxController {
  final NewFacultyApis _api = NewFacultyApis();

  // ── Form fields ──────────────────────────────────────────
  final fullNameController       = TextEditingController();
  final emailController          = TextEditingController();
  final contactController        = TextEditingController();
  final specializationController = TextEditingController();

  /// Typed Department enum — null means nothing selected yet
  final Rx<Department?> selectedDepartment = Rx<Department?>(null);

  final auditDate = Rx<DateTime?>(null);
  final auditTime = Rx<TimeOfDay?>(null);
  var isCreating  = false.obs;

  // ── Field errors ─────────────────────────────────────────
  var fullNameError       = ''.obs;
  var emailError          = ''.obs;
  var contactError        = ''.obs;
  var specializationError = ''.obs;
  var departmentError     = ''.obs;
  var dateError           = ''.obs;

  bool _validate() {
    bool valid = true;

    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required'; valid = false;
    } else { fullNameError.value = ''; }

    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required'; valid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email'; valid = false;
    } else { emailError.value = ''; }

    if (contactController.text.trim().isEmpty) {
      contactError.value = 'Contact is required'; valid = false;
    } else { contactError.value = ''; }

    if (specializationController.text.trim().isEmpty) {
      specializationError.value = 'Specialization is required'; valid = false;
    } else { specializationError.value = ''; }

    if (selectedDepartment.value == null) {
      departmentError.value = 'Please select a department'; valid = false;
    } else { departmentError.value = ''; }

    if (auditDate.value == null) {
      dateError.value = 'Audit date is required'; valid = false;
    } else { dateError.value = ''; }

    return valid;
  }

  Future<void> createTeacher() async {
    if (!_validate()) return;
    try {
      isCreating.value = true;

      final d = auditDate.value!;
      final formattedDate =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

      String? formattedTime;
      if (auditTime.value != null) {
        final t = auditTime.value!;
        formattedTime =
            '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';
      }

      final response = await _api.createTeacher(params: {
        'name':           fullNameController.text.trim(),
        'email':          emailController.text.trim(),
        'contact_no':     contactController.text.trim(),
        'department':     selectedDepartment.value!.label, // sends exact DB string
        'specialization': specializationController.text.trim(),
        'audit_date':     formattedDate,
        if (formattedTime != null) 'audit_time': formattedTime,
        'status':         'pending',
      });

      if (response['success'] == true) {
        Get.snackbar('Success', 'Faculty created successfully');
        _clearForm();
        Get.back();
      } else {
        Get.snackbar('Error', response['message'] ?? 'Create failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  void _clearForm() {
    fullNameController.clear();
    emailController.clear();
    contactController.clear();
    specializationController.clear();
    selectedDepartment.value = null;
    auditDate.value          = null;
    auditTime.value          = null;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    contactController.dispose();
    specializationController.dispose();
    super.onClose();
  }
}