import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_image.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_button.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/const/enums.dart';

class AuthBox extends StatelessWidget {
  final Auth isFrom;
  final String? headerTxt;
  final String? descriptionTxt;
  final Widget? components;
  final VoidCallback? onPress;
  final VoidCallback? onResend;
  final RxBool? resendEnabled;
  final RxInt? secondsRemaining;
  final RxBool? isLoading; // ← NEW

  const AuthBox({
    this.isFrom = Auth.forgotPassword,
    this.headerTxt,
    this.descriptionTxt,
    this.components,
    this.onPress,
    this.onResend,
    this.resendEnabled,
    this.secondsRemaining,
    this.isLoading, // ← NEW
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final boxWidth = w < 600 ? w * 0.9 : w < 1024 ? 500.0 : 450.0;

      return Center(
        child: AppContainer(
          bgColor: whiteColor,
          width: boxWidth,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo ────────────────────────────────────
                Center(
                  child: AppAssetImage(
                    imagePath: logo,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40),

                // ── Header ───────────────────────────────────
                AppTextBold(text: headerTxt ?? ''),
                const SizedBox(height: 8),
                AppTextRegular(text: descriptionTxt ?? ''),
                const SizedBox(height: 30),

                // ── Custom Components ─────────────────────────
                if (components != null) components!,
                const SizedBox(height: 30),

                // ── Button — shows loader when isLoading=true ──
                Obx(() {
                  final loading = isLoading?.value ?? false;
                  return AppButton(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    txt: loading
                        ? ''
                        : isFrom == Auth.forgotPassword ||
                                isFrom == Auth.resetPassword
                            ? 'Next'
                            : isFrom == Auth.otp
                                ? 'Verify'
                                : 'Sign in',
                    onPress: loading ? null : onPress,
                    alignment: Alignment.center,
                    // Show spinner inside button while loading
                    icon: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: whiteColor,
                              strokeWidth: 2.5,
                            ),
                          )
                        : null,
                  );
                }),

                // ── OTP resend ────────────────────────────────
                Visibility(
                  visible: isFrom == Auth.otp,
                  child: const SizedBox(height: 5),
                ),
                Visibility(
                  visible: isFrom == Auth.otp,
                  child: Center(
                    child: Obx(() {
                      final enabled = resendEnabled?.value ?? false;
                      final seconds = secondsRemaining?.value ?? 0;
                      return AppTextButton(
                        btnText: enabled
                            ? 'Resend OTP'
                            : 'Resend OTP in ${seconds}s',
                        txtSize: 12,
                        onPressed: enabled ? onResend : null,
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}