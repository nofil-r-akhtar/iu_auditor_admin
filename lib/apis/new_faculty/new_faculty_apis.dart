import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/new_faculty/fetch_new_faculty.dart';

class NewFacultyApis {
  ApiRequest request = ApiRequest();
  ApisEndPoints api = ApisEndPoints();

   // GET /api/teachers/
  Future<NewFacultyResponse> getAllTeachers() async {
      final response = await request.makeRequest(
        url: api.newFaculty,
        method: Request.get,
      );
      return NewFacultyResponse.fromJson(response);

  }

  // POST /api/teachers/
  Future<Map<String, dynamic>> createTeacher({
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await request.makeRequest(
        url: api.newFaculty,
        method: Request.post,
        params: params,
      );
      return response;
    } catch (e) {
      throw Exception('Create teacher failed: $e');
    }
  }

  // GET /api/teachers/{id}
  Future<Map<String, dynamic>> getTeacherById({
    required String id,
  }) async {
    try {
      final response = await request.makeRequest(
        url: '${api.newFaculty}$id',
        method: Request.get,
      );
      return response;
    } catch (e) {
      throw Exception('Get teacher by id failed: $e');
    }
  }

  // PUT /api/teachers/{id}
  Future<Map<String, dynamic>> updateTeacher({
    required String id,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await request.makeRequest(
        url: '${api.newFaculty}$id',
        method: Request.put,
        params: params,
      );
      return response;
    } catch (e) {
      throw Exception('Update teacher failed: $e');
    }
  }

  // DELETE /api/teachers/{id}
  Future<Map<String, dynamic>> deleteTeacher({
    required String id,
  }) async {
    try {
      final response = await request.makeRequest(
        url: '${api.newFaculty}$id',
        method: Request.del,
      );
      return response;
    } catch (e) {
      throw Exception('Delete teacher failed: $e');
    }
  }

  // PATCH /api/teachers/{id}/status
  Future<Map<String, dynamic>> updateTeacherStatus({
    required String id,
    required Map<String, dynamic> params,
  }) async {
    try {
      final response = await request.makeRequest(
        url: '${api.newFaculty}$id/status',
        method: Request.patch,
        params: params,
      );
      return response;
    } catch (e) {
      throw Exception('Update teacher status failed: $e');
    }
  }
}