import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/edit_faculties/edit_faculties_controller.dart';

class EditFaculties extends StatelessWidget {
  /// Tag must match the one used in Get.put(..., tag: teacher.id)
  final String tag;
  const EditFaculties({required this.tag, super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find with the tag so the correct instance is always resolved
    final controller = Get.find<EditFacultiesController>(tag: tag);

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Name + Email (READ-ONLY) ───────────────────────
        Row(children: [
          Expanded(child: _readonlyField(
            context: context,
            label: 'Full Name',
            value: controller.readonlyName,
          )),
          const SizedBox(width: 16),
          Expanded(child: _readonlyField(
            context: context,
            label: 'Email',
            value: controller.readonlyEmail,
          )),
        ]),
        const SizedBox(height: 16),

        // ── Contact No (READ-ONLY) + Specialization (EDITABLE) ──
        Row(children: [
          Expanded(child: _readonlyField(
            context: context,
            label: 'Contact No',
            value: controller.readonlyContact,
          )),
          const SizedBox(width: 16),
          Expanded(child: _editableField(
            context: context,
            label: 'Specialization',
            child: AppTextField(
              textController: controller.specializationController,
              placeholder: 'e.g. AI/ML',
              placeholderColor: hintTextColor,
              isError: controller.specializationError.value.isNotEmpty,
              errorText: controller.specializationError.value,
            ),
          )),
        ]),
        const SizedBox(height: 16),

        // ── Department Dropdown (EDITABLE) ────────────────
        AppTextSemiBold(
          text: 'Department',
          color: Theme.of(context).primaryColor,
          fontSize: 13,
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: controller.departmentError.value.isNotEmpty
                ? Border.all(color: Colors.red, width: 1.2)
                : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Department>(
              isExpanded: true,
              value: controller.selectedDepartment.value,
              hint: AppTextRegular(
                text: 'Select Department',
                color: hintTextColor,
                fontSize: 13,
              ),
              items: Department.values.map((dept) {
                return DropdownMenuItem<Department>(
                  value: dept,
                  child: AppTextRegular(text: dept.label, fontSize: 13),
                );
              }).toList(),
              onChanged: (Department? dept) {
                if (dept != null) {
                  controller.selectedDepartment.value = dept;
                  controller.departmentError.value = '';
                }
              },
            ),
          ),
        ),
        if (controller.departmentError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              controller.departmentError.value,
              style: const TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
        const SizedBox(height: 16),

        // ── Audit Date + Audit Time (EDITABLE) ─────────────
        Row(children: [
          Expanded(child: _editableField(
            context: context,
            label: 'Audit Date',
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.auditDate.value ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) controller.auditDate.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextRegular(
                      text: controller.auditDate.value != null
                          ? '${controller.auditDate.value!.year}-'
                            '${controller.auditDate.value!.month.toString().padLeft(2,'0')}-'
                            '${controller.auditDate.value!.day.toString().padLeft(2,'0')}'
                          : 'Select date',
                      color: controller.auditDate.value != null
                          ? navyBlueColor : hintTextColor,
                      fontSize: 13,
                    ),
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          )),
          const SizedBox(width: 16),
          Expanded(child: _editableField(
            context: context,
            label: 'Audit Time',
            child: GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: controller.auditTime.value ?? TimeOfDay.now(),
                );
                if (picked != null) controller.auditTime.value = picked;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextRegular(
                      text: controller.auditTime.value != null
                          ? controller.auditTime.value!.format(context)
                          : 'Select time',
                      color: controller.auditTime.value != null
                          ? navyBlueColor : hintTextColor,
                      fontSize: 13,
                    ),
                    const Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          )),
        ]),
      ],
    ));
  }

  Widget _readonlyField({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          AppTextSemiBold(
            text: label,
            color: Theme.of(context).primaryColor,
            fontSize: 13,
          ),
          const SizedBox(width: 4),
          const Icon(Icons.lock_outline, size: 12, color: Colors.grey),
        ]),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCCCCCC), width: 0.8),
          ),
          child: AppTextRegular(
            text: value,
            color: const Color(0xFF999999),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _editableField({
    required BuildContext context,
    required String label,
    required Widget child,
  }) {
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