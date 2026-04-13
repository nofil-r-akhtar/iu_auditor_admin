import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/components/app_dialog.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_form.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/add_questions/add_questions.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/add_questions/add_questions_controller.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/edit_questions/edit_questions.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/edit_questions/edit_questions_controller.dart';

import 'create_form/create_form.dart';
import 'create_form/create_form_controller.dart';


class AuditQuestionsController extends GetxController {
  final AuditFormsApi _api = AuditFormsApi();

  /// Tabs — only departments that have a form in the DB
  /// Driven dynamically; starts empty until fetch completes
  RxList<String> departments = <String>[].obs;
  var selectedDepartment     = ''.obs;

  final RxList<Map<String, dynamic>> _allQuestions =
      <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> questions =
      <Map<String, dynamic>>[].obs;

  /// form_id lookup by department label
  final Map<String, AuditForm> _formByDepartment = {};

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFormsAndQuestions();
  }

  // ── FETCH ──────────────────────────────────────────────────
  Future<void> fetchFormsAndQuestions() async {
    try {
      isLoading.value = true;
      _formByDepartment.clear();

      final formsResp = await _api.getAllForms();
      if (!formsResp.success) {
        Get.snackbar('Error', formsResp.message);
        return;
      }

      final allQ      = <Map<String, dynamic>>[];
      final deptTabs  = <String>[];

      for (final form in formsResp.data) {
        _formByDepartment[form.department] = form;
        deptTabs.add(form.department);

        final qResp = await _api.getQuestions(form.id);
        if (!qResp.success) continue;
        for (final q in qResp.data) {
          allQ.add(_toViewMap(q, form));
        }
      }

      _allQuestions.assignAll(allQ);

      // Tabs — only departments that have forms, in DB enum order
      final orderedTabs = Department.values
          .map((d) => d.label)
          .where((label) => deptTabs.contains(label))
          .toList();
      departments.assignAll(orderedTabs);

      // Auto-select: keep current if still valid, else first tab
      if (orderedTabs.isNotEmpty) {
        if (!orderedTabs.contains(selectedDepartment.value)) {
          selectedDepartment.value = orderedTabs.first;
        }
      } else {
        selectedDepartment.value = '';
      }

      _applyFilter();
    } catch (e) {
      debugPrint('Fetch forms/questions error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _toViewMap(AuditQuestion q, AuditForm form) => {
    'id':           q.id,
    'formId':       form.id,
    'formTitle':    form.title,
    'question':     q.questionText,
    'questionType': q.questionType,
    'category':     form.title,
    'type':         q.typeLabel,
    'department':   form.department,
    'isRequired':   q.isRequired,
    'options':      q.options,
  };

  void changeDepartment(String dept) {
    selectedDepartment.value = dept;
    _applyFilter();
  }

  void _applyFilter() {
    questions.assignAll(
      _allQuestions
          .where((q) => q['department'] == selectedDepartment.value)
          .toList(),
    );
  }

  // ── CREATE FORM ────────────────────────────────────────────
  void openCreateFormDialog() {
    final ctrl = Get.put(CreateFormController());
    // Pass existing departments so they're excluded from the dropdown
    ctrl.existingDepartments =
        departments.toList(); // current tabs = existing forms

    AppDialog.show(
      title: 'Create Audit Form',
      content: const CreateFormDialog(),
      confirmText: 'Create Form',
      onConfirm: () async {
        final dept = ctrl.selectedDepartment.value;
        await ctrl.createForm();
        await fetchFormsAndQuestions();
        // Auto-select the newly created department tab
        if (dept != null && departments.contains(dept.label)) {
          selectedDepartment.value = dept.label;
          _applyFilter();
        }
        Get.delete<CreateFormController>();
      },
      onCancel: () {
        Get.back();
        Get.delete<CreateFormController>();
      },
    );
  }

  // ── ADD QUESTION ───────────────────────────────────────────
  void openAddDialog() {
    if (selectedDepartment.value.isEmpty) {
      Get.snackbar('No Department Selected',
          'Create a form for a department first.');
      return;
    }
    final form = _formByDepartment[selectedDepartment.value];
    if (form == null) {
      Get.snackbar('No Form',
          'No audit form for "${selectedDepartment.value}". Create one first.');
      return;
    }

    final addCtrl = Get.put(AddQuestionController());
    addCtrl.init(formId: form.id, formTitle: form.title);

    AppDialog.show(
      title: 'Add Question',
      content: const AddQuestion(),
      confirmText: 'Add Question',
      onConfirm: () async {
        await addCtrl.createQuestion();
        await fetchFormsAndQuestions();
        Get.delete<AddQuestionController>();
      },
      onCancel: () {
        Get.back();
        Get.delete<AddQuestionController>();
      },
    );
  }

  // ── EDIT QUESTION ──────────────────────────────────────────
  void openEditDialog(Map<String, dynamic> item) {
    final questionId = item['id'] as String;
    final editCtrl = Get.put(EditQuestionController(), tag: questionId);
    editCtrl.initFromQuestion(
      formId:       item['formId'] as String,
      questionId:   questionId,
      formTitle:    item['formTitle'] as String? ?? '',
      questionText: item['question'] as String,
      questionType: item['questionType'] as String,
      isRequired:   item['isRequired'] as bool,
      options:      List<String>.from(item['options'] as List? ?? []),
    );

    AppDialog.show(
      title: 'Edit Question',
      content: EditQuestion(tag: questionId),
      confirmText: 'Save Changes',
      onConfirm: () async {
        await Get.find<EditQuestionController>(tag: questionId)
            .updateQuestion();
        await fetchFormsAndQuestions();
        Get.delete<EditQuestionController>(tag: questionId);
      },
      onCancel: () {
        Get.back();
        Get.delete<EditQuestionController>(tag: questionId);
      },
    );
  }

  // ── DELETE QUESTION ────────────────────────────────────────
  void confirmDelete(Map<String, dynamic> item) {
    AppDialog.showDeleteConfirm(
      teacherName: item['question'] as String? ?? 'this question',
      onConfirm: () => _performDelete(
          item['formId'] as String, item['id'] as String),
    );
  }

  Future<void> _performDelete(String formId, String questionId) async {
    try {
      final res =
          await _api.deleteQuestion(formId: formId, questionId: questionId);
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
}