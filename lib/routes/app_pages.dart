import 'package:get/get.dart';
import 'package:iu_auditor_admin/routes/app_routes.dart';
import 'package:iu_auditor_admin/screens/auth/login/login.dart';
import 'package:iu_auditor_admin/screens/home/home.dart';
import 'package:iu_auditor_admin/screens/splash/splash.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
  ];
}