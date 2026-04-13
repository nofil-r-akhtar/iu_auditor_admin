import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'assign_review_controller.dart';

class AssignReview extends StatelessWidget {
  const AssignReview({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AssignReviewController>();

    return Obx(() {
      if (c.isLoadingData.value) {
        return const SizedBox(
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Teacher Dropdown ───────────────────────────────
          _field(context, 'Teacher (Auditee)',
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: c.teacherError.value.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.2) : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: c.selectedTeacher.value?.id,
                    hint: AppTextRegular(
                        text: 'Select a teacher to audit',
                        color: hintTextColor, fontSize: 13),
                    items: c.teachers.map((t) => DropdownMenuItem(
                      value: t.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextMedium(text: t.name, fontSize: 13),
                          AppTextRegular(
                              text: t.department,
                              color: descriptiveColor,
                              fontSize: 11),
                        ],
                      ),
                    )).toList(),
                    onChanged: (id) {
                      final teacher = c.teachers.firstWhereOrNull(
                          (t) => t.id == id);
                      c.onTeacherChanged(teacher);
                    },
                  ),
                ),
              ),
              if (c.teacherError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(c.teacherError.value,
                      style: const TextStyle(color: Colors.red, fontSize: 11)),
                ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Audit Form Dropdown ────────────────────────────
          _field(context, 'Audit Form',
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: c.formError.value.isNotEmpty
                      ? Border.all(color: Colors.red, width: 1.2) : null,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: c.selectedForm.value?.id,
                    hint: AppTextRegular(
                        text: c.selectedTeacher.value == null
                            ? 'Select a teacher first'
                            : c.filteredForms.isEmpty
                                ? 'No forms for this department'
                                : 'Select audit form',
                        color: hintTextColor, fontSize: 13),
                    items: c.filteredForms.map((f) => DropdownMenuItem(
                      value: f.id,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppTextMedium(text: f.title, fontSize: 13),
                          AppTextRegular(
                              text: f.department,
                              color: descriptiveColor, fontSize: 11),
                        ],
                      ),
                    )).toList(),
                    onChanged: c.filteredForms.isEmpty ? null : (id) {
                      c.selectedForm.value =
                          c.filteredForms.firstWhereOrNull((f) => f.id == id);
                      c.formError.value = '';
                    },
                  ),
                ),
              ),
              if (c.formError.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Text(c.formError.value,
                      style: const TextStyle(color: Colors.red, fontSize: 11)),
                ),
              // Helper — form auto-filtered by teacher's department
              if (c.selectedTeacher.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4),
                  child: Row(children: [
                    const Icon(Icons.info_outline, size: 13, color: Colors.grey),
                    const SizedBox(width: 5),
                    AppTextRegular(
                      text: 'Showing forms for ${c.selectedTeacher.value!.department}',
                      color: descriptiveColor, fontSize: 11,
                    ),
                  ]),
                ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Notes (optional) ───────────────────────────────
          _field(context, 'Notes (optional)',
            AppTextField(
              textController: c.notesController,
              placeholder: 'Add any instructions or notes for the auditor...',
              placeholderColor: hintTextColor,
              minLine: 2,
              maxLine: 3,
            ),
          ),
        ],
      );
    });
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