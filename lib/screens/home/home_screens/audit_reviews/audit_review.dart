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
    // 1. Initialize controller
    final controller = Get.put(AuditReviewController());
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: bgColor, // Silver background
      appBar: appBar(context, title: "Audit Reviews"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 25,
          vertical: 25, // Consistent 25px top gap
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextBold(text: "Audit Reviews", fontSize: 22),
                    AppTextRegular(
                      text: "View feedback submitted by senior lecturers.",
                      color: descriptiveColor,
                    ),
                  ],
                ),
                AppButton(
                  onPress: () {},
                  bgColor: whiteColor,
                  txtColor: navyBlueColor,
                  border: Border.all(color: iconColor.withOpacity(0.3)),
                  icon: const Icon(
                    Icons.file_download_outlined,
                    color: navyBlueColor,
                    size: 20,
                  ),
                  txt: "Export Report",
                ),
              ],
            ),
            const SizedBox(height: 25), // Consistent 25px gap
            // Search and Filter Bar
            Row(
              children: [
                Expanded(
                  child: ScreenSearchBar(
                    searchFieldController: controller.searchController,
                    searchFieldDummyText: "Search by teacher or auditor...",
                  ),
                ),
                const SizedBox(width: 15),
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  bgColor: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list, color: iconColor),
                      const SizedBox(width: 8),
                      AppTextMedium(text: "Filter", color: descriptiveColor),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25), // Consistent 25px gap
            // Grid of Review Cards wrapped in Obx
            Obx(() {
              // ACCESSING THE OBSERVABLE: This line tells GetX to watch this widget
              if (controller.reviews.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive Logic
                  int crossAxisCount = constraints.maxWidth > 1200
                      ? 3
                      : (constraints.maxWidth > 800 ? 2 : 1);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: 275, // Adjusted to fit content
                    ),
                    itemCount: controller.reviews.length,
                    itemBuilder: (context, index) {
                      return _buildReviewCard(controller.reviews[index]);
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> data) {
    return AppContainer(
      bgColor: whiteColor,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextSemiBold(text: data['teacher'] ?? "", fontSize: 16),
                  AppTextRegular(
                    text: data['department'] ?? "",
                    fontSize: 12,
                    color: iconColor,
                  ),
                ],
              ),
              AppContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                bgColor: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    AppTextBold(
                      text: data['rating'] ?? "0.0",
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow("Auditor", data['auditor'] ?? ""),
          const SizedBox(height: 10),
          _buildDetailRow("Date", data['date'] ?? ""),
          const SizedBox(height: 10),
          _buildDetailRow("Status", data['status'] ?? "", isStatus: true),
          const Spacer(),
          AppButton(
            onPress: () {},
            bgColor: const Color(0xFFEFF6FF),
            txtColor: primaryColor,
            alignment: Alignment.center,
            icon: const Icon(
              Icons.visibility_outlined,
              color: primaryColor,
              size: 18,
            ),
            txt: "View Full Report",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextRegular(text: label, color: iconColor, fontSize: 13),
        AppTextMedium(
          text: value,
          color: isStatus ? Colors.green : navyBlueColor,
          fontSize: 13,
        ),
      ],
    );
  }
}
