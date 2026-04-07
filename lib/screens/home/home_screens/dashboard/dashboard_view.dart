import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/home_components/home_app_bar.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/dashboard/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: 'Dashboard Overview'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Stat Cards (reactive) ──────────────────────────────
            Obx(() {
              final stats = [
                _StatData('Total New Teachers',  controller.totalTeachers.value.toString(),   '+4 this month',     Icons.people_outline),
                _StatData('Pending Audits',      controller.pendingAudits.value.toString(),   'Needs attention',   Icons.access_time),
                _StatData('Completed Audits',    controller.completedAudits.value.toString(), '67% completion',    Icons.assignment_turned_in_outlined),
                _StatData('Avg. Audit Score',    controller.auditScore.value,                 '+0.3 vs last term', Icons.trending_up),
              ];

              return LayoutBuilder(
                builder: (ctx, constraints) {
                  // 4 cols on wide, 2 on medium, 1 on narrow
                  int crossCount = constraints.maxWidth > 1100
                      ? 4
                      : constraints.maxWidth > 600
                          ? 2
                          : 1;
                  double itemWidth =
                      (constraints.maxWidth - (crossCount - 1) * 16) / crossCount;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: stats
                        .map((s) => _StatCard(data: s, width: itemWidth))
                        .toList(),
                  );
                },
              );
            }),

            const SizedBox(height: 24),

            // ── Activity + Status (responsive) ────────────────────
            LayoutBuilder(
              builder: (ctx, constraints) {
                final isNarrow = constraints.maxWidth < 800;
                final activity  = _buildRecentActivity(controller);
                final status    = _buildSystemStatus();

                if (isNarrow) {
                  return Column(
                    children: [
                      activity,
                      const SizedBox(height: 20),
                      status,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: activity),
                    const SizedBox(width: 20),
                    Expanded(flex: 1, child: status),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(DashboardController controller) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextBold(text: 'Recent Activity'),
          const SizedBox(height: 20),
          Obx(() {
            if (controller.activities.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return Column(
              children: controller.activities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: bgColor,
                      radius: 18,
                      child: AppTextRegular(
                        text: (activity['name'] as String)[0],
                        color: navyBlueColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: navyBlueColor,
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: '${activity['name']} ',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '${activity['action']} ',
                                  style: TextStyle(color: descriptiveColor),
                                ),
                                TextSpan(
                                  text: activity['target'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppTextRegular(
                            text: activity['time'] ?? '',
                            color: iconColor,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      borderRadius: BorderRadius.circular(20),
                      bgColor: activity['status'] == 'completed'
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFDBEAFE),
                      child: AppTextRegular(
                        text: activity['status'] ?? '',
                        color: activity['status'] == 'completed'
                            ? Colors.green
                            : Colors.blue,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextBold(text: 'System Status'),
          const SizedBox(height: 20),
          AppContainer(
            bgColor: const Color(0xFFEFF6FF),
            padding: const EdgeInsets.all(15),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextBold(text: 'Audit Cycle Active', color: primaryColor, fontSize: 13),
                      const SizedBox(height: 4),
                      AppTextRegular(
                        text: 'Fall 2024 audit cycle in progress.\nDeadline: Oct 30th.',
                        color: primaryColor,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper classes ───────────────────────────────────────────────────────────

class _StatData {
  final String title;
  final String value;
  final String sub;
  final IconData icon;
  const _StatData(this.title, this.value, this.sub, this.icon);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  final double width;
  const _StatCard({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: width,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      bgColor: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: AppTextRegular(text: data.title, color: descriptiveColor, fontSize: 13),
              ),
              AppContainer(
                padding: const EdgeInsets.all(8),
                bgColor: bgColor,
                shape: BoxShape.circle,
                child: Icon(data.icon, color: navyBlueColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextBold(text: data.value, fontSize: 28),
          const SizedBox(height: 10),
          AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(20),
            bgColor: const Color(0xFFECFDF5),
            child: AppTextRegular(
              text: data.sub,
              color: const Color(0xFF10B981),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}