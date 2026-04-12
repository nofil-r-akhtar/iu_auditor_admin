import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/add_lecturers/add_lectuerers_controller.dart';


class AddLecturer extends StatelessWidget {
  const AddLecturer({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AddLecturerController>();

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Name + Email ───────────────────────────────────
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
          Expanded(child: _field(context, 'Email',
            AppTextField(
              textController: c.emailController,
              placeholder: 'email@iqra.edu.pk',
              placeholderColor: hintTextColor,
              keyboardType: TextInputType.emailAddress,
              isError: c.emailError.value.isNotEmpty,
              errorText: c.emailError.value,
            ),
          )),
        ]),
        const SizedBox(height: 16),

        // ── Department + Role (readonly badge) ─────────────
        Row(children: [
          Expanded(child: _field(context, 'Department',
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
          )),
          const SizedBox(width: 16),
          Expanded(child: _field(context, 'Role',
            // Role is fixed — show as readonly badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE), width: 0.8),
              ),
              child: Row(children: [
                const Icon(Icons.lock_outline, size: 13, color: primaryColor),
                const SizedBox(width: 6),
                AppTextMedium(
                  text: UserRole.seniorLecturer.displayLabel,
                  color: primaryColor,
                  fontSize: 13,
                ),
              ]),
            ),
          )),
        ]),
        if (c.departmentError.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(c.departmentError.value,
                style: const TextStyle(color: Colors.red, fontSize: 11)),
          ),
        const SizedBox(height: 16),

        // ── Temporary Password ─────────────────────────────
        _field(context, 'Temporary Password',
          AppTextField(
            textController: c.passwordController,
            placeholder: 'Min. 6 characters',
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
              text: 'Auditor will be prompted to change this password on first login.',
              color: descriptiveColor,
              fontSize: 11,
            ),
          ),
        ]),
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