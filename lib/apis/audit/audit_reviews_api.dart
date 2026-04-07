import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_review.dart';

class AuditReviewsApi {
  final ApiRequest _request = ApiRequest();
  final ApisEndPoints _api = ApisEndPoints();

  Future<AuditReviewsResponse> getAllReviews() async {
    return AuditReviewsResponse.fromJson(
        await _request.makeRequest(url: _api.auditReviews, method: Request.get));
  }

  Future<Map<String, dynamic>> getReviewById(String id) async {
    return await _request.makeRequest(url: '${_api.auditReviews}$id', method: Request.get);
  }

  Future<AuditReviewsResponse> getReviewsByTeacher(String teacherId) async {
    return AuditReviewsResponse.fromJson(
        await _request.makeRequest(url: _api.auditReviewsByTeacher(teacherId), method: Request.get));
  }

  Future<Map<String, dynamic>> createReview({
    required String teacherId, required String formId, required String auditorId,
  }) async {
    return await _request.makeRequest(
      url: _api.auditReviews, method: Request.post,
      params: {'teacher_id': teacherId, 'form_id': formId, 'auditor_id': auditorId},
    );
  }

  Future<Map<String, dynamic>> deleteReview(String id) async {
    return await _request.makeRequest(url: '${_api.auditReviews}$id', method: Request.del);
  }
}
