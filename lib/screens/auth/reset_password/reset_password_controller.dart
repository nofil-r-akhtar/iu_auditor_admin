import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController{
  final newPasswordController = TextEditingController();
  final confimrNewPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmNewPasswordHidden = true.obs;
  
  @override
  void onClose() {
    newPasswordController.dispose();
    confimrNewPasswordController.dispose();
    super.onClose();
  }
}