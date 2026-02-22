import 'package:get/get.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/audit_questions.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_reviews/audit_review.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/dashboard/dashboard_view.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/new_faculties.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/senior_lectueres.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/user_management/user_management.dart';

class HomeController extends GetxController{
  var selectedIndex = 0.obs;

  final menuItems = [
    {
      "name": "Dashboard",
      "logo": dashboard
    },
    {
      "name": "New Faculty",
      "logo": newFaculties
    },
    {
      "name": "Senior Lecturers",
      "logo": seniorLecturers
    },
    {
      "name": "Audit Questions",
      "logo": auditQuestions
    },
    {
      "name": "Audit Reviews",
      "logo": auditReviews
    },
    {
      "name": "User Management",
      "logo": userManagement
    },
  ];

  final pages = [
    const DashboardView(),
    const NewFaculties(),
    const SeniorLectueres(),
    const AuditQuestions(),
    const AuditReview(),
    const UserManagement()
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}