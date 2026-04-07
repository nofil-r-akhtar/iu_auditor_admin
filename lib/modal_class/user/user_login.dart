class UserLoginResponse {
  final bool success;
  final String message;
  final UserLoginData data;

  UserLoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      success: json['success'],
      message: json['message'],
      data: UserLoginData.fromJson(json['data']),
    );
  }
}

class UserLoginData {
  final String accessToken;
  final String tokenType;
  final bool mustChangePassword;
  final UserLogin user;

  UserLoginData({
    required this.accessToken,
    required this.tokenType,
    required this.mustChangePassword,
    required this.user,
  });

  factory UserLoginData.fromJson(Map<String, dynamic> json) {
    return UserLoginData(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      mustChangePassword: json['must_change_password'],
      user: UserLogin.fromJson(json['user']),
    );
  }
}

class UserLogin {
  final String id;
  final String name;
  final String email;
  final String role;

  UserLogin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}