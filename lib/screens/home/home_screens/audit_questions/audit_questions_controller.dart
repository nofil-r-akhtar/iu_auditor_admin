import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_form.dart';

class AuditQuestionsController extends GetxController {
  final AuditFormsApi _api = AuditFormsApi();

  /// Department filter tabs — "All Departments" + every Department enum label
  RxList<String> departments = <String>[
    'All Departments',
    ...Department.values.map((d) => d.label),
  ].obs;

  var selectedDepartment = 'All Departments'.obs;

  final RxList<Map<String, dynamic>> _allQuestions =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> questions =
      <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFormsAndQuestions();
  }

  Future<void> fetchFormsAndQuestions() async {
    try {
      isLoading.value = true;

      final formsResp = await _api.getAllForms();
      if (!formsResp.success) {
        Get.snackbar('Error', formsResp.message);
        return;
      }

      final allQ = <Map<String, dynamic>>[];

      for (final form in formsResp.data) {
        final qResp = await _api.getQuestions(form.id);
        if (!qResp.success) continue;
        for (final q in qResp.data) {
          allQ.add(_toViewMap(q, form));
        }
      }

      _allQuestions.assignAll(allQ);

      // Always driven by the Department enum — fixed DB enum values
      departments.assignAll([
        'All Departments',
        ...Department.values.map((d) => d.label),
      ]);

      _applyFilter();
    } catch (e) {
      debugPrint('Fetch forms/questions error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _toViewMap(AuditQuestion q, AuditForm form) => {
    'id':         q.id,
    'formId':     form.id,
    'question':   q.questionText,
    'category':   form.title,
    'type':       q.typeLabel,
    'department': form.department,
    'isRequired': q.isRequired,
  };

  void changeDepartment(String dept) {
    selectedDepartment.value = dept;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedDepartment.value == 'All Departments') {
      questions.assignAll(_allQuestions);
    } else {
      questions.assignAll(
        _allQuestions
            .where((q) => q['department'] == selectedDepartment.value)
            .toList(),
      );
    }
  }

  Future<void> deleteQuestion(String formId, String questionId) async {
    try {
      final res = await _api.deleteQuestion(
          formId: formId, questionId: questionId);
      if (res['success'] == true) {
        _allQuestions.removeWhere((q) => q['id'] == questionId);
        _applyFilter();
        Get.snackbar('Success', 'Question deleted');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> addQuestion({
    required String formId,
    required String questionText,
    required String questionType,
    List<String>? options,
    bool isRequired = true,
  }) async {
    try {
      final res = await _api.addQuestion(
        formId: formId,
        questionText: questionText,
        questionType: questionType,
        options: options,
        isRequired: isRequired,
      );
      if (res['success'] == true) {
        await fetchFormsAndQuestions();
        Get.snackbar('Success', 'Question added');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Add failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}