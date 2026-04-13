import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/add_questions/add_questions_controller.dart';

class AddQuestion extends StatelessWidget {
  const AddQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddQuestionController>();

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Form context badge ─────────────────────────────
        AppContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: BorderRadius.circular(8),
          bgColor: const Color(0xFFEFF6FF),
          child: Row(children: [
            const Icon(Icons.folder_outlined, size: 15, color: primaryColor),
            const SizedBox(width: 8),
            AppTextMedium(
              text: 'Adding to: ${c.formTitle}',
              color: primaryColor,
              fontSize: 12,
            ),
          ]),
        ),
        const SizedBox(height: 16),

        // ── Question Text ──────────────────────────────────
        AppTextSemiBold(
          text: 'Question',
          color: Theme.of(context).primaryColor,
          fontSize: 13,
        ),
        const SizedBox(height: 6),
        AppTextField(
          textController: c.questionTextController,
          placeholder: 'e.g. How effectively does the teacher explain concepts?',
          placeholderColor: hintTextColor,
          minLine: 2,
          maxLine: 4,
          isError: c.questionError.value.isNotEmpty,
          errorText: c.questionError.value,
        ),
        const SizedBox(height: 16),

        // ── Question Type + Is Required ────────────────────
        Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextSemiBold(
                text: 'Question Type',
                color: Theme.of(context).primaryColor,
                fontSize: 13,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<QuestionType>(
                    isExpanded: true,
                    value: c.selectedType.value,
                    items: QuestionType.values.map((t) => DropdownMenuItem(
                      value: t,
                      child: AppTextRegular(text: t.displayLabel, fontSize: 13),
                    )).toList(),
                    onChanged: c.onTypeChanged,
                  ),
                ),
              ),
            ],
          )),
          const SizedBox(width: 16),

          // ── Is Required toggle ─────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextSemiBold(
                text: 'Required',
                color: Theme.of(context).primaryColor,
                fontSize: 13,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => c.isRequired.value = !c.isRequired.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 30,
                  decoration: BoxDecoration(
                    color: c.isRequired.value ? primaryColor : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: c.isRequired.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
        const SizedBox(height: 16),

        // ── MCQ Options — only shown when type is MCQ ──────
        if (c.selectedType.value == QuestionType.mcq) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextSemiBold(
                text: 'Options',
                color: Theme.of(context).primaryColor,
                fontSize: 13,
              ),
              TextButton.icon(
                onPressed: c.addOptionField,
                icon: const Icon(Icons.add, size: 16, color: primaryColor),
                label: AppTextMedium(
                  text: 'Add Option',
                  color: primaryColor,
                  fontSize: 12,
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...List.generate(c.optionControllers.length, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              AppContainer(
                padding: const EdgeInsets.all(6),
                borderRadius: BorderRadius.circular(6),
                bgColor: bgColor,
                child: AppTextRegular(
                  text: '${i + 1}',
                  fontSize: 12,
                  color: descriptiveColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  textController: c.optionControllers[i],
                  placeholder: 'Option ${i + 1}',
                  placeholderColor: hintTextColor,
                ),
              ),
              if (c.optionControllers.length > 2) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => c.removeOptionField(i),
                  child: const Icon(Icons.remove_circle_outline,
                      color: Colors.red, size: 20),
                ),
              ],
            ]),
          )),
          if (c.optionsError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Text(c.optionsError.value,
                  style: const TextStyle(color: Colors.red, fontSize: 11)),
            ),
        ],
      ],
    ));
  }
}