import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_icon_button.dart';
import 'package:iu_auditor_admin/components/app_svg.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/components/auth_box.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/auth/reset_password/reset_password_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(ResetPasswordController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(
            Icons.arrow_back
          )),
      ),
      body: SafeArea(
        child: Center(
          child: AuthBox(
            headerTxt: "Reset your Password",
            descriptionTxt: "Please enter your new password and confirm it to continue.",
            isFrom: Auth.resetPassword,
            components: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                AppTextSemiBold(text: "New Password"),
                const SizedBox(height: 3),
                Obx(() => AppTextField(
                      textController: controller.newPasswordController,
                      obscureText: controller.isNewPasswordHidden.value,
                      prefixIcon: AppSvg(
                        assetPath: lock,
                        height: 10,
                        width: 10,
                        fit: BoxFit.scaleDown,
                      ),
                      suffixIcon: AppIconButton(
                        icon: controller.isNewPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onPressed: () {
                          controller.isNewPasswordHidden.toggle();
                        },
                      ),
                      placeholder: "••••••••",
                      placeholderColor: hintTextColor,
                      
                )),
                const SizedBox(height: 25),
                AppTextSemiBold(text: "Confirm New Password"),
                const SizedBox(height: 3),
                Obx(() => AppTextField(
                      textController: controller.confimrNewPasswordController,
                      obscureText: controller.isConfirmNewPasswordHidden.value,
                      prefixIcon: AppSvg(
                        assetPath: lock,
                        height: 10,
                        width: 10,
                        fit: BoxFit.scaleDown,
                      ),
                      suffixIcon: AppIconButton(
                        icon: controller.isConfirmNewPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        onPressed: () {
                          controller.isConfirmNewPasswordHidden.toggle();
                        },
                      ),
                      placeholder: "••••••••",
                      placeholderColor: hintTextColor,
                      
                )),
                const SizedBox(height: 20),
              ],
            ),
          )
        ),
      ),
    );
  }
}