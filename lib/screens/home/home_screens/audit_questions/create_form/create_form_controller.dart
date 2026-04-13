import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class CreateFormController extends GetxController {
  final AuditFormsApi _api = AuditFormsApi();

  final titleController       = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<Department?> selectedDepartment = Rx<Department?>(null);
  var isCreating = false.obs;

  // The departments that already have a form — passed in before dialog opens
  // so we can exclude them from the dropdown
  List<String> existingDepartments = [];

  // Field errors
  var titleError      = ''.obs;
  var departmentError = ''.obs;

  /// Departments still available (no form created yet)
  List<Department> get availableDepartments => Department.values
      .where((d) => !existingDepartments.contains(d.label))
      .toList();

  bool _validate() {
    bool valid = true;

    if (titleController.text.trim().isEmpty) {
      titleError.value = 'Form title is required'; valid = false;
    } else { titleError.value = ''; }

    if (selectedDepartment.value == null) {
      departmentError.value = 'Please select a department'; valid = false;
    } else { departmentError.value = ''; }

    return valid;
  }

  Future<void> createForm() async {
    if (!_validate()) return;
    try {
      isCreating.value = true;
      final res = await _api.createForm(
        title:       titleController.text.trim(),
        department:  selectedDepartment.value!.label,
        description: descriptionController.text.trim().isEmpty
            ? null
            : descriptionController.text.trim(),
      );
      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Audit form created successfully');
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
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}