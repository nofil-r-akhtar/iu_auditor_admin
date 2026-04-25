import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/admin/admin_api.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/apis/audit/audit_reviews_api.dart';
import 'package:iu_auditor_admin/apis/new_faculty/new_faculty_apis.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_form.dart';
import 'package:iu_auditor_admin/modal_class/new_faculty/fetch_new_faculty.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';

class AssignReviewController extends GetxController {
  final AuditReviewsApi _reviewsApi = AuditReviewsApi();
  final NewFacultyApis  _teachersApi = NewFacultyApis();
  final AuditFormsApi   _formsApi    = AuditFormsApi();
  final AdminApi        _adminApi    = AdminApi();

  final notesController = TextEditingController();

  // ── Dropdown data ────────────────────────────────────────
  RxList<NewFaculty> teachers          = <NewFaculty>[].obs;
  RxList<AuditForm>  forms             = <AuditForm>[].obs;
  RxList<AuditForm>  filteredForms     = <AuditForm>[].obs;
  RxList<AdminUser>  seniorLecturers   = <AdminUser>[].obs;
  RxList<AdminUser>  filteredLecturers = <AdminUser>[].obs;

  final Rx<NewFaculty?> selectedTeacher  = Rx<NewFaculty?>(null);
  final Rx<AuditForm?>  selectedForm     = Rx<AuditForm?>(null);
  final Rx<AdminUser?>  selectedLecturer = Rx<AdminUser?>(null);

  var isLoadingData = false.obs;
  var isCreating    = false.obs;

  // ── Errors ───────────────────────────────────────────────
  var teacherError  = ''.obs;
  var formError     = ''.obs;
  var lecturerError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      isLoadingData.value = true;

      // Fire all 3 requests in parallel — each future keeps its own type
      // (Future.wait erases types to List<Object>, hence we await separately)
      final tFuture = _teachersApi.getAllTeachers();
      final fFuture = _formsApi.getAllForms();
      final lFuture = _adminApi.getSeniorLecturers();

      final tRes = await tFuture;
      final fRes = await fFuture;
      final lRes = await lFuture;

      if (tRes.success) teachers.assignAll(tRes.data);
      if (fRes.success) forms.assignAll(fRes.data);
      if (lRes.success) seniorLecturers.assignAll(lRes.data);

      filteredForms.assignAll(forms);
      filteredLecturers.assignAll(seniorLecturers);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingData.value = false;
    }
  }

  /// When teacher changes — re-filter both forms AND senior lecturers
  /// to only those matching the teacher's department.
  void onTeacherChanged(NewFaculty? teacher) {
    selectedTeacher.value  = teacher;
    selectedForm.value     = null;
    selectedLecturer.value = null;
    teacherError.value     = '';
    formError.value        = '';
    lecturerError.value    = '';

    if (teacher != null && teacher.department.isNotEmpty) {
      // Forms with matching department
      filteredForms.assignAll(
        forms.where((f) => f.department == teacher.department).toList(),
      );
      // Senior lecturers with matching department
      filteredLecturers.assignAll(
        seniorLecturers.where((l) =>
            (l.department ?? '') == teacher.department).toList(),
      );
    } else {
      filteredForms.assignAll(forms);
      filteredLecturers.assignAll(seniorLecturers);
    }
  }

  bool _validate() {
    bool valid = true;

    if (selectedTeacher.value == null) {
      teacherError.value = 'Please select a teacher'; valid = false;
    } else { teacherError.value = ''; }

    if (selectedLecturer.value == null) {
      lecturerError.value = 'Please select a senior lecturer'; valid = false;
    } else { lecturerError.value = ''; }

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
        teacherId:  selectedTeacher.value!.id,
        formId:     selectedForm.value!.id,
        reviewedBy: selectedLecturer.value!.id,   // 🔑 send the lecturer ID
        notes:      notesController.text.trim(),
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