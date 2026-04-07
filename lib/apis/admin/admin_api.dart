import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/user/admin_user.dart';

class AdminApi {
  final ApiRequest _request = ApiRequest();
  final ApisEndPoints _api = ApisEndPoints();

  Future<AdminUsersResponse> getAllUsers() async {
    final response = await _request.makeRequest(url: _api.adminUsers, method: Request.get);
    return AdminUsersResponse.fromJson(response);
  }

  Future<AdminUsersResponse> getSeniorLecturers() async {
    final response = await _request.makeRequest(url: _api.adminSeniorLecturers, method: Request.get);
    return AdminUsersResponse.fromJson(response);
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    return await _request.makeRequest(url: '${_api.adminUsers}$id', method: Request.get);
  }

  Future<Map<String, dynamic>> createUser({
    required String name,
    required String email,
    required String password,
    required String role,
    String? department,
  }) async {
    return await _request.makeRequest(
      url: _api.adminUsers,
      method: Request.post,
      params: {
        'name': name, 'email': email, 'password': password, 'role': role,
        if (department != null) 'department': department,
      },
    );
  }

  Future<Map<String, dynamic>> updateUser({
    required String id,
    String? name, String? email, String? role, String? department, String? password,
  }) async {
    return await _request.makeRequest(
      url: '${_api.adminUsers}$id',
      method: Request.put,
      params: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (role != null) 'role': role,
        if (department != null) 'department': department,
        if (password != null) 'password': password,
      },
    );
  }

  Future<Map<String, dynamic>> deleteUser(String id) async {
    return await _request.makeRequest(url: '${_api.adminUsers}$id', method: Request.del);
  }
}
