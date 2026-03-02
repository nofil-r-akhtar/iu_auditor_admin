import 'package:get/get.dart';

class AuditQuestionsController extends GetxController {
  final List<String> departments = [
    "All Departments",
    "Computer Science",
    "Business Admin",
    "Engineering",
    "Social Sciences",
    "Law",
  ];

  var selectedDepartment = "Computer Science".obs;

  RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[
    {
      "question": "How effectively does the teacher explain complex concepts?",
      "category": "Teaching Methodology",
      "type": "Rating Scale (1-5)",
      "department": "Computer Science",
    },
    {
      "question": "Does the teacher encourage student participation?",
      "category": "Classroom Management",
      "type": "Rating Scale (1-5)",
      "department": "All",
    },
    {
      "question": "Provide specific examples of areas for improvement.",
      "category": "General Feedback",
      "type": "Text Feedback",
      "department": "All",
    },
  ].obs;

  void changeDepartment(String dept) {
    selectedDepartment.value = dept;
  }
}
