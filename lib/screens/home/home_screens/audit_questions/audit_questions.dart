import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'audit_questions_controller.dart';

class AuditQuestions extends StatelessWidget {
  const AuditQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditQuestionsController());
    final isMobile   = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: 'Audit Questions'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextBold(
                        text: 'Audit Questions',
                        fontSize: isMobile ? 18 : 22,
                      ),
                      AppTextRegular(
                        text:
                            'Create forms per department and manage their questions.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // ── Two action buttons ──────────────────────
                Row(children: [
                  // Create Form (outlined secondary)
                  AppButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    onPress: () => controller.openCreateFormDialog(),
                    bgColor: whiteColor,
                    txtColor: primaryColor,
                    border: Border.all(color: primaryColor, width: 1.2),
                    icon: const Icon(Icons.create_new_folder_outlined,
                        color: primaryColor, size: 18),
                    txt: isMobile ? '' : 'Create Form',
                  ),
                  const SizedBox(width: 10),
                  // Add Question (primary)
                  AppButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    onPress: () => controller.openAddDialog(),
                    icon: const Icon(Icons.add, color: whiteColor, size: 18),
                    txt: isMobile ? '' : 'Add Question',
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 20),

            // ── Body ──────────────────────────────────────────
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(60),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              // ── No forms at all → prompt to create one ────
              if (controller.departments.isEmpty) {
                return AppContainer(
                  bgColor: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(
                      vertical: 60, horizontal: 40),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.folder_open_outlined,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        AppTextBold(
                          text: 'No Audit Forms Yet',
                          color: navyBlueColor,
                          fontSize: 18,
                        ),
                        const SizedBox(height: 8),
                        AppTextRegular(
                          text:
                              'Create a form for each department to start adding questions.',
                          color: descriptiveColor,
                          fontSize: 13,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          onPress: () => controller.openCreateFormDialog(),
                          icon: const Icon(
                              Icons.create_new_folder_outlined,
                              color: whiteColor,
                              size: 18),
                          txt: 'Create First Form',
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // ── Forms exist — show tabs + questions ────────
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Department tabs (only depts with forms) ──
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.departments.length,
                      itemBuilder: (context, index) {
                        final dept = controller.departments[index];
                        final isSelected =
                            controller.selectedDepartment.value == dept;
                        return GestureDetector(
                          onTap: () => controller.changeDepartment(dept),
                          child: AppContainer(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18),
                            borderRadius: BorderRadius.circular(20),
                            bgColor:
                                isSelected ? primaryColor : whiteColor,
                            alignment: Alignment.center,
                            child: AppTextMedium(
                              text: dept,
                              color: isSelected
                                  ? whiteColor
                                  : descriptiveColor,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Questions for selected department ────────
                  controller.questions.isEmpty
                      ? _emptyQuestions(controller)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.questions.length,
                          itemBuilder: (context, index) {
                            final item = controller.questions[index];
                            return _QuestionCard(
                              item: item,
                              isMobile: isMobile,
                              onEdit: () =>
                                  controller.openEditDialog(item),
                              onDelete: () =>
                                  controller.confirmDelete(item),
                            );
                          },
                        ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _emptyQuestions(AuditQuestionsController controller) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(children: [
          const Icon(Icons.quiz_outlined, size: 40, color: Colors.grey),
          const SizedBox(height: 12),
          AppTextRegular(
            text: 'No questions for this department yet.',
            color: descriptiveColor,
          ),
          const SizedBox(height: 8),
          AppTextRegular(
            text: 'Tap "Add Question" to create the first one.',
            color: iconColor,
            fontSize: 12,
          ),
        ]),
      ),
    );
  }
}

// ── Question Card widget ─────────────────────────────────────
class _QuestionCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isMobile;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuestionCard({
    required this.item,
    required this.isMobile,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppContainer(
        bgColor: whiteColor,
        padding: EdgeInsets.all(isMobile ? 16 : 22),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            AppContainer(
              padding: const EdgeInsets.all(10),
              bgColor: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              child: const Icon(
                Icons.quiz_outlined,
                color: primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextSemiBold(
                    text: item['question'] ?? '',
                    fontSize: isMobile ? 14 : 15,
                    color: navyBlueColor,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _tag(item['type'] ?? ''),
                      _tag(
                        item['isRequired'] == true
                            ? 'Required'
                            : 'Optional',
                        isRequired: item['isRequired'] == true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Actions
            Column(children: [
              AppIconButton(
                icon: Icons.edit_outlined,
                iconColor: iconColor,
                onPressed: onEdit,
              ),
              AppIconButton(
                icon: Icons.delete_outline,
                iconColor: redColor,
                onPressed: onDelete,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, {bool isRequired = false}) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: BorderRadius.circular(4),
      bgColor: isRequired
          ? const Color(0xFFDCFCE7)
          : const Color(0xFFF1F5F9),
      child: AppTextMedium(
        text: text,
        fontSize: 12,
        color: isRequired
            ? const Color(0xFF15803D)
            : descriptiveColor,
      ),
    );
  }
}