import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences — on Flutter web this uses browser localStorage.
class StorageService {
  static const _tokenKey     = 'auth_token';
  static const _pageIndexKey = 'home_page_index';

  // ── Auth token ─────────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_pageIndexKey); // clear page too on logout
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Home page index ────────────────────────────────────────
  static Future<void> savePageIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pageIndexKey, index);
  }

  static Future<int> getPageIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_pageIndexKey) ?? 0; // default to Dashboard
  }
}