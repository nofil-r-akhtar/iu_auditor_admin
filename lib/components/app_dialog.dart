import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_text.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final double? width;
  final bool showActions;
  final bool isLoading;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.width,
    this.showActions = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: width ?? (isMobile ? screenWidth * 0.95 : 560),
        padding: EdgeInsets.all(isMobile ? 20 : 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextBold(text: title, fontSize: 18, color: navyBlueColor),
                IconButton(
                  onPressed: onCancel ?? () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 16),

            // ── Content ──
            content,

            // ── Actions ──
            if (showActions) ...[
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCancel ?? () => Get.back(),
                    child: AppTextMedium(
                      text: cancelText ?? 'Cancel',
                      color: descriptiveColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    onPress: onConfirm ?? () {},
                    txt: confirmText ?? 'Confirm',
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Show standard dialog ──────────────────────────────────
  static void show({
    required String title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    double? width,
    bool showActions = true,
    bool barrierDismissible = true,
    bool isLoading = false,
  }) {
    Get.dialog(
      AppDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        width: width,
        showActions: showActions,
        isLoading: isLoading,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // ── Standard confirm dialog ───────────────────────────────
  static void showConfirm({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
  }) {
    Get.dialog(
      AppDialog(
        title: title,
        content: AppTextRegular(
          text: message,
          color: descriptiveColor,
          fontSize: 14,
        ),
        confirmText: confirmText ?? 'Confirm',
        cancelText: cancelText ?? 'Cancel',
        onConfirm: onConfirm,
        onCancel: onCancel ?? () => Get.back(),
      ),
    );
  }

  // ── DELETE confirmation dialog — custom styled ────────────
  static void showDeleteConfirm({
    required String teacherName,
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      barrierDismissible: true,
      Dialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 380,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Alert icon ────────────────────────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFE53935),
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ─────────────────────────────────────
              AppTextBold(
                text: 'Delete Teacher',
                fontSize: 20,
                color: navyBlueColor,
              ),
              const SizedBox(height: 12),

              // ── Message ───────────────────────────────────
              Text(
                'Are you sure you want to delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: descriptiveColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '"$teacherName"?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: navyBlueColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 28),

              // ── Buttons ───────────────────────────────────
              Row(
                children: [
                  // Cancel — primary color
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFEFF6FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Delete — red
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        onConfirm();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}