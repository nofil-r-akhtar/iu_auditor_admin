enum FontFamily { inter }

enum Auth { login, forgotPassword, resetPassword, otp }

enum Request { get, post, put, del, patch }

enum Env { dev, local }

/// Teacher audit status — mirrors the `teacher_status` PostgreSQL enum exactly.
/// Values: pending | scheduled | completed | cancelled
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

/// Mirrors the Supabase `department` PostgreSQL enum exactly.
enum Department {
  computerScience('Computer Science'),
  businessAdministration('Business Adminstriation'), // exact DB spelling
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