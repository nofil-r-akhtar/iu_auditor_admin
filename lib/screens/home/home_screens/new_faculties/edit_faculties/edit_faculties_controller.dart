import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/new_faculty/new_faculty_apis.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/new_faculty/fetch_new_faculty.dart';

class EditFacultiesController extends GetxController {
  final NewFacultyApis _api = NewFacultyApis();

  // ── Readonly display fields ──────────────────────────────
  late final String teacherId;
  late final String readonlyName;
  late final String readonlyEmail;
  late final String readonlyContact;

  // ── Editable fields ──────────────────────────────────────
  final specializationController = TextEditingController();
  final Rx<Department?> selectedDepartment = Rx<Department?>(null);
  final auditDate = Rx<DateTime?>(null);
  final auditTime = Rx<TimeOfDay?>(null);
  var isUpdating = false.obs;

  // ── Field errors ─────────────────────────────────────────
  var specializationError = ''.obs;
  var departmentError     = ''.obs;

  /// Pre-fill all fields from the existing teacher record
  void initFromTeacher(NewFaculty teacher) {
    teacherId       = teacher.id;
    readonlyName    = teacher.name;
    readonlyEmail   = teacher.email;
    readonlyContact = teacher.contactNo;

    specializationController.text = teacher.specialization;
    selectedDepartment.value = Department.fromLabel(teacher.department);

    if (teacher.auditDate != null && teacher.auditDate!.isNotEmpty) {
      try { auditDate.value = DateTime.parse(teacher.auditDate!); } catch (_) {}
    }
    if (teacher.auditTime != null && teacher.auditTime!.isNotEmpty) {
      try {
        final parts = teacher.auditTime!.split(':');
        auditTime.value = TimeOfDay(
          hour:   int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      } catch (_) {}
    }
  }

  bool _validate() {
    bool valid = true;
    if (specializationController.text.trim().isEmpty) {
      specializationError.value = 'Specialization is required'; valid = false;
    } else { specializationError.value = ''; }
    if (selectedDepartment.value == null) {
      departmentError.value = 'Please select a department'; valid = false;
    } else { departmentError.value = ''; }
    return valid;
  }

  Future<void> updateTeacher() async {
    if (!_validate()) return;
    try {
      isUpdating.value = true;

      final params = <String, dynamic>{
        'department':     selectedDepartment.value!.label,
        'specialization': specializationController.text.trim(),
      };

      if (auditDate.value != null) {
        final d = auditDate.value!;
        params['audit_date'] =
            '${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
      }
      if (auditTime.value != null) {
        final t = auditTime.value!;
        params['audit_time'] =
            '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}:00';
      }

      final response = await _api.updateTeacher(id: teacherId, params: params);

      if (response['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Teacher updated successfully');
      } else {
        Get.snackbar('Error', response['message'] ?? 'Update failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    specializationController.dispose();
    super.onClose();
  }
}