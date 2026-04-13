import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'create_form_controller.dart';

class CreateFormDialog extends StatelessWidget {
  const CreateFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CreateFormController>();

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Form Title ─────────────────────────────────────
        _field(context, 'Form Title',
          AppTextField(
            textController: c.titleController,
            placeholder: 'e.g. Computer Science Audit Form',
            placeholderColor: hintTextColor,
            isError: c.titleError.value.isNotEmpty,
            errorText: c.titleError.value,
          ),
        ),
        const SizedBox(height: 16),

        // ── Department Dropdown ────────────────────────────
        _field(context, 'Department',
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: c.departmentError.value.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.2)
                      : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Department>(
                    isExpanded: true,
                    value: c.selectedDepartment.value,
                    hint: c.availableDepartments.isEmpty
                        ? AppTextRegular(
                            text: 'All departments have forms',
                            color: hintTextColor,
                            fontSize: 13,
                          )
                        : AppTextRegular(
                            text: 'Select Department',
                            color: hintTextColor,
                            fontSize: 13,
                          ),
                    items: c.availableDepartments.map((d) =>
                      DropdownMenuItem<Department>(
                        value: d,
                        child: AppTextRegular(text: d.label, fontSize: 13),
                      ),
                    ).toList(),
                    onChanged: c.availableDepartments.isEmpty
                        ? null
                        : (d) {
                            c.selectedDepartment.value = d;
                            c.departmentError.value = '';
                          },
                  ),
                ),
              ),
              if (c.departmentError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(c.departmentError.value,
                      style: const TextStyle(
                          color: Colors.red, fontSize: 11)),
                ),
              // Info — shows which depts already have forms
              if (c.existingDepartments.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.info_outline,
                      size: 13, color: Colors.grey),
                  const SizedBox(width: 5),
                  Flexible(
                    child: AppTextRegular(
                      text:
                          'Already have forms: ${c.existingDepartments.join(', ')}',
                      color: descriptiveColor,
                      fontSize: 11,
                    ),
                  ),
                ]),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Description (optional) ─────────────────────────
        _field(context, 'Description (optional)',
          AppTextField(
            textController: c.descriptionController,
            placeholder: 'Brief description of this audit form...',
            placeholderColor: hintTextColor,
            minLine: 2,
            maxLine: 3,
          ),
        ),
      ],
    ));
  }

  Widget _field(BuildContext context, String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextSemiBold(
          text: label,
          color: Theme.of(context).primaryColor,
          fontSize: 13,
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}