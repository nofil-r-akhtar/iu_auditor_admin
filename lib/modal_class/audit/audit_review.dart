/// Single audit review — joined with teachers, audit_forms, users
class AuditReview {
  final String id;
  final String teacherId;
  final String formId;
  final String reviewedBy;   // was "auditor_id", DB column is "reviewed_by"
  final String status;       // pending | completed
  final String? notes;
  final String createdAt;

  // Joined fields from backend select(*)
  final String? teacherName;
  final String? teacherEmail;
  final String? teacherDepartment;
  final String? teacherSpecialization;
  final String? formTitle;
  final String? formDepartment;
  final String? auditorName;  // from users table
  final String? auditorEmail;

  AuditReview({
    required this.id,
    required this.teacherId,
    required this.formId,
    required this.reviewedBy,
    required this.status,
    this.notes,
    required this.createdAt,
    this.teacherName,
    this.teacherEmail,
    this.teacherDepartment,
    this.teacherSpecialization,
    this.formTitle,
    this.formDepartment,
    this.auditorName,
    this.auditorEmail,
  });

  factory AuditReview.fromJson(Map<String, dynamic> json) {
    final teacher = json['teachers']   as Map<String, dynamic>?;
    final form    = json['audit_forms'] as Map<String, dynamic>?;
    final auditor = json['users']       as Map<String, dynamic>?;

    return AuditReview(
      id:                   json['id']?.toString() ?? '',
      teacherId:            json['teacher_id']?.toString() ?? '',
      formId:               json['form_id']?.toString() ?? '',
      reviewedBy:           json['reviewed_by']?.toString() ?? '',
      status:               json['status']?.toString() ?? 'pending',
      notes:                json['notes']?.toString(),
      createdAt:            json['created_at']?.toString() ?? '',
      teacherName:          teacher?['name']?.toString(),
      teacherEmail:         teacher?['email']?.toString(),
      teacherDepartment:    teacher?['department']?.toString(),
      teacherSpecialization:teacher?['specialization']?.toString(),
      formTitle:            form?['title']?.toString(),
      formDepartment:       form?['department']?.toString(),
      auditorName:          auditor?['name']?.toString(),
      auditorEmail:         auditor?['email']?.toString(),
    );
  }

  String get dateOnly =>
      createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'completed': return 'Completed';
      default:          return 'Pending';
    }
  }
}

class AuditReviewsResponse {
  final bool success;
  final String message;
  final int total;
  final List<AuditReview> data;

  AuditReviewsResponse({
    required this.success,
    required this.message,
    required this.total,
    required this.data,
  });

  factory AuditReviewsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return AuditReviewsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      total:   json['total'] as int? ?? list.length,
      data:    list
          .map((e) => AuditReview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}