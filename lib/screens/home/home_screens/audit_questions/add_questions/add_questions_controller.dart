import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class AddQuestionController extends GetxController {
  final AuditFormsApi _api = AuditFormsApi();

  // Set externally before showing dialog
  late final String formId;
  late final String formTitle;

  final questionTextController = TextEditingController();
  var selectedType    = QuestionType.rating.obs;
  var isRequired      = true.obs;
  var isCreating      = false.obs;

  // MCQ options — only shown when type is mcq
  RxList<TextEditingController> optionControllers = <TextEditingController>[].obs;

  // Field errors
  var questionError = ''.obs;
  var optionsError  = ''.obs;

  void init({required String formId, required String formTitle}) {
    this.formId    = formId;
    this.formTitle = formTitle;
    // Start with 2 option fields if MCQ is selected by default
  }

  void addOptionField() {
    optionControllers.add(TextEditingController());
  }

  void removeOptionField(int index) {
    if (optionControllers.length > 2) {
      optionControllers[index].dispose();
      optionControllers.removeAt(index);
    }
  }

  void onTypeChanged(QuestionType? type) {
    if (type == null) return;
    selectedType.value = type;
    // Auto-populate 2 option fields when switching to MCQ
    if (type == QuestionType.mcq && optionControllers.isEmpty) {
      optionControllers.addAll([
        TextEditingController(),
        TextEditingController(),
      ]);
    }
    // Clear options error when switching away from MCQ
    if (type != QuestionType.mcq) optionsError.value = '';
  }

  bool _validate() {
    bool valid = true;

    if (questionTextController.text.trim().isEmpty) {
      questionError.value = 'Question text is required'; valid = false;
    } else { questionError.value = ''; }

    if (selectedType.value == QuestionType.mcq) {
      final filled = optionControllers.where((c) => c.text.trim().isNotEmpty).length;
      if (filled < 2) {
        optionsError.value = 'MCQ requires at least 2 options'; valid = false;
      } else { optionsError.value = ''; }
    }

    return valid;
  }

  Future<void> createQuestion() async {
    if (!_validate()) return;
    try {
      isCreating.value = true;

      List<String>? options;
      if (selectedType.value == QuestionType.mcq) {
        options = optionControllers
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList();
      }

      final res = await _api.addQuestion(
        formId:       formId,
        questionText: questionTextController.text.trim(),
        questionType: selectedType.value.apiValue,
        options:      options,
        isRequired:   isRequired.value,
      );

      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Question added successfully');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Add failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    questionTextController.dispose();
    for (final c in optionControllers) { c.dispose(); }
    super.onClose();
  }
}