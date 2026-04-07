import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/audit_questions_controller.dart';

class AuditQuestions extends StatelessWidget {
  const AuditQuestions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditQuestionsController());
    final isMobile = MediaQuery.of(context).size.width < 600;

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
            // ── Responsive header ──────────────────────────────────
            Row(
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
                        text: 'Manage evaluation criteria for different departments.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  onPress: () {},
                  icon: const Icon(Icons.add, color: whiteColor, size: 18),
                  txt: isMobile ? '' : 'Add Question',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Department filter tabs ─────────────────────────────
            Obx(() => SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.departments.length,
                itemBuilder: (context, index) {
                  final dept = controller.departments[index];
                  final isSelected = controller.selectedDepartment.value == dept;
                  return GestureDetector(
                    onTap: () => controller.changeDepartment(dept),
                    child: AppContainer(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      borderRadius: BorderRadius.circular(20),
                      bgColor: isSelected ? primaryColor : whiteColor,
                      alignment: Alignment.center,
                      child: AppTextMedium(
                        text: dept,
                        color: isSelected ? whiteColor : descriptiveColor,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
            )),
            const SizedBox(height: 20),

            // ── Questions list ─────────────────────────────────────
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.questions.isEmpty) {
                return AppContainer(
                  bgColor: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: AppTextRegular(
                      text: 'No questions for this department.',
                      color: descriptiveColor,
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  final item = controller.questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppContainer(
                      bgColor: whiteColor,
                      padding: EdgeInsets.all(isMobile ? 16 : 22),
                      borderRadius: BorderRadius.circular(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextSemiBold(
                                  text: item['question'] ?? '',
                                  fontSize: isMobile ? 14 : 16,
                                  color: navyBlueColor,
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _tag(item['category'] ?? ''),
                                    _tag(item['type'] ?? ''),
                                    if ((item['department'] ?? '') != 'All')
                                      _tag(item['department'] ?? '', isDept: true),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              AppIconButton(
                                icon: Icons.edit_outlined,
                                iconColor: iconColor,
                                onPressed: () {},
                              ),
                              AppIconButton(
                                icon: Icons.delete_outline,
                                iconColor: redColor,
                                onPressed: () => controller.deleteQuestion(
                                  item['formId'] ?? '',
                                  item['id'] ?? '',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, {bool isDept = false}) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      borderRadius: BorderRadius.circular(4),
      bgColor: isDept ? const Color(0xFFE0E7FF) : const Color(0xFFF1F5F9),
      child: AppTextMedium(
        text: text,
        fontSize: 12,
        color: isDept ? const Color(0xFF4338CA) : descriptiveColor,
      ),
    );
  }
}