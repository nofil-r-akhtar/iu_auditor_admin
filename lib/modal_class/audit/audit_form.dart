class AuditForm {
  final String id;
  final String title;
  final String? description;
  final String department;
  final bool isActive;
  final String createdAt;
  final List<AuditQuestion> questions;

  AuditForm({required this.id, required this.title, this.description,
    required this.department, required this.isActive, required this.createdAt,
    this.questions = const []});

  factory AuditForm.fromJson(Map<String, dynamic> json) {
    final q = json['questions'] as List<dynamic>? ?? [];
    return AuditForm(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      department: json['department']?.toString() ?? '',
      isActive: json['is_active'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      questions: q.map((e) => AuditQuestion.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class AuditQuestion {
  final String id;
  final String formId;
  final String questionText;
  final String questionType;
  final List<String> options;
  final bool isRequired;
  final int orderIndex;
  final String createdAt;

  AuditQuestion({required this.id, required this.formId, required this.questionText,
    required this.questionType, this.options = const [],
    required this.isRequired, required this.orderIndex, required this.createdAt});

  factory AuditQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    List<String> opts = rawOptions is List ? rawOptions.map((e) => e.toString()).toList() : [];
    return AuditQuestion(
      id: json['id']?.toString() ?? '',
      formId: json['form_id']?.toString() ?? '',
      questionText: json['question_text']?.toString() ?? '',
      questionType: json['question_type']?.toString() ?? 'rating',
      options: opts,
      isRequired: json['is_required'] == true,
      orderIndex: json['order_index'] as int? ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  String get typeLabel {
    switch (questionType) {
      case 'rating':    return 'Rating Scale (1-5)';
      case 'paragraph': return 'Text Feedback';
      case 'mcq':       return 'Multiple Choice';
      case 'yes_no':    return 'Yes / No';
      default:          return questionType;
    }
  }
}

class AuditFormsResponse {
  final bool success;
  final String message;
  final int total;
  final List<AuditForm> data;

  AuditFormsResponse({required this.success, required this.message,
    required this.total, required this.data});

  factory AuditFormsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return AuditFormsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      total: json['total'] as int? ?? list.length,
      data: list.map((e) => AuditForm.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class AuditQuestionsResponse {
  final bool success;
  final String message;
  final int total;
  final List<AuditQuestion> data;

  AuditQuestionsResponse({required this.success, required this.message,
    required this.total, required this.data});

  factory AuditQuestionsResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? [];
    return AuditQuestionsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      total: json['total'] as int? ?? list.length,
      data: list.map((e) => AuditQuestion.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
