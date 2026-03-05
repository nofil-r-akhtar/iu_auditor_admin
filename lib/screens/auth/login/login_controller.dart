import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/auth/auth_api.dart';
import 'package:iu_auditor_admin/main.dart';
import 'package:iu_auditor_admin/screens/home/home.dart';

class LoginController extends GetxController{
  Auth authapi = Auth();
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

    final response = await authapi.login(
      email: emailController.text,
      password: passwordController.text,
    );

    // ── Failure: API returned success = false ──
    if (response['success'].toString() == 'false') {
      Get.snackbar("Error", response['message'] ?? "Login failed");
      return;
    }

    // ── Success: store token and navigate ──
    // final String token = response['access_token'];
    // ApiRequest.setAuthToken(token);   // sets Bearer token for future requests

    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeView()),
    );

  } catch (e) {
    debugPrint('Login error: $e');
    Get.snackbar("Error", e.toString());
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