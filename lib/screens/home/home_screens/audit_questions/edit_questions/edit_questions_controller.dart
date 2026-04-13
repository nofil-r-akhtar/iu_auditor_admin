import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_forms_api.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class EditQuestionController extends GetxController {
  final AuditFormsApi _api = AuditFormsApi();

  late final String formId;
  late final String questionId;
  late final String formTitle;

  final questionTextController = TextEditingController();
  var selectedType = QuestionType.rating.obs;
  var isRequired   = true.obs;
  var isUpdating   = false.obs;

  RxList<TextEditingController> optionControllers = <TextEditingController>[].obs;

  var questionError = ''.obs;
  var optionsError  = ''.obs;

  void initFromQuestion({
    required String formId,
    required String questionId,
    required String formTitle,
    required String questionText,
    required String questionType,
    required bool isRequired,
    required List<String> options,
  }) {
    this.formId     = formId;
    this.questionId = questionId;
    this.formTitle  = formTitle;

    questionTextController.text = questionText;
    selectedType.value = QuestionType.fromApiValue(questionType);
    this.isRequired.value = isRequired;

    // Pre-fill MCQ options
    optionControllers.clear();
    if (selectedType.value == QuestionType.mcq && options.isNotEmpty) {
      for (final opt in options) {
        optionControllers.add(TextEditingController(text: opt));
      }
    } else if (selectedType.value == QuestionType.mcq) {
      optionControllers.addAll([
        TextEditingController(),
        TextEditingController(),
      ]);
    }
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
    if (type == QuestionType.mcq && optionControllers.isEmpty) {
      optionControllers.addAll([
        TextEditingController(),
        TextEditingController(),
      ]);
    }
    if (type != QuestionType.mcq) optionsError.value = '';
  }

  bool _validate() {
    bool valid = true;
    if (questionTextController.text.trim().isEmpty) {
      questionError.value = 'Question text is required'; valid = false;
    } else { questionError.value = ''; }

    if (selectedType.value == QuestionType.mcq) {
      final filled = optionControllers
          .where((c) => c.text.trim().isNotEmpty).length;
      if (filled < 2) {
        optionsError.value = 'MCQ requires at least 2 options'; valid = false;
      } else { optionsError.value = ''; }
    }
    return valid;
  }

  Future<void> updateQuestion() async {
    if (!_validate()) return;
    try {
      isUpdating.value = true;

      List<String>? options;
      if (selectedType.value == QuestionType.mcq) {
        options = optionControllers
            .map((c) => c.text.trim())
            .where((t) => t.isNotEmpty)
            .toList();
      }

      final res = await _api.updateQuestion(
        formId:       formId,
        questionId:   questionId,
        questionText: questionTextController.text.trim(),
        questionType: selectedType.value.apiValue,
        options:      options,
        isRequired:   isRequired.value,
      );

      if (res['success'] == true) {
        Get.back();
        Get.snackbar('Success', 'Question updated successfully');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Update failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  @override
  void onClose() {
    questionTextController.dispose();
    for (final c in optionControllers) { c.dispose(); }
    super.onClose();
  }
}