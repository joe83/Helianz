import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

/// Manages authentication with HelianzApi using JWT tokens.
class AuthService extends ChangeNotifier {
  String? _token;
  String? _displayName;
  int? _userNum;
  int? _clinicNum;
  List<int>? _clinicNums;
  List<int>? _userGroupNums;
  List<UserPermission>? _permissions;

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  String? get displayName => _displayName;
  int? get userNum => _userNum;
  int? get clinicNum => _clinicNum;
  List<int>? get clinicNums => _clinicNums;
  List<int>? get userGroupNums => _userGroupNums;
  List<UserPermission>? get permissions => _permissions;

  /// Check if user has a specific permission type (any FKey).
  bool hasPerm(int permType) =>
      _permissions?.any((p) => p.permType == permType) ?? false;

  /// Check if user has permission with specific FKey (0=all access).
  bool hasPermFKey(int permType, [int fKey = 0]) =>
      _permissions?.any((p) => p.permType == permType && (p.fKey == 0 || p.fKey == fKey)) ?? false;

  /// Check if user has any of the given permission types.
  bool hasAnyPerm(List<int> permTypes) =>
      _permissions?.any((p) => permTypes.contains(p.permType)) ?? false;

  /// Check if user has ALL of the given permission types.
  bool hasAllPerms(List<int> permTypes) =>
      permTypes.every((pt) => hasPerm(pt));

  // ── Convenience module checks ──

  bool get canViewAppointments => hasAnyPerm([1, 25, 26, 27]); // AppointmentsModule, AppointmentCreate/Move/Edit
  bool get canViewPatients => hasAnyPerm([2, 106, 108]); // FamilyModule, PatientCreate, PatientEdit
  bool get canViewMessages => hasAnyPerm([2, 43]); // FamilyModule, CommlogEdit
  bool get canViewReports => hasPerm(22); // Reports
  bool get canViewMore => hasAnyPerm([7, 8, 24]); // ManageModule, Setup, SecurityAdmin
  bool get isAdmin => hasPerm(24); // SecurityAdmin

  /// Save session to persistent storage.
  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
      await prefs.setString('auth_displayName', _displayName ?? '');
      await prefs.setInt('auth_userNum', _userNum ?? 0);
      await prefs.setInt('auth_clinicNum', _clinicNum ?? 0);
      if (_clinicNums != null) await prefs.setStringList('auth_clinicNums', _clinicNums!.map((e) => e.toString()).toList());
      if (_userGroupNums != null) await prefs.setStringList('auth_userGroupNums', _userGroupNums!.map((e) => e.toString()).toList());
      if (_permissions != null) await prefs.setString('auth_permissions', jsonEncode(_permissions!.map((p) => {
        'permType': p.permType, 'fKey': p.fKey, 'newerDate': p.newerDate?.toIso8601String(), 'newerDays': p.newerDays,
      }).toList()));
    }
  }

  /// Try to restore session from persistent storage. Returns true if restored and valid.
  Future<bool> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final t = prefs.getString('auth_token');
      if (t == null || t.isEmpty) return false;

      // Verify token is still valid with a quick API call
      try {
        final resp = await http.get(
          Uri.parse('${ApiConfig.apiUrl}/auth/verify'),
          headers: {'Authorization': 'Bearer $t'},
        ).timeout(const Duration(seconds: 5));
        if (resp.statusCode != 200) {
          await _clearSession();
          return false;
        }
      } catch (_) {
        // Server unreachable — still restore, will fail later if token expired
      }

      _token = t;
      _displayName = prefs.getString('auth_displayName');
      _userNum = prefs.getInt('auth_userNum');
      _clinicNum = prefs.getInt('auth_clinicNum');
      final cns = prefs.getStringList('auth_clinicNums');
      if (cns != null) _clinicNums = cns.map(int.parse).toList();
      final gns = prefs.getStringList('auth_userGroupNums');
      if (gns != null) _userGroupNums = gns.map(int.parse).toList();
      final ps = prefs.getString('auth_permissions');
      if (ps != null) {
        final list = jsonDecode(ps) as List;
        _permissions = list.map((p) => UserPermission(
          permType: p['permType'], fKey: p['fKey'] ?? 0,
          newerDate: p['newerDate'] != null ? DateTime.parse(p['newerDate']) : null,
          newerDays: p['newerDays'] ?? 0,
        )).toList();
      }
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Clear persisted session.
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_displayName');
  }

  /// Attempt login with username/password.
  /// Returns true on success, false on failure.
  Future<bool> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.apiUrl}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'Username': username,
              'Password': password,
            }),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _displayName = data['displayName'];
        _userNum = data['userNum'];
        _clinicNum = data['clinicNum'];

        if (data['clinicNums'] != null) {
          _clinicNums = List<int>.from(data['clinicNums']);
        }

        if (data['userGroupNums'] != null) {
          _userGroupNums = List<int>.from(data['userGroupNums']);
        }

        if (data['permissions'] != null) {
          _permissions = (data['permissions'] as List)
              .map((p) => UserPermission(
                    permType: p['permType'],
                    name: p['name'] ?? '',
                    fKey: p['fKey'] ?? 0,
                    newerDate: p['newerDate'] != null ? DateTime.parse(p['newerDate']) : null,
                    newerDays: p['newerDays'] ?? 0,
                  ))
              .toList();
        }

        notifyListeners();
        _saveSession();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Get a debug token for development (no password needed).
  Future<bool> getDebugToken() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConfig.apiUrl}/auth/debug-token'))
          .timeout(Duration(seconds: ApiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _displayName = data['displayName'] ?? 'Dev User';
        _userNum = data['userNum'];
        _clinicNum = data['clinicNum'];

        if (data['clinicNums'] != null) {
          _clinicNums = List<int>.from(data['clinicNums']);
        }

        if (data['userGroupNums'] != null) {
          _userGroupNums = List<int>.from(data['userGroupNums']);
        }

        if (data['permissions'] != null) {
          _permissions = (data['permissions'] as List)
              .map((p) => UserPermission(
                    permType: p['permType'],
                    name: p['name'] ?? '',
                    fKey: p['fKey'] ?? 0,
                    newerDate: p['newerDate'] != null ? DateTime.parse(p['newerDate']) : null,
                    newerDays: p['newerDays'] ?? 0,
                  ))
              .toList();
        }

        notifyListeners();
        _saveSession();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Debug token error: $e');
      return false;
    }
  }

  void logout() {
    _token = null;
    _displayName = null;
    _userNum = null;
    _clinicNum = null;
    _clinicNums = null;
    _userGroupNums = null;
    _permissions = null;
    _clearSession();
    notifyListeners();
  }
}

class UserPermission {
  final int permType;
  final String name;
  final int fKey;
  final DateTime? newerDate;
  final int newerDays;
  UserPermission({required this.permType, this.name = '', this.fKey = 0, this.newerDate, this.newerDays = 0});
}
