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
      appBar: appBar(context, title: "Audit Questions"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextBold(text: "Audit Questions", fontSize: 22),
                    AppTextRegular(
                      text:
                          "Manage evaluation criteria for different departments.",
                      color: descriptiveColor,
                    ),
                  ],
                ),
                AppButton(
                  onPress: () {},
                  icon: const Icon(Icons.add, color: whiteColor, size: 20),
                  txt: "Add Question",
                ),
              ],
            ),
            const SizedBox(height: 25),

            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.departments.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final dept = controller.departments[index];
                    final isSelected =
                        controller.selectedDepartment.value == dept;
                    return GestureDetector(
                      onTap: () => controller.changeDepartment(dept),
                      child: AppContainer(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  });
                },
              ),
            ),
            const SizedBox(height: 25),

            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.questions.length,
                itemBuilder: (context, index) {
                  final item = controller.questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AppContainer(
                      bgColor: whiteColor,
                      padding: const EdgeInsets.all(25),
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
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextSemiBold(
                                  text: item['question'],
                                  fontSize: 16,
                                  color: navyBlueColor,
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _buildTag(item['category']),
                                    _buildTag(item['type']),
                                    if (item['department'] != "All")
                                      _buildTag(
                                        item['department'],
                                        isDept: true,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              AppIconButton(
                                icon: Icons.edit_outlined,
                                iconColor: iconColor,
                                onPressed: () {},
                              ),
                              AppIconButton(
                                icon: Icons.delete_outline,
                                iconColor: redColor,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, {bool isDept = false}) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
