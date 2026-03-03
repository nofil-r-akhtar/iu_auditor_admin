import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/screens/home/home.dart';

class LoginController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final form = GlobalKey<FormState>();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  // Per-field error messages — drive border highlights reactively
  var emailError = ''.obs;
  var passwordError = ''.obs;

  /// Validates and sets per-field errors. Returns true if all fields are valid.
  bool validateFields() {
    bool isValid = true;

    // Email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Enter a valid email";
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Password
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    } else if (password.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
      isValid = false;
    } else {
      passwordError.value = '';
    }

    // Trigger Form rebuild so borders update
    form.currentState?.validate();

    return isValid;
  }

  /// Login Function
  Future<void> login() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2)); // replace with API call

      Get.snackbar("Success", "Login Successful");
      Navigator.pushReplacement(
        Get.context!,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
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