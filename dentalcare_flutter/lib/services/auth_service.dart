import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prima_dental_care/models/report.dart';
import 'api_config.dart';

/// Manages authentication and active clinic state with HelianzApi using JWT tokens.
class AuthService extends ChangeNotifier {
  String? _token;
  String? _displayName;
  String? _email;
  int? _userNum;
  int? _clinicNum;
  List<int>? _clinicNums;
  List<int>? _userGroupNums;
  List<UserPermission>? _permissions;

  // Active clinic context
  int? _activeClinicNum;
  String? _activeClinicName;
  bool _clinicIsRestricted = false;
  List<ClinicInfo> _availableClinics = [];

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  String? get displayName => _displayName;
  String? get email => _email;
  int? get userNum => _userNum;
  int? get clinicNum => _clinicNum;
  List<int>? get clinicNums => _clinicNums;
  List<int>? get userGroupNums => _userGroupNums;
  List<UserPermission>? get permissions => _permissions;

  int? get activeClinicNum => _activeClinicNum ?? _clinicNum;
  String get activeClinicName {
    if (_activeClinicName != null && _activeClinicName!.isNotEmpty) {
      return _activeClinicName!;
    }
    final num = activeClinicNum;
    if (num == 0) return 'All Clinics';
    if (num != null) {
      final match = _availableClinics.where((c) => c.clinicNum == num);
      if (match.isNotEmpty) return match.first.description;
      return 'Clinic #$num';
    }
    return 'Clinic';
  }
  bool get clinicIsRestricted => _clinicIsRestricted;
  List<ClinicInfo> get availableClinics => _availableClinics;
  bool get isMultiClinic => _availableClinics.length > 1;
  bool get canSwitchClinic => _availableClinics.length > 1;

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

  /// Switch the active clinic context.
  Future<void> setActiveClinic(int clinicNum, [String? clinicName]) async {
    _activeClinicNum = clinicNum;
    if (clinicName != null && clinicName.isNotEmpty) {
      _activeClinicName = clinicName;
    } else if (clinicNum == 0) {
      _activeClinicName = 'All Clinics';
    } else {
      final match = _availableClinics.where((c) => c.clinicNum == clinicNum);
      _activeClinicName = match.isNotEmpty ? match.first.description : 'Clinic #$clinicNum';
    }
    // Notify immediately so all UI listeners update instantly
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('auth_activeClinicNum', clinicNum);
      if (_activeClinicName != null) {
        await prefs.setString('auth_activeClinicName', _activeClinicName!);
      }
    } catch (e) {
      debugPrint('Error saving active clinic: $e');
    }
  }

  /// Update available clinics (e.g. from ReferenceData).
  void updateAvailableClinics(List<ClinicInfo> clinics) {
    if (clinics.isEmpty) return;
    if (_clinicIsRestricted && _clinicNums != null && _clinicNums!.isNotEmpty) {
      final allowed = clinics.where((c) => _clinicNums!.contains(c.clinicNum)).toList();
      if (allowed.isNotEmpty) {
        _availableClinics = allowed;
      }
    } else {
      _availableClinics = clinics;
    }
    if (_activeClinicNum != null && _activeClinicNum != 0) {
      final match = _availableClinics.where((c) => c.clinicNum == _activeClinicNum);
      if (match.isNotEmpty) {
        _activeClinicName = match.first.description;
      }
    } else if (_activeClinicNum == 0) {
      _activeClinicName = 'All Clinics';
    }
    notifyListeners();
  }

  /// Save session to persistent storage.
  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
      await prefs.setString('auth_displayName', _displayName ?? '');
      await prefs.setString('auth_email', _email ?? '');
      await prefs.setInt('auth_userNum', _userNum ?? 0);
      await prefs.setInt('auth_clinicNum', _clinicNum ?? 0);
      await prefs.setBool('auth_clinicIsRestricted', _clinicIsRestricted);
      if (_activeClinicNum != null) {
        await prefs.setInt('auth_activeClinicNum', _activeClinicNum!);
      }
      if (_activeClinicName != null) {
        await prefs.setString('auth_activeClinicName', _activeClinicName!);
      }
      if (_clinicNums != null) {
        await prefs.setStringList('auth_clinicNums', _clinicNums!.map((e) => e.toString()).toList());
      }
      if (_userGroupNums != null) {
        await prefs.setStringList('auth_userGroupNums', _userGroupNums!.map((e) => e.toString()).toList());
      }
      if (_permissions != null) {
        await prefs.setString('auth_permissions', jsonEncode(_permissions!.map((p) => {
          'permType': p.permType, 'fKey': p.fKey, 'newerDate': p.newerDate?.toIso8601String(), 'newerDays': p.newerDays,
        }).toList()));
      }
      if (_availableClinics.isNotEmpty) {
        await prefs.setString('auth_availableClinics', jsonEncode(_availableClinics.map((c) => c.toJson()).toList()));
      }
    }
  }

  /// Try to restore session from persistent storage. Returns true if restored and valid.
  Future<bool> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final t = prefs.getString('auth_token');
      if (t == null || t.isEmpty) return false;

      // Verify token with backend, only clear session on explicit 401 Unauthorized
      try {
        final resp = await http.get(
          Uri.parse('${ApiConfig.apiUrl}/auth/verify'),
          headers: {'Authorization': 'Bearer $t'},
        ).timeout(const Duration(seconds: 8));
        if (resp.statusCode == 401) {
          debugPrint('Token expired or unauthorized (401). Clearing session.');
          await _clearSession();
          return false;
        }
      } catch (e) {
        // Server unreachable / network timeout — keep session so user is not logged out while traveling/offline
        debugPrint('Auth verify network exception (offline/timeout): $e');
      }

      _token = t;
      _displayName = prefs.getString('auth_displayName');
      _email = prefs.getString('auth_email');
      _userNum = prefs.getInt('auth_userNum');
      _clinicNum = prefs.getInt('auth_clinicNum');
      _clinicIsRestricted = prefs.getBool('auth_clinicIsRestricted') ?? false;
      _activeClinicNum = prefs.getInt('auth_activeClinicNum') ?? _clinicNum;
      _activeClinicName = prefs.getString('auth_activeClinicName');

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
      final acs = prefs.getString('auth_availableClinics');
      if (acs != null) {
        final list = jsonDecode(acs) as List;
        _availableClinics = list.map((c) => ClinicInfo.fromJson(c as Map<String, dynamic>)).toList();
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Restore session error: $e');
      return false;
    }
  }

  /// Clear persisted session.
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_displayName');
    await prefs.remove('auth_email');
    await prefs.remove('auth_activeClinicNum');
    await prefs.remove('auth_activeClinicName');
    await prefs.remove('auth_availableClinics');
    await prefs.remove('auth_clinicIsRestricted');
  }

  /// Parse auth response body.
  void _parseAuthData(Map<String, dynamic> data) {
    _token = data['token'];
    _displayName = data['displayName'];
    _email = data['email'] ?? '';
    _userNum = data['userNum'];
    _clinicNum = data['clinicNum'];
    _clinicIsRestricted = data['clinicIsRestricted'] ?? false;

    if (data['clinicNums'] != null) {
      _clinicNums = List<int>.from(data['clinicNums']);
    }

    if (data['clinics'] != null) {
      _availableClinics = (data['clinics'] as List)
          .map((c) => ClinicInfo.fromJson(c as Map<String, dynamic>))
          .toList();
    }

    // Initialize active clinic
    _activeClinicNum = _clinicNum;
    if (_activeClinicNum != null && _activeClinicNum != 0) {
      final match = _availableClinics.where((c) => c.clinicNum == _activeClinicNum);
      _activeClinicName = match.isNotEmpty ? match.first.description : 'Clinic #$_activeClinicNum';
    } else if (_availableClinics.isNotEmpty) {
      _activeClinicNum = _availableClinics.first.clinicNum;
      _activeClinicName = _availableClinics.first.description;
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
  }

  /// Fetch list of clinics publicly from a server URL without authentication.
  static Future<List<ClinicInfo>> fetchClinics([String? url]) async {
    final base = (url ?? ApiConfig.baseUrl).trim().replaceAll(RegExp(r'/$'), '');
    try {
      final uri = Uri.parse('$base/api/auth/clinics');
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        if (data is List) {
          return data.map((c) => ClinicInfo.fromJson(c as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {}

    try {
      final uri = Uri.parse('$base/api/reference/clinics');
      final resp = await http.get(uri).timeout(const Duration(seconds: 8));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body);
        if (data is List) {
          return data.map((c) => ClinicInfo.fromJson(c as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {}

    return [];
  }

  /// Attempt login with email or username, password, and optional clinic selection.
  Future<bool> login(String loginIdentifier, String password, {int? clinicNum}) async {
    try {
      final trimmed = loginIdentifier.trim();
      final isEmail = trimmed.contains('@');
      final body = <String, dynamic>{
        'Username': trimmed,
        if (isEmail) 'Email': trimmed,
        'Password': password,
        if (clinicNum != null && clinicNum > 0) 'ClinicNum': clinicNum,
      };
      final response = await http
          .post(
            Uri.parse('${ApiConfig.apiUrl}/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(Duration(seconds: ApiConfig.timeoutSeconds));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _parseAuthData(data);
        if (clinicNum != null && clinicNum > 0) {
          _activeClinicNum = clinicNum;
          final match = _availableClinics.where((c) => c.clinicNum == clinicNum);
          if (match.isNotEmpty) {
            _activeClinicName = match.first.description;
          }
        }
        notifyListeners();
        await _saveSession();
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
        _parseAuthData(data);
        notifyListeners();
        await _saveSession();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Debug token error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _displayName = null;
    _email = null;
    _userNum = null;
    _clinicNum = null;
    _clinicNums = null;
    _activeClinicNum = null;
    _activeClinicName = null;
    _availableClinics = [];
    _userGroupNums = null;
    _permissions = null;
    await _clearSession();
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
