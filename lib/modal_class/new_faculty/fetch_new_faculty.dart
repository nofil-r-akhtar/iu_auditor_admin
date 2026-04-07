class NewFaculty {
  final String id;
  final String name;
  final String email;
  final String contactNo;
  final String department;
  final String specialization;
  final String? auditDate;
  final String? auditTime;
  final String status;
  final String createdAt;
  final String updatedAt;

  NewFaculty({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.department,
    required this.specialization,
    this.auditDate,
    this.auditTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NewFaculty.fromJson(Map<String, dynamic> json) {
    return NewFaculty(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contact_no'] ?? '',
      department: json['department'] ?? '',
      specialization: json['specialization'] ?? '',
      auditDate: json['audit_date'],
      auditTime: json['audit_time'],
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class NewFacultyResponse {
  final bool success;
  final String message;
  final int total;
  final List<NewFaculty> data;

  NewFacultyResponse({
    required this.success,
    required this.message,
    required this.total,
    required this.data,
  });

  factory NewFacultyResponse.fromJson(Map<String, dynamic> json) {
    return NewFacultyResponse(
      success: json['success'],
      message: json['message'],
      total: json['total'] ?? 0,
      data: (json['data'] as List)
          .map((item) => NewFaculty.fromJson(item))
          .toList(),
    );
  }
}