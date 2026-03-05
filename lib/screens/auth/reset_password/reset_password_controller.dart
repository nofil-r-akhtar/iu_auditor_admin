import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/auth/auth_api.dart';
import 'package:iu_auditor_admin/main.dart';
import 'package:iu_auditor_admin/screens/auth/login/login.dart';

class ResetPasswordController extends GetxController {
  final Auth authapi = Auth();
  final newPasswordController = TextEditingController();
  final confimrNewPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmNewPasswordHidden = true.obs;
  var isLoading = false.obs;

  var newPasswordError = ''.obs;
  var confirmPasswordError = ''.obs;

  // email and otp passed from OtpView
  late String email;
  late String otp;

  bool validateFields() {
    bool isValid = true;

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confimrNewPasswordController.text.trim();

    if (newPassword.isEmpty) {
      newPasswordError.value = "New password is required";
      isValid = false;
    } else if (newPassword.length < 6) {
      newPasswordError.value = "Password must be at least 6 characters";
      isValid = false;
    } else {
      newPasswordError.value = '';
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = "Please confirm your password";
      isValid = false;
    } else if (confirmPassword != newPassword) {
      confirmPasswordError.value = "Passwords do not match";
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    return isValid;
  }

  Future<void> resetPassword() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      final response = await authapi.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPasswordController.text.trim(),
      );

      if (response['success'].toString() == 'false') {
        Get.snackbar("Error", response['message'] ?? "Failed to reset password");
        return;
      }

      // Success — go back to login and clear stack
      Get.snackbar("Success", "Password reset successfully");
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,   // clears entire stack
      );

    } catch (e) {
      debugPrint('Reset password error: $e');
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confimrNewPasswordController.dispose();
    super.onClose();
  }
}