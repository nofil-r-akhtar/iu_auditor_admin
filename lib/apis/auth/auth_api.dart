import 'package:iu_auditor_admin/apis/api_request.dart';
import 'package:iu_auditor_admin/apis/apis_end_points.dart';
import 'package:iu_auditor_admin/const/enums.dart';
import 'package:iu_auditor_admin/modal_class/user/user_login.dart';
import 'package:iu_auditor_admin/modal_class/user/user_profile.dart';

class Auth {

  ApiRequest request = ApiRequest();
  ApisEndPoints api = ApisEndPoints();

  Future<UserLoginResponse> login({
    required String email,
    required String password,
  }) async {
      final response = await request.makeRequest(
        url: api.login,
        method: Request.post,
        params: {
          'email': email,
          'password': password,
        },
      );
      return UserLoginResponse.fromJson(response);  
  }

  Future<Map<String, dynamic>> forgetPassword({
    required String email,
  }) async {

      final response = await request.makeRequest(
        url: api.forgotPassword,
        method: Request.post,
        params: {
          'email': email,
        },
      );
      return response;
   
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {

      final response = await request.makeRequest(
        url: api.verifyOtp,
        method: Request.post,
        params: {
          'email': email,
          'otp_code': otp,
        },
      );
      return response;
 
  }

  Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {

      final response = await request.makeRequest(
        url: api.resendOtp,
        method: Request.post,
        params: {
          'email': email,
        },
      );
      return response;
    
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {

      final response = await request.makeRequest(
        url: api.changePassword,
        method: Request.post,
        params: {
          'email': email,
          'otp_code': otp,
          'new_password': newPassword,
        },
      );
      return response;
    
  }


  Future<UserProfile> fetchProfile() async {
    
      final response = await request.makeRequest(
        url: api.userProfile,
        method: Request.get,
      );

      if (response['success'].toString() == 'false') {
        throw Exception(response['message'] ?? 'Failed to fetch profile');
      }

      return UserProfile.fromJson(response['data']);
    
  }
}