import 'package:get/get.dart';

class DashboardController extends GetxController {
  var totalTeachers = 24.obs;
  var pendingAudits = 8.obs;
  var completedAudits = 16.obs;
  var auditScore = "4.2/5".obs;

  final List<Map<String, dynamic>> activities = [
    {
      "name": "Dr. Sarah Ahmed",
      "action": "submitted audit for",
      "target": "Mr. Ali Khan",
      "status": "completed",
      "time": "2 hours ago",
    },
    {
      "name": "Admin",
      "action": "added new teacher",
      "target": "Ms. Fatima Noor",
      "status": "new",
      "time": "5 hours ago",
    },
  ].obs;
}
