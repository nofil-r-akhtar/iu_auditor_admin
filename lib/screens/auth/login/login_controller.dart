import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  bool validateFields() {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "Email is required");
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Enter a valid email");
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Password is required");
      return false;
    }

    return true;
  }

  /// Login Function
  Future<void> login() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2)); // simulate API

      Get.snackbar("Success", "Login Successful");

    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}