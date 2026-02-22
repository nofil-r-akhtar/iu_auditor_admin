import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_svg.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_field.dart';
import 'package:iu_auditor_admin/components/auth_box.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/auth/forgot_password/forgot_password_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(ForgotPasswordController());
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
            isFrom: Auth.forgotPassword,
            headerTxt: "Forgot Your Password?",
            descriptionTxt: "Enter your registered email address and we’ll send you a link to reset your password.",
            components: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                AppTextSemiBold(text: "Email"),
                const SizedBox(height: 3),
                AppTextField(textController: controller.emailController, prefixIcon: AppSvg(assetPath: user, height: 10, width: 10, fit: BoxFit.scaleDown,), placeholder: "admin@iqra.edu.pk", placeholderColor: hintTextColor,),
                const SizedBox(height: 85),
                // AppTextSemiBold(text: "Password"),
                // const SizedBox(height: 1),
                // Obx(() => AppTextField(
                //       textController: controller.passwordController,
                //       obscureText: controller.isPasswordHidden.value,
                //       prefixIcon: AppSvg(
                //         assetPath: lock,
                //         height: 10,
                //         width: 10,
                //         fit: BoxFit.scaleDown,
                //       ),
                //       suffixIcon: AppIconButton(
                //         icon: controller.isPasswordHidden.value
                //             ? Icons.visibility_off
                //             : Icons.visibility,
                //         onPressed: () {
                //           controller.isPasswordHidden.toggle();
                //         },
                //       ),
                //       placeholder: "••••••••",
                //       placeholderColor: hintTextColor,
                      
                // )),
                // AppTextField(textController: controller.passwordController, prefixIcon: AppSvg(assetPath: lock, height: 5, width: 5, fit: BoxFit.scaleDown), suffixIcon: AppIconButton(icon: , onPressed: onPressed),),
                // const SizedBox(height: 7),
                // Align(
                //   alignment: AlignmentGeometry.centerRight,
                //   child: AppTextButton(
                //     onPressed: () => Get.to(() => const ForgotPassword()),
                //     btnText: "Forgot Password?"),
                // ),
                // const SizedBox(height: 7)
              ],
            ),
          )
        ),
      ),
    );
  }
}