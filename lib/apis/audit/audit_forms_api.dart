import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/audit/audit_form.dart';

class AuditFormsApi {
  final ApiRequest _request = ApiRequest();
  final ApisEndPoints _api = ApisEndPoints();

  Future<AuditFormsResponse> getAllForms() async {
    return AuditFormsResponse.fromJson(
        await _request.makeRequest(url: _api.auditForms, method: Request.get));
  }

  Future<AuditFormsResponse> getFormsByDepartment(String department) async {
    return AuditFormsResponse.fromJson(
        await _request.makeRequest(url: _api.auditFormsByDepartment(department), method: Request.get));
  }

  Future<Map<String, dynamic>> getFormById(String id) async {
    return await _request.makeRequest(url: '${_api.auditForms}$id', method: Request.get);
  }

  Future<Map<String, dynamic>> createForm({
    required String title, required String department, String? description, bool isActive = true,
  }) async {
    return await _request.makeRequest(
      url: _api.auditForms, method: Request.post,
      params: {'title': title, 'department': department,
        if (description != null) 'description': description, 'is_active': isActive},
    );
  }

  Future<Map<String, dynamic>> updateForm({
    required String id, String? title, String? department, String? description, bool? isActive,
  }) async {
    return await _request.makeRequest(
      url: '${_api.auditForms}$id', method: Request.put,
      params: {
        if (title != null) 'title': title, if (department != null) 'department': department,
        if (description != null) 'description': description, if (isActive != null) 'is_active': isActive,
      },
    );
  }

  Future<Map<String, dynamic>> deleteForm(String id) async {
    return await _request.makeRequest(url: '${_api.auditForms}$id', method: Request.del);
  }

  Future<AuditQuestionsResponse> getQuestions(String formId) async {
    return AuditQuestionsResponse.fromJson(
        await _request.makeRequest(url: _api.auditFormQuestions(formId), method: Request.get));
  }

  Future<Map<String, dynamic>> addQuestion({
    required String formId, required String questionText,
    required String questionType, List<String>? options, bool isRequired = true,
  }) async {
    return await _request.makeRequest(
      url: _api.auditFormQuestions(formId), method: Request.post,
      params: {'question_text': questionText, 'question_type': questionType,
        if (options != null) 'options': options, 'is_required': isRequired},
    );
  }

  Future<Map<String, dynamic>> updateQuestion({
    required String formId, required String questionId,
    String? questionText, String? questionType, List<String>? options, bool? isRequired,
  }) async {
    return await _request.makeRequest(
      url: '${_api.auditFormQuestions(formId)}$questionId', method: Request.put,
      params: {
        if (questionText != null) 'question_text': questionText,
        if (questionType != null) 'question_type': questionType,
        if (options != null) 'options': options,
        if (isRequired != null) 'is_required': isRequired,
      },
    );
  }

  Future<Map<String, dynamic>> deleteQuestion({required String formId, required String questionId}) async {
    return await _request.makeRequest(
        url: '${_api.auditFormQuestions(formId)}$questionId', method: Request.del);
  }
}
