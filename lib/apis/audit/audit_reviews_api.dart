import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_review.dart';

class AuditReviewsApi {
  final ApiRequest _request = ApiRequest();
  final ApisEndPoints _api = ApisEndPoints();

  // GET /api/audit-reviews/
  Future<AuditReviewsResponse> getAllReviews() async {
    return AuditReviewsResponse.fromJson(
        await _request.makeRequest(url: _api.auditReviews, method: Request.get));
  }

  // GET /api/audit-reviews/{id}  — full report with answers
  Future<Map<String, dynamic>> getReviewById(String id) async {
    return await _request.makeRequest(
        url: '${_api.auditReviews}$id', method: Request.get);
  }

  // GET /api/audit-reviews/teacher/{teacher_id}
  Future<AuditReviewsResponse> getReviewsByTeacher(String teacherId) async {
    return AuditReviewsResponse.fromJson(await _request.makeRequest(
        url: _api.auditReviewsByTeacher(teacherId), method: Request.get));
  }

  // POST /api/audit-reviews/
  // Backend params: teacher_id (required), form_id (required), notes (optional)
  // reviewed_by is set automatically from JWT token on the backend
  Future<Map<String, dynamic>> createReview({
    required String teacherId,
    required String formId,
    required String reviewedBy,   // 🔑 senior lecturer id (REQUIRED)
    String? notes,
  }) async {
    return await _request.makeRequest(
      url: _api.auditReviews,
      method: Request.post,
      params: {
        'teacher_id':  teacherId,
        'form_id':     formId,
        'reviewed_by': reviewedBy,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
  }

  // DELETE /api/audit-reviews/{id}
  Future<Map<String, dynamic>> deleteReview(String id) async {
    return await _request.makeRequest(
        url: '${_api.auditReviews}$id', method: Request.del);
  }
}