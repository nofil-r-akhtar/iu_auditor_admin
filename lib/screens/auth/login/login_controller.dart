import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/auth/auth_api.dart';
import 'package:iu_auditor_admin/routes/app_routes.dart';

/// Roles that are allowed to access this admin portal.
const _allowedRoles = ['super_admin', 'admin', 'department_head'];

class LoginController extends GetxController {
  Auth authapi = Auth();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final form               = GlobalKey<FormState>();

  var isPasswordHidden = true.obs;
  var isLoading        = false.obs;

  var emailError    = ''.obs;
  var passwordError = ''.obs;

  bool validateFields() {
    bool isValid = true;

    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError.value = 'Email is required'; isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = 'Enter a valid email'; isValid = false;
    } else { emailError.value = ''; }

    final password = passwordController.text.trim();
    if (password.isEmpty) {
      passwordError.value = 'Password is required'; isValid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters'; isValid = false;
    } else { passwordError.value = ''; }

    form.currentState?.validate();
    return isValid;
  }

  Future<void> login() async {
    if (!validateFields()) return;
    try {
      isLoading.value = true;

      final response = await authapi.login(
        email:    emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!response.success) {
        Get.snackbar('Error', response.message);
        return;
      }

      // ── Role check — block senior_lecturer from admin portal ──
      final role = response.data.user.role;
      if (!_allowedRoles.contains(role)) {
        Get.snackbar(
          'Access Denied',
          'This portal is for administrators only.\n'
          'Please use the Auditor App instead.',
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFFFFEBEB),
          colorText: const Color(0xFFC62828),
          snackPosition: SnackPosition.BOTTOM,
        );
        return; // do NOT save token or navigate
      }

      // ── Allowed — save token and go to home ───────────────
      if (response.data.accessToken.isNotEmpty) {
        await ApiRequest.setAuthToken(response.data.accessToken);
      }

      Get.offAllNamed(AppRoutes.home);

    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar('Error', e.toString());
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