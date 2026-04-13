enum FontFamily { inter }

enum Auth { login, forgotPassword, resetPassword, otp }

enum Request { get, post, put, del, patch }

enum Env { dev, local }

/// Teacher audit status — mirrors the `teacher_status` PostgreSQL enum.
enum TeacherStatus {
  pending('pending', 'Pending'),
  scheduled('scheduled', 'Scheduled'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  const TeacherStatus(this.apiValue, this.displayLabel);
  final String apiValue;
  final String displayLabel;

  static TeacherStatus fromApiValue(String value) {
    return TeacherStatus.values.firstWhere(
      (s) => s.apiValue == value,
      orElse: () => TeacherStatus.pending,
    );
  }
}

/// User roles — mirrors the `users_role` PostgreSQL enum.
/// Only [seniorLecturer] is used when creating an auditor from this panel.
enum UserRole {
  superAdmin('super_admin', 'Super Admin'),
  admin('admin', 'Admin'),
  departmentHead('department_head', 'Department Head'),
  seniorLecturer('senior_lecturer', 'Senior Lecturer');

  const UserRole(this.apiValue, this.displayLabel);
  final String apiValue;
  final String displayLabel;

  static UserRole? fromApiValue(String value) {
    for (final r in UserRole.values) {
      if (r.apiValue == value) return r;
    }
    return null;
  }
}

/// Mirrors the Supabase `department` PostgreSQL enum exactly.
enum Department {
  computerScience('Computer Science'),
  businessAdministration('Business Adminstriation'),
  mediaScience('Media Science'),
  softwareEngineering('Software Engineering'),
  engineering('Engineering');

  const Department(this.label);
  final String label;

  static Department? fromLabel(String value) {
    for (final d in Department.values) {
      if (d.label == value) return d;
    }
    return null;
  }
}

enum QuestionType {
  rating('rating', 'Rating Scale (1-5)'),
  paragraph('paragraph', 'Text Feedback'),
  mcq('mcq', 'Multiple Choice'),
  yesNo('yes_no', 'Yes / No');

  const QuestionType(this.apiValue, this.displayLabel);
  final String apiValue;      // sent to API: 'rating', 'paragraph', 'mcq', 'yes_no'
  final String displayLabel;  // shown in UI dropdown

  static QuestionType fromApiValue(String value) {
    return QuestionType.values.firstWhere(
      (t) => t.apiValue == value,
      orElse: () => QuestionType.rating,
    );
  }
}