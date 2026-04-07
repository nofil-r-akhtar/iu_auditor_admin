import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_svg.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/home/home_controller.dart';

AppBar appBar(BuildContext context, {required String title}) {
  final HomeController controller = Get.find();
  final bool isMobile = MediaQuery.of(context).size.width < 768;

  return AppBar(
    backgroundColor: whiteColor,
    automaticallyImplyLeading: false,
    centerTitle: false,
    titleSpacing: 0,
    title: Row(
      children: [
        // Hamburger on mobile — opens parent Scaffold drawer
        if (isMobile)
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu, color: navyBlueColor),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              tooltip: 'Menu',
            ),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: AppTextBold(
            text: title,
            color: navyBlueColor,
            fontFamily: FontFamily.inter,
            fontSize: isMobile ? 16 : 19,
          ),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Obx(() {
          if (controller.isProfileLoading.value ||
              controller.userProfile.value == null) {
            return const SizedBox.shrink();
          }

          final name    = controller.userProfile.value!.name;
          final role    = controller.userProfile.value!.role;
          final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppSvg(assetPath: bell),
              const SizedBox(width: 16),

              // Hide name/role on very small screens
              if (!isMobile) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppTextMedium(text: name, color: navyBlueColor, fontSize: 13),
                    AppTextRegular(text: role, color: descriptiveColor, fontSize: 11),
                  ],
                ),
                const SizedBox(width: 12),
              ],

              AppContainer(
                bgColor: navyBlueColor,
                shape: BoxShape.circle,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: AppTextRegular(
                  text: initial,
                  color: whiteColor,
                  fontSize: 14,
                ),
              ),
            ],
          );
        }),
      ),
    ],
  );
}