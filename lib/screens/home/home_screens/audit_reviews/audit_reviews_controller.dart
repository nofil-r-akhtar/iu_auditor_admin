import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuditReviewController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  // Observable list of reviews matching your screenshot
  RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[
    {
      "teacher": "Mr. Ali Khan",
      "department": "Computer Science",
      "auditor": "Dr. Sarah Ahmed",
      "date": "2024-03-15",
      "status": "Completed",
      "rating": "4.5",
    },
    {
      "teacher": "Ms. Fatima Noor",
      "department": "Business Admin",
      "auditor": "Dr. Ayesha Khan",
      "date": "2024-03-14",
      "status": "Completed",
      "rating": "3.8",
    },
    {
      "teacher": "Mr. Bilal Raza",
      "department": "Engineering",
      "auditor": "Prof. John Doe",
      "date": "2024-03-12",
      "status": "Completed",
      "rating": "4.2",
    },
    {
      "teacher": "Ms. Zainab Ahmed",
      "department": "Social Sciences",
      "auditor": "Dr. Ayesha Khan",
      "date": "2024-03-10",
      "status": "Completed",
      "rating": "4.0",
    },
  ].obs;

  @override
  void onClose() {
    searchController.dispose(); // Cleanup
    super.onClose();
  }
}
