import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'package:iu_auditor_admin/components/home_components/screen_search_bar.dart';
import 'audit_reviews_controller.dart';

class AuditReview extends StatelessWidget {
  const AuditReview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditReviewController());
    final isMobile   = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: 'Audit Reviews'),
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
                        text: 'Audit Reviews',
                        fontSize: isMobile ? 18 : 22,
                      ),
                      AppTextRegular(
                        text: 'Assign and track audit reviews for teachers.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // ── Assign Review button (primary action) ─────
                AppButton(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  onPress: () => controller.openAssignDialog(),
                  icon: const Icon(Icons.assignment_add,
                      color: whiteColor, size: 18),
                  txt: isMobile ? '' : 'Assign Review',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Search bar ────────────────────────────────────
            ScreenSearchBar(
              searchFieldController: controller.searchController,
              searchFieldDummyText: 'Search by teacher or auditor...',
            ),
            const SizedBox(height: 20),

            // ── Review cards ──────────────────────────────────
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (controller.reviews.isEmpty) {
                return AppContainer(
                  bgColor: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(children: [
                      const Icon(Icons.assignment_outlined,
                          size: 40, color: Colors.grey),
                      const SizedBox(height: 12),
                      AppTextRegular(
                        text: 'No audit reviews yet.',
                        color: descriptiveColor,
                      ),
                      const SizedBox(height: 6),
                      AppTextRegular(
                        text: 'Tap "Assign Review" to create one.',
                        color: iconColor,
                        fontSize: 12,
                      ),
                    ]),
                  ),
                );
              }

              return LayoutBuilder(builder: (ctx, constraints) {
                final crossCount = constraints.maxWidth > 1200
                    ? 3
                    : constraints.maxWidth > 700
                        ? 2
                        : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 260,
                  ),
                  itemCount: controller.reviews.length,
                  itemBuilder: (ctx, i) => _ReviewCard(
                    data: controller.reviews[i],
                    controller: controller,
                  ),
                );
              });
            }),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final AuditReviewController controller;
  const _ReviewCard({required this.data, required this.controller});

  Color _statusBg(String s) => s == 'Completed'
      ? const Color(0xFFE8F5E9)
      : const Color(0xFFFFF3E0);

  Color _statusText(String s) => s == 'Completed'
      ? const Color(0xFF2E7D32)
      : const Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String? ?? '';

    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Teacher name + actions row ─────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextSemiBold(
                        text: data['teacher'] ?? '', fontSize: 15),
                    AppTextRegular(
                      text: data['department'] ?? '',
                      fontSize: 12,
                      color: iconColor,
                    ),
                  ],
                ),
              ),
              // ── Delete icon ──────────────────────────────
              AppIconButton(
                icon: Icons.delete_outline,
                iconColor: redColor,
                size: 20,
                onPressed: () => controller.confirmDelete(data),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Detail rows ────────────────────────────────────
          _row('Form',    data['formTitle'] ?? '—'),
          const SizedBox(height: 7),
          _row('Auditor', data['auditor']   ?? '—'),
          const SizedBox(height: 7),
          _row('Date',    data['date']      ?? '—'),
          const SizedBox(height: 7),

          // ── Status badge ───────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextRegular(
                  text: 'Status', color: iconColor, fontSize: 13),
              AppContainer(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                borderRadius: BorderRadius.circular(20),
                bgColor: _statusBg(status),
                child: AppTextMedium(
                  text: status,
                  color: _statusText(status),
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── View Full Report button ─────────────────────────
          AppButton(
            onPress: () => controller.openFullReport(
                data['id'] as String),
            bgColor: const Color(0xFFEFF6FF),
            txtColor: primaryColor,
            alignment: Alignment.center,
            icon: controller.isReportLoading.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primaryColor,
                    ),
                  )
                : const Icon(Icons.visibility_outlined,
                    color: primaryColor, size: 16),
            txt: 'View Full Report',
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextRegular(text: label, color: iconColor, fontSize: 13),
        Flexible(
          child: AppTextMedium(
            text: value,
            color: navyBlueColor,
            fontSize: 13,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}