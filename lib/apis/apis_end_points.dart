class ApisEndPoints {
  static String startUrl = "https://iu-auditor-admin-backend.onrender.com/api/";

  // AUTHENTICATION
  final String login = "auth/login";
  final String forgotPassword = "auth/forgot-password";
  final String verifyOtp = "auth/verify-otp";
  final String resendOtp = "auth/resend-otp";
  final String changePassword = "auth/change-password";
  final String userProfile = "auth/me";
  final String firstLoginChangePassword = "auth/first-login-change-password";

  // TEACHERS (New Faculty)
  final String newFaculty = "teachers/";

  // ADMIN - USER MANAGEMENT
  final String adminUsers = "admin/users/";
  final String adminSeniorLecturers = "admin/senior-lecturers";

  // AUDIT FORMS
  final String auditForms = "audit/forms/";
  String auditFormsByDepartment(String dept) => "audit/forms/department/$dept";
  String auditFormQuestions(String formId) => "audit/forms/$formId/questions/";

  // AUDIT REVIEWS
  final String auditReviews = "audit-reviews/";
  String auditReviewsByTeacher(String teacherId) => "audit-reviews/teacher/$teacherId";
}
