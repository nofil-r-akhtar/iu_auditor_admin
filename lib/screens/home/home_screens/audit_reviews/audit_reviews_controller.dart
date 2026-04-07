import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_reviews_api.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_review.dart';

class AuditReviewController extends GetxController {
  final AuditReviewsApi _api = AuditReviewsApi();
  final TextEditingController searchController = TextEditingController();

  // Same Map keys the existing view already reads — no view changes needed
  RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() { super.onInit(); fetchReviews(); }

  Future<void> fetchReviews() async {
    try {
      isLoading.value = true;
      final r = await _api.getAllReviews();
      if (!r.success) { Get.snackbar('Error', r.message); return; }
      reviews.assignAll(r.data.map(_toViewMap).toList());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally { isLoading.value = false; }
  }

  Map<String, dynamic> _toViewMap(AuditReview r) => {
    'id':         r.id,
    'teacher':    r.teacherName       ?? '—',
    'department': r.teacherDepartment ?? '—',
    'auditor':    r.auditorName       ?? '—',
    'date':       r.dateOnly,
    'status':     r.statusLabel,
    'rating':     r.ratingDisplay,
  };

  Future<void> deleteReview(String id) async {
    try {
      final res = await _api.deleteReview(id);
      if (res['success'] == true) {
        reviews.removeWhere((r) => r['id'] == id);
        Get.snackbar('Success', 'Review deleted');
      } else { Get.snackbar('Error', res['message'] ?? 'Delete failed'); }
    } catch (e) { Get.snackbar('Error', e.toString()); }
  }

  @override
  void onClose() { searchController.dispose(); super.onClose(); }
}
