import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_auditor_admin/apis/audit/audit_reviews_api.dart';
import 'package:iu_auditor_admin/app_theme/colors.dart';
import 'package:iu_auditor_admin/components/app_container.dart';
import 'package:iu_auditor_admin/components/app_dialog.dart';
import 'package:iu_auditor_admin/components/app_text.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_review.dart';
import 'assign_review/assign_review.dart';
import 'assign_review/assign_review_controller.dart';

class AuditReviewController extends GetxController {
  final AuditReviewsApi _api = AuditReviewsApi();
  final TextEditingController searchController = TextEditingController();

  RxList<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  var isLoading       = false.obs;
  var isReportLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  // ── FETCH ALL ──────────────────────────────────────────────
  Future<void> fetchReviews() async {
    try {
      isLoading.value = true;
      final r = await _api.getAllReviews();
      if (!r.success) { Get.snackbar('Error', r.message); return; }
      reviews.assignAll(r.data.map(_toViewMap).toList());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _toViewMap(AuditReview r) => {
    'id':         r.id,
    'teacher':    r.teacherName       ?? '—',
    'department': r.teacherDepartment ?? '—',
    'auditor':    r.auditorName       ?? '—',
    'formTitle':  r.formTitle         ?? '—',
    'date':       r.dateOnly,
    'status':     r.statusLabel,
    'notes':      r.notes             ?? '',
  };

  // ── ASSIGN REVIEW ──────────────────────────────────────────
  void openAssignDialog() {
    Get.put(AssignReviewController());
    AppDialog.show(
      title: 'Assign Audit Review',
      content: const AssignReview(),
      confirmText: 'Assign Review',
      width: 560,
      onConfirm: () async {
        await Get.find<AssignReviewController>().assignReview();
        await fetchReviews();
        Get.delete<AssignReviewController>();
      },
      onCancel: () {
        Get.back();
        Get.delete<AssignReviewController>();
      },
    );
  }

  // ── VIEW FULL REPORT ───────────────────────────────────────
  Future<void> openFullReport(String reviewId) async {
    try {
      isReportLoading.value = true;

      final res = await _api.getReviewById(reviewId);

      if (res['success'] != true) {
        Get.snackbar('Error', res['message'] ?? 'Failed to load report');
        return;
      }

      final data    = res['data'] as Map<String, dynamic>;
      final teacher = data['teachers']    as Map<String, dynamic>? ?? {};
      final form    = data['audit_forms'] as Map<String, dynamic>? ?? {};
      final auditor = data['users']       as Map<String, dynamic>? ?? {};
      final answers = data['answers']     as List<dynamic>? ?? [];

      AppDialog.show(
        title: 'Full Audit Report',
        content: _FullReportContent(
          teacherName:    teacher['name']?.toString() ?? '—',
          teacherDept:    teacher['department']?.toString() ?? '—',
          teacherSpec:    teacher['specialization']?.toString() ?? '—',
          formTitle:      form['title']?.toString() ?? '—',
          auditorName:    auditor['name']?.toString() ?? '—',
          status:         data['status']?.toString() ?? 'pending',
          notes:          data['notes']?.toString() ?? '',
          answers:        answers,
        ),
        showActions: false,
        width: 640,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isReportLoading.value = false;
    }
  }

  // ── DELETE ─────────────────────────────────────────────────
  void confirmDelete(Map<String, dynamic> review) {
    AppDialog.showDeleteConfirm(
      teacherName: review['teacher'] as String? ?? 'this review',
      onConfirm: () => _performDelete(review['id'] as String),
    );
  }

  Future<void> _performDelete(String id) async {
    try {
      final res = await _api.deleteReview(id);
      if (res['success'] == true) {
        reviews.removeWhere((r) => r['id'] == id);
        Get.snackbar('Success', 'Review deleted');
      } else {
        Get.snackbar('Error', res['message'] ?? 'Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

// ── Full Report Dialog Content ───────────────────────────────
class _FullReportContent extends StatelessWidget {
  final String teacherName;
  final String teacherDept;
  final String teacherSpec;
  final String formTitle;
  final String auditorName;
  final String status;
  final String notes;
  final List<dynamic> answers;

  const _FullReportContent({
    required this.teacherName,
    required this.teacherDept,
    required this.teacherSpec,
    required this.formTitle,
    required this.auditorName,
    required this.status,
    required this.notes,
    required this.answers,
  });

  Color get _statusColor =>
      status == 'completed' ? const Color(0xFF2E7D32) : const Color(0xFFE65100);
  Color get _statusBg =>
      status == 'completed' ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Meta info ──────────────────────────────────────
        AppContainer(
          bgColor: bgColor,
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _infoRow('Teacher',    teacherName),
              const SizedBox(height: 8),
              _infoRow('Department', teacherDept),
              const SizedBox(height: 8),
              _infoRow('Specialization', teacherSpec),
              const SizedBox(height: 8),
              _infoRow('Audit Form', formTitle),
              const SizedBox(height: 8),
              _infoRow('Auditor',    auditorName),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextRegular(
                      text: 'Status', color: iconColor, fontSize: 13),
                  AppContainer(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    borderRadius: BorderRadius.circular(20),
                    bgColor: _statusBg,
                    child: AppTextMedium(
                      text: status == 'completed' ? 'Completed' : 'Pending',
                      color: _statusColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Notes ──────────────────────────────────────────
        if (notes.isNotEmpty) ...[
          const SizedBox(height: 16),
          AppTextSemiBold(
              text: 'Notes', color: navyBlueColor, fontSize: 13),
          const SizedBox(height: 6),
          AppContainer(
            bgColor: const Color(0xFFFFF9C4),
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(12),
            child: AppTextRegular(
                text: notes, color: navyBlueColor, fontSize: 13),
          ),
        ],

        // ── Answers ────────────────────────────────────────
        const SizedBox(height: 16),
        AppTextSemiBold(
          text: answers.isEmpty
              ? 'No answers submitted yet'
              : 'Answers (${answers.length})',
          color: navyBlueColor,
          fontSize: 13,
        ),
        const SizedBox(height: 10),

        if (answers.isEmpty)
          AppContainer(
            bgColor: bgColor,
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: AppTextRegular(
                text: 'This review is still pending submission.',
                color: descriptiveColor,
              ),
            ),
          )
        else
          ...answers.asMap().entries.map((entry) {
            final i = entry.key;
            final a = entry.value as Map<String, dynamic>;
            final q = a['audit_questions'] as Map<String, dynamic>? ?? {};
            final questionText = q['question_text']?.toString() ?? '—';
            final questionType = q['question_type']?.toString() ?? '';
            final answerDisplay = _formatAnswer(a, questionType);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppContainer(
                bgColor: whiteColor,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      AppContainer(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        borderRadius: BorderRadius.circular(4),
                        bgColor: bgColor,
                        child: AppTextRegular(
                            text: 'Q${i + 1}',
                            color: descriptiveColor,
                            fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextMedium(
                            text: questionText,
                            color: navyBlueColor,
                            fontSize: 13),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.check_circle_outline,
                          size: 15, color: Colors.green),
                      const SizedBox(width: 6),
                      Flexible(
                        child: AppTextRegular(
                          text: answerDisplay,
                          color: navyBlueColor,
                          fontSize: 13,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  String _formatAnswer(Map<String, dynamic> a, String type) {
    switch (type) {
      case 'rating':
        final r = a['answer_rating'];
        return r != null ? '⭐ $r / 5' : '—';
      case 'paragraph':
        return a['answer_text']?.toString() ?? '—';
      case 'mcq':
        return a['answer_mcq']?.toString() ?? '—';
      case 'yes_no':
        final yn = a['answer_yes_no'];
        if (yn == null) return '—';
        return yn == true ? 'Yes' : 'No';
      default:
        return a['answer_text']?.toString() ?? '—';
    }
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextRegular(text: label, color: iconColor, fontSize: 13),
        Flexible(
          child: AppTextMedium(
            text: value,
            color: navyBlueColor,
            fontSize: 13,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}