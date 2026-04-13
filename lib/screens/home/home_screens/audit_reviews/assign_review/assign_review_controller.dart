import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/apis/audit/audit_reviews_api.dart';
import 'package:iu_auditor_admin/apis/new_faculty/new_faculty_apis.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_form.dart';
import 'package:iu_auditor_admin/modal_class/new_faculty/fetch_new_faculty.dart';

class AssignReviewController extends GetxController {
  final AuditReviewsApi _reviewsApi = AuditReviewsApi();
  final NewFacultyApis _teachersApi = NewFacultyApis();
  final AuditFormsApi  _formsApi   = AuditFormsApi();

  final notesController = TextEditingController();

  // Dropdowns
  RxList<NewFaculty>  teachers     = <NewFaculty>[].obs;
  RxList<AuditForm>   forms        = <AuditForm>[].obs;
  RxList<AuditForm>   filteredForms = <AuditForm>[].obs;

  final Rx<NewFaculty?> selectedTeacher = Rx<NewFaculty?>(null);
  final Rx<AuditForm?>  selectedForm    = Rx<AuditForm?>(null);

  var isLoadingData = false.obs;
  var isCreating    = false.obs;

  // Errors
  var teacherError = ''.obs;
  var formError    = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      isLoadingData.value = true;
      final tRes = await _teachersApi.getAllTeachers();
      final fRes = await _formsApi.getAllForms();
      if (tRes.success) teachers.assignAll(tRes.data);
      if (fRes.success) forms.assignAll(fRes.data);
      filteredForms.assignAll(forms);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingData.value = false;
    }
  }

  void onTeacherChanged(NewFaculty? teacher) {
    selectedTeacher.value = teacher;
    selectedForm.value    = null;
    teacherError.value    = '';

    // Filter forms by teacher's department
    if (teacher != null && teacher.department.isNotEmpty) {
      filteredForms.assignAll(
        forms.where((f) => f.department == teacher.department).toList(),
      );
    } else {
      filteredForms.assignAll(forms);
    }
  }

  bool _validate() {
    bool valid = true;
    if (selectedTeacher.value == null) {
      teacherError.value = 'Please select a teacher'; valid = false;
    } else { teacherError.value = ''; }
    if (selectedForm.value == null) {
      formError.value = 'Please select an audit form'; valid = false;
    } else { formError.value = ''; }
    return valid;
  }

  Future<void> assignReview() async {
    if (!_validate()) return;
    try {
      isCreating.value = true;
      final res = await _reviewsApi.createReview(
        teacherId: selectedTeacher.value!.id,
        formId:    selectedForm.value!.id,
        notes:     notesController.text.trim(),
      );
      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Audit review assigned successfully');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Failed to assign review');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}