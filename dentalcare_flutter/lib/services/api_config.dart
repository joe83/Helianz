import 'package:shared_preferences/shared_preferences.dart';

/// API configuration for connecting to HelianzApi.
/// The server URL can be changed at runtime via the login screen.
class ApiConfig {
  static const String _key = 'api_base_url';
  static const String _defaultUrl = 'http://100.64.0.2:5000';

  static String? _baseUrl;

  /// Current base URL. Falls back to default if not set.
  static String get baseUrl => _baseUrl ?? _defaultUrl;

  /// Set a new base URL and persist it.
  static Future<void> setBaseUrl(String url) async {
    final trimmed = url.trim().replaceAll(RegExp(r'/$'), '');
    _baseUrl = trimmed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, trimmed);
  }

  /// Load the saved base URL from storage.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString(_key);
  }

  /// API prefix
  static const String apiPrefix = '/api';

  /// Full API base URL
  static String get apiUrl => '$baseUrl$apiPrefix';

  /// Timeout for API requests in seconds
  static const int timeoutSeconds = 30;
}
