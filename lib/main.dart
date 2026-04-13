import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/app_theme/theme.dart';
import 'package:iu_auditor_admin/routes/app_pages.dart';
import 'package:iu_auditor_admin/routes/app_routes.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ApiRequest.loadStoredToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}

