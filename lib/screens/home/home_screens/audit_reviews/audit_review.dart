import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'package:iu_auditor_admin/components/home_components/screen_search_bar.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_reviews/audit_reviews_controller.dart';

class AuditReview extends StatelessWidget {
  const AuditReview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuditReviewController());
    final isMobile = MediaQuery.of(context).size.width < 600;

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
            // ── Responsive header ──────────────────────────────────
            Row(
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
                        text: 'View feedback submitted by senior lecturers.',
                        color: descriptiveColor,
                        fontSize: 13,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AppButton(
                  onPress: () {},
                  bgColor: whiteColor,
                  txtColor: navyBlueColor,
                  border: Border.all(color: iconColor.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  icon: const Icon(Icons.file_download_outlined, color: navyBlueColor, size: 18),
                  txt: isMobile ? '' : 'Export Report',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Search + Filter ────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: ScreenSearchBar(
                    searchFieldController: controller.searchController,
                    searchFieldDummyText: 'Search by teacher or auditor...',
                  ),
                ),
                const SizedBox(width: 12),
                AppContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  bgColor: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, color: iconColor, size: 20),
                      if (!isMobile) ...[
                        const SizedBox(width: 8),
                        AppTextMedium(text: 'Filter', color: descriptiveColor),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Review cards grid ──────────────────────────────────
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
                    child: AppTextRegular(
                      text: 'No reviews found.',
                      color: descriptiveColor,
                    ),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (ctx, constraints) {
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
                      mainAxisExtent: 270,
                    ),
                    itemCount: controller.reviews.length,
                    itemBuilder: (ctx, i) =>
                        _ReviewCard(data: controller.reviews[i]),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ReviewCard({required this.data});

  Color _statusBg(String s) {
    if (s == 'Completed') return const Color(0xFFE8F5E9);
    if (s == 'In Progress') return const Color(0xFFE3F2FD);
    return const Color(0xFFFFF3E0);
  }

  Color _statusText(String s) {
    if (s == 'Completed') return const Color(0xFF2E7D32);
    if (s == 'In Progress') return const Color(0xFF1565C0);
    return const Color(0xFFE65100);
  }

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? '';
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextSemiBold(
                      text: data['teacher'] ?? '',
                      fontSize: 15,
                    ),
                    AppTextRegular(
                      text: data['department'] ?? '',
                      fontSize: 12,
                      color: iconColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                bgColor: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 13),
                    const SizedBox(width: 3),
                    AppTextBold(
                      text: data['rating'] ?? '—',
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _row('Auditor', data['auditor'] ?? '—'),
          const SizedBox(height: 8),
          _row('Date', data['date'] ?? '—'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextRegular(text: 'Status', color: iconColor, fontSize: 13),
              AppContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
          AppButton(
            onPress: () {},
            bgColor: const Color(0xFFEFF6FF),
            txtColor: primaryColor,
            alignment: Alignment.center,
            icon: const Icon(Icons.visibility_outlined, color: primaryColor, size: 16),
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
        AppTextMedium(text: value, color: navyBlueColor, fontSize: 13),
      ],
    );
  }
}