import 'package:flutter/material.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_button.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_image.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/components/app_text_button.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/screens/auth/login/login.dart';
import 'package:iu_auditor_admin/screens/auth/otp/otp_view.dart';
import 'package:iu_auditor_admin/screens/auth/reset_password/reset_password.dart';
import 'package:iu_auditor_admin/screens/home/home.dart';

class AuthBox extends StatelessWidget {
  final Auth isFrom;
  final String? headerTxt;
  final String? descriptionTxt;
  final Widget? components;
  const AuthBox({
    this.isFrom = Auth.forgotPassword,
    this.headerTxt,
    this.descriptionTxt,
    this.components,
    super.key});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;

        double boxWidth;
        if (screenWidth < 600) {
          
          boxWidth = screenWidth * 0.9;
        } else if (screenWidth < 1024) {
          // 📲 Tablet
          boxWidth = 500;
        } else {
          // 🖥 Desktop
          boxWidth = 450;
        }
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
                  /// Logo
                  Center(
                    child: AppAssetImage(
                      imagePath: logo,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
            
                  const SizedBox(height: 40),
            
                  /// Header
                  AppTextBold(text: headerTxt ?? ""),
            
                  const SizedBox(height: 8),
            
                  /// Description
                  AppTextRegular(text: descriptionTxt ?? ""),
            
                  const SizedBox(height: 30),
            
                  /// Custom Components
                  if (components != null) components!,
            
                  const SizedBox(height: 30),
            
                  /// Button
                  AppButton(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    txt: isFrom == Auth.forgotPassword || isFrom == Auth.resetPassword ? "Next" : isFrom == Auth.otp ? "Verify" : "Sign in",
                    onPress: () {
                      if (isFrom == Auth.forgotPassword) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (context) => const OtpView()),
                        );
                      } else if (isFrom == Auth.otp) {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (context) => const ResetPassword()),
                        );
                      } else if (isFrom == Auth.resetPassword) {
                        Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (context) => const Login()));
                      }
                      else {
                        Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (context) => const HomeView()));
                      }
                    },
                    alignment: Alignment.center,
                  ),
                  Visibility(
                    visible: isFrom == Auth.otp,
                    child: SizedBox(height: 5)),
                  Visibility(
                    visible: isFrom == Auth.otp,
                    child: Center(child: AppTextButton(btnText: "Resend OTP", txtSize: 12,)))

                ],
              ),
            ),
          ),
        );
        });
        
  }
}