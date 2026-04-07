import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/create_faculties/create_faculties_controller.dart';

class CreateFaculties extends StatelessWidget {
  const CreateFaculties({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateFacultiesController());

    return Obx(() => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Full Name + Email ──────────────────────────────
        Row(children: [
          Expanded(child: _field(
            label: 'Full Name', context: context,
            child: AppTextField(
              textController: controller.fullNameController,
              placeholder: 'e.g. Mr. Ali Khan',
              placeholderColor: hintTextColor,
              isError: controller.fullNameError.value.isNotEmpty,
              errorText: controller.fullNameError.value,
            ),
          )),
          const SizedBox(width: 16),
          Expanded(child: _field(
            label: 'Email', context: context,
            child: AppTextField(
              textController: controller.emailController,
              placeholder: 'email@iqra.edu.pk',
              placeholderColor: hintTextColor,
              keyboardType: TextInputType.emailAddress,
              isError: controller.emailError.value.isNotEmpty,
              errorText: controller.emailError.value,
            ),
          )),
        ]),

        const SizedBox(height: 16),

        // ── Contact + Specialization ───────────────────────
        Row(children: [
          Expanded(child: _field(
            label: 'Contact No', context: context,
            child: AppTextField(
              textController: controller.contactController,
              placeholder: '+923123895862',
              placeholderColor: hintTextColor,
              keyboardType: TextInputType.phone,
              isError: controller.contactError.value.isNotEmpty,
              errorText: controller.contactError.value,
            ),
          )),
          const SizedBox(width: 16),
          Expanded(child: _field(
            label: 'Specialization', context: context,
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

        // ── Department Dropdown — from Department enum in enums.dart ──
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

        // ── Audit Date + Audit Time ────────────────────────
        Row(children: [
          Expanded(child: _field(
            label: 'Audit Date', context: context,
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
                  border: controller.dateError.value.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.2)
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextRegular(
                      text: controller.auditDate.value != null
                          ? '${controller.auditDate.value!.year}-'
                            '${controller.auditDate.value!.month.toString().padLeft(2, '0')}-'
                            '${controller.auditDate.value!.day.toString().padLeft(2, '0')}'
                          : 'Select date',
                      color: controller.auditDate.value != null
                          ? navyBlueColor : hintTextColor,
                      fontSize: 13,
                    ),
                    const Icon(Icons.calendar_today_outlined,
                        size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          )),
          const SizedBox(width: 16),
          Expanded(child: _field(
            label: 'Audit Time', context: context,
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
                    const Icon(Icons.access_time_outlined,
                        size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          )),
        ]),
      ],
    ));
  }

  Widget _field({
    required String label,
    required BuildContext context,
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