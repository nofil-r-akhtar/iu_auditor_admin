class AuditReview {
  final String id;
  final String teacherId;
  final String formId;
  final String auditorId;
  final String status;
  final double? overallRating;
  final String? comments;
  final String createdAt;
  final String? teacherName;
  final String? teacherEmail;
  final String? teacherDepartment;
  final String? formTitle;
  final String? auditorName;

  AuditReview({required this.id, required this.teacherId, required this.formId,
    required this.auditorId, required this.status, this.overallRating,
    this.comments, required this.createdAt, this.teacherName, this.teacherEmail,
    this.teacherDepartment, this.formTitle, this.auditorName});

  factory AuditReview.fromJson(Map<String, dynamic> json) {
    final teacher = json['teachers'] as Map<String, dynamic>?;
    final form    = json['audit_forms'] as Map<String, dynamic>?;
    final auditor = json['users'] as Map<String, dynamic>?;
    final raw     = json['overall_rating'];
    return AuditReview(
      id: json['id']?.toString() ?? '',
      teacherId: json['teacher_id']?.toString() ?? '',
      formId: json['form_id']?.toString() ?? '',
      auditorId: json['auditor_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      overallRating: raw != null ? (raw as num).toDouble() : null,
      comments: json['comments']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      teacherName: teacher?['name']?.toString(),
      teacherEmail: teacher?['email']?.toString(),
      teacherDepartment: teacher?['department']?.toString(),
      formTitle: form?['title']?.toString(),
      auditorName: auditor?['name']?.toString(),
    );
  }

  String get dateOnly => createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'completed':   return 'Completed';
      case 'in_progress': return 'In Progress';
      default:            return 'Pending';
    }
  }

  String get ratingDisplay => overallRating != null ? overallRating!.toStringAsFixed(1) : 'N/A';
}

class AuditReviewsResponse {
  final bool success;
  final String message;
  final int total;
  final List<AuditReview> data;

  AuditReviewsResponse({required this.success, required this.message,
    required this.total, required this.data});

  factory AuditReviewsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return AuditReviewsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      total: json['total'] as int? ?? list.length,
      data: list.map((e) => AuditReview.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
