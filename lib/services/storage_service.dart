import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences — on Flutter web this uses browser localStorage.
class StorageService {
  static const _tokenKey     = 'auth_token';
  static const _savedAtKey   = 'auth_token_saved_at';   // NEW
  static const _pageIndexKey = 'home_page_index';

  // Tokens issued by backend last 60 minutes — treat them expired after 55
  // for a small safety buffer.
  static const Duration _tokenLifetime = Duration(minutes: 55);

  // ── Auth token ─────────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    // Also save the timestamp so we can detect expiry on app start
    await prefs.setInt(_savedAtKey,
        DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_savedAtKey);
    await prefs.remove(_pageIndexKey); // clear page too on logout
  }

  /// Backwards compat — kept for callers that don't care about expiry
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// True when a non-empty token exists AND it's within the lifetime window.
  /// Use this for splash screen / startup checks.
  static Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return false;

    final savedAt = prefs.getInt(_savedAtKey);
    if (savedAt == null) {
      // Token without timestamp — must be from a pre-update install.
      // Treat as expired so we force a fresh login.
      return false;
    }

    final age = DateTime.now().millisecondsSinceEpoch - savedAt;
    return age < _tokenLifetime.inMilliseconds;
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