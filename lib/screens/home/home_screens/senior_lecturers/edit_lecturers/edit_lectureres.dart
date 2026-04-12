import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/edit_lecturers/edit_lecturers_controller.dart';

class EditLecturer extends StatelessWidget {
  final String tag;
  const EditLecturer({required this.tag, super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EditLecturerController>(tag: tag);

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Name (EDITABLE) + Email (READONLY) ─────────────
        Row(children: [
          Expanded(child: _field(context, 'Full Name',
            AppTextField(
              textController: c.nameController,
              placeholder: 'e.g. Dr. Sarah Ahmed',
              placeholderColor: hintTextColor,
              isError: c.nameError.value.isNotEmpty,
              errorText: c.nameError.value,
            ),
          )),
          const SizedBox(width: 16),
          Expanded(child: _readonlyField(context, 'Email', c.readonlyEmail)),
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
            border: c.departmentError.value.isNotEmpty
                ? Border.all(color: Colors.red, width: 1.2)
                : null,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Department>(
              isExpanded: true,
              value: c.selectedDepartment.value,
              hint: AppTextRegular(
                text: 'Select Department',
                color: hintTextColor,
                fontSize: 13,
              ),
              items: Department.values.map((d) => DropdownMenuItem(
                value: d,
                child: AppTextRegular(text: d.label, fontSize: 13),
              )).toList(),
              onChanged: (d) {
                if (d != null) {
                  c.selectedDepartment.value = d;
                  c.departmentError.value = '';
                }
              },
            ),
          ),
        ),
        if (c.departmentError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(c.departmentError.value,
                style: const TextStyle(color: Colors.red, fontSize: 11)),
          ),
        const SizedBox(height: 16),

        // ── New Password (OPTIONAL) ────────────────────────
        _field(context, 'New Password (optional)',
          AppTextField(
            textController: c.passwordController,
            placeholder: 'Leave blank to keep current password',
            placeholderColor: hintTextColor,
            obscureText: true,
            isError: c.passwordError.value.isNotEmpty,
            errorText: c.passwordError.value,
          ),
        ),
        const SizedBox(height: 6),
        Row(children: [
          const Icon(Icons.info_outline, size: 13, color: Colors.grey),
          const SizedBox(width: 6),
          Flexible(
            child: AppTextRegular(
              text: 'Only fill this in if you want to reset the auditor\'s password.',
              color: descriptiveColor,
              fontSize: 11,
            ),
          ),
        ]),
      ],
    ));
  }

  Widget _readonlyField(BuildContext context, String label, String value) {
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