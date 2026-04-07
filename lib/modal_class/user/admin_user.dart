class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? department;
  final String createdAt;

  AdminUser({required this.id, required this.name, required this.email,
    required this.role, this.department, required this.createdAt});

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    role: json['role']?.toString() ?? '',
    department: json['department']?.toString(),
    createdAt: json['created_at']?.toString() ?? '',
  );

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  String get roleLabel {
    switch (role) {
      case 'super_admin':     return 'Super Admin';
      case 'admin':           return 'Admin';
      case 'department_head': return 'Department Head';
      case 'senior_lecturer': return 'Senior Lecturer';
      default: return role.replaceAll('_', ' ').toUpperCase();
    }
  }
}

class AdminUsersResponse {
  final bool success;
  final String message;
  final int total;
  final List<AdminUser> data;

  AdminUsersResponse({required this.success, required this.message,
    required this.total, required this.data});

  factory AdminUsersResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return AdminUsersResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      total: json['total'] as int? ?? list.length,
      data: list.map((e) => AdminUser.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
