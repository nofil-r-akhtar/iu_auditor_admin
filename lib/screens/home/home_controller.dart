import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/auth/auth_api.dart';
import 'package:iu_auditor_admin/const/assets.dart';
import 'package:iu_auditor_admin/modal_class/user/user_profile.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_questions/audit_questions.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/audit_reviews/audit_review.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/dashboard/dashboard_view.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/new_faculties/new_faculties.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/senior_lecturers/senior_lectueres.dart';
import 'package:iu_auditor_admin/screens/home/home_screens/user_management/user_management.dart';
import 'package:iu_auditor_admin/services/storage_service.dart';

class HomeController extends GetxController {
  final Auth authapi = Auth();

  var selectedIndex    = 0.obs;
  var isProfileLoading = false.obs;
  Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  final menuItems = [
    {'name': 'Dashboard',        'logo': dashboard},
    {'name': 'New Faculty',      'logo': newFaculties},
    {'name': 'Senior Lecturers', 'logo': seniorLecturers},
    {'name': 'Audit Questions',  'logo': auditQuestions},
    {'name': 'Audit Reviews',    'logo': auditReviews},
    {'name': 'User Management',  'logo': userManagement},
  ];

  final pages = [
    const DashboardView(),
    const NewFaculties(),
    const SeniorLectueres(),
    const AuditQuestions(),
    const AuditReview(),
    const UserManagement(),
  ];

  /// Switch tab AND persist the index so reload restores the same page
  Future<void> changeIndex(int index) async {
    selectedIndex.value = index;
    await StorageService.savePageIndex(index);
  }

  @override
  void onInit() {
    super.onInit();
    _restorePageIndex();
    fetchProfile();
  }

  /// Load the last visited page from localStorage on every boot
  Future<void> _restorePageIndex() async {
    final saved = await StorageService.getPageIndex();
    selectedIndex.value = saved;
  }

  Future<void> fetchProfile() async {
    isProfileLoading.value = true;
    userProfile.value = await authapi.fetchProfile();
    isProfileLoading.value = false;
  }
}