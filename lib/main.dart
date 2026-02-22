import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/app_theme/theme.dart';
// import 'package:iu_auditor_admin/routes.dart';
import 'package:iu_auditor_admin/screens/auth/login/login.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      // initialRoute: "/",
      // getPages: AppRoutes().page,
      home: Login(),
    );
  }
}

