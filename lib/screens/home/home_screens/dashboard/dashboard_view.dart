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
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: bgColor,
      appBar: appBar(context, title: "Dashboard Overview"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Top Stats Cards Row
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _buildStatCard(
                      "Total New Teachers",
                      controller.totalTeachers.value.toString(),
                      "+4 this month",
                      Icons.people_outline,
                      constraints,
                    ),
                    _buildStatCard(
                      "Pending Audits",
                      controller.pendingAudits.value.toString(),
                      "Needs attention",
                      Icons.access_time,
                      constraints,
                    ),
                    _buildStatCard(
                      "Completed Audits",
                      controller.completedAudits.value.toString(),
                      "67% completion",
                      Icons.assignment_turned_in_outlined,
                      constraints,
                    ),
                    _buildStatCard(
                      "Avg. Audit Score",
                      controller.auditScore.value,
                      "+0.3 vs last term",
                      Icons.trending_up,
                      constraints,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRecentActivity(controller)),
                const SizedBox(width: 20),
                Expanded(flex: 1, child: _buildSystemStatus()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String sub,
    IconData icon,
    BoxConstraints constraints,
  ) {
    double width = (constraints.maxWidth - 60) / 4;
    return AppContainer(
      width: width < 250 ? 250 : width,
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      bgColor: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextRegular(text: title, color: descriptiveColor),
              AppContainer(
                padding: const EdgeInsets.all(8),
                bgColor: bgColor,
                shape: BoxShape.circle,
                child: Icon(icon, color: navyBlueColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextBold(text: value, fontSize: 28),
          const SizedBox(height: 10),
          AppContainer(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            borderRadius: BorderRadius.circular(20),
            bgColor: const Color(0xFFECFDF5),
            child: AppTextRegular(
              text: sub,
              color: const Color(0xFF10B981),
              fontSize: 12,
            ),
          ),
        ],
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
          AppTextBold(text: "Recent Activity"),
          const SizedBox(height: 20),
          ...controller.activities.map(
            (activity) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: bgColor,
                    child: AppTextRegular(text: activity['name'][0]),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: navyBlueColor,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: "${activity['name']} ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "${activity['action']} ",
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
                          text: activity['time'],
                          color: iconColor,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  AppContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    bgColor: activity['status'] == 'completed'
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFDBEAFE),
                    child: AppTextRegular(
                      text: activity['status'],
                      color: activity['status'] == 'completed'
                          ? Colors.green
                          : Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          AppTextBold(text: "System Status"),
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
                  child: AppTextRegular(
                    text: "Audit Cycle Active",
                    color: primaryColor,
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
