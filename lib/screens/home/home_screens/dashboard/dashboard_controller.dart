import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_reviews_api.dart';
import 'package:iu_auditor_admin/apis/new_faculty/new_faculty_apis.dart';

class DashboardController extends GetxController {
  final NewFacultyApis  _teacherApi = NewFacultyApis();
  final AuditReviewsApi _reviewApi  = AuditReviewsApi();

  var totalTeachers   = 0.obs;
  var pendingAudits   = 0.obs;
  var completedAudits = 0.obs;
  var auditScore      = '—'.obs;   // no rating column in DB — kept as placeholder
  var isLoading       = false.obs;

  RxList<Map<String, dynamic>> activities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      final teacherResponse = await _teacherApi.getAllTeachers();
      final reviewResponse  = await _reviewApi.getAllReviews();

      if (teacherResponse.success) {
        totalTeachers.value = teacherResponse.data.length;
      }

      if (reviewResponse.success) {
        final list = reviewResponse.data;

        completedAudits.value =
            list.where((r) => r.status.toLowerCase() == 'completed').length;

        pendingAudits.value =
            list.where((r) => r.status.toLowerCase() == 'pending').length;

        // No overallRating in DB — show completed/total ratio instead
        final total = list.length;
        if (total > 0) {
          final pct = ((completedAudits.value / total) * 100).round();
          auditScore.value = '$pct%';
        }

        // Recent activity — last 5 completed reviews
        activities.assignAll(
          list
              .where((r) => r.status.toLowerCase() == 'completed')
              .take(5)
              .map((r) => {
                    'name':   r.auditorName  ?? 'Auditor',
                    'action': 'submitted audit for',
                    'target': r.teacherName  ?? 'Teacher',
                    'status': 'completed',
                    'time':   _timeAgo(r.createdAt),
                  })
              .toList(),
        );
      }
    } catch (_) {
      // non-fatal — dashboard shows zeros on failure
    } finally {
      isLoading.value = false;
    }
  }

  String _timeAgo(String iso) {
    try {
      final d = DateTime.now().difference(DateTime.parse(iso));
      if (d.inDays > 0)    return '${d.inDays}d ago';
      if (d.inHours > 0)   return '${d.inHours}h ago';
      if (d.inMinutes > 0) return '${d.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }
}