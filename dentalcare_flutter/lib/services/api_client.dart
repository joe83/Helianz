import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'auth_service.dart';

/// Centralized API client for all HelianzApi endpoints.
/// Requires an [AuthService] instance for JWT token management.
class HelianzApiClient {
  final AuthService _auth;

  HelianzApiClient(this._auth);

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_auth.token != null) 'Authorization': 'Bearer ${_auth.token}',
      };

  // ──────────────────────────────────────────────
  // Auth / Debug
  // ──────────────────────────────────────────────

  Future<bool> login(String username, String password) =>
      _auth.login(username, password);

  Future<bool> getDebugToken() => _auth.getDebugToken();

  // ──────────────────────────────────────────────
  // Patients
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> searchPatients({
    String? query,
    int? clinicNum,
    int page = 1,
    int pageSize = 50,
  }) async {
    final params = <String, String>{
      if (query != null && query.isNotEmpty) 'query': query,
      if (clinicNum != null) 'clinicNum': clinicNum.toString(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    final uri =
        Uri.parse('${ApiConfig.apiUrl}/patients').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getPatient(int patNum) async {
    final response =
        await http.get(Uri.parse('${ApiConfig.apiUrl}/patients/$patNum'), headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createPatient(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.apiUrl}/patients'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updatePatient(int patNum, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.apiUrl}/patients/$patNum'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Appointments
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> searchAppointments({
    String? dateFrom,
    String? dateTo,
    int? provNum,
    int? clinicNum,
    int? patNum,
    int? aptStatus,
    int page = 1,
    int pageSize = 100,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (provNum != null) 'provNum': provNum.toString(),
      if (clinicNum != null) 'clinicNum': clinicNum.toString(),
      if (patNum != null) 'patNum': patNum.toString(),
      if (aptStatus != null) 'aptStatus': aptStatus.toString(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/appointments')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  /// Returns today's appointments as a list (API returns raw array, not wrapped)
  Future<List<Map<String, dynamic>>> getTodayAppointments() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.apiUrl}/appointments/today'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body);
      if (list is List) {
        return list.cast<Map<String, dynamic>>();
      }
      return [];
    }
    throw ApiException('Failed to load today appointments', response.statusCode);
  }

  Future<Map<String, dynamic>> getAppointment(int aptNum) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.apiUrl}/appointments/$aptNum'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.apiUrl}/appointments'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateAppointment(
      int aptNum, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.apiUrl}/appointments/$aptNum'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> completeAppointment(int aptNum) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.apiUrl}/appointments/$aptNum/complete'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Procedures
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> searchProcedures({
    int? patNum,
    int? clinicNum,
    int? provNum,
    String? dateFrom,
    String? dateTo,
    int? procStatus,
    int page = 1,
    int pageSize = 100,
  }) async {
    final params = <String, String>{
      if (patNum != null) 'patNum': patNum.toString(),
      if (clinicNum != null) 'clinicNum': clinicNum.toString(),
      if (provNum != null) 'provNum': provNum.toString(),
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (procStatus != null) 'procStatus': procStatus.toString(),
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/procedures')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getToothChart(int patNum) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.apiUrl}/procedures/chart/$patNum'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Payments
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> searchPayments({
    int? patNum,
    int? clinicNum,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int pageSize = 50,
  }) async {
    final params = <String, String>{
      if (patNum != null) 'patNum': patNum.toString(),
      if (clinicNum != null) 'clinicNum': clinicNum.toString(),
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/payments')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Prescriptions
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> searchPrescriptions({
    int? patNum,
    int? clinicNum,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int pageSize = 50,
  }) async {
    final params = <String, String>{
      if (patNum != null) 'patNum': patNum.toString(),
      if (clinicNum != null) 'clinicNum': clinicNum.toString(),
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/prescriptions')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Notes (Commlogs)
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> searchNotes({
    int? patNum,
    int? clinicNum,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int pageSize = 50,
  }) async {
    final params = <String, String>{
      if (patNum != null) 'patNum': patNum.toString(),
      if (clinicNum != null) 'clinicNum': clinicNum.toString(),
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/notes')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Reference Data
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getReferenceData() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.apiUrl}/reference'), headers: _headers);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Dashboard / Reports
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getDashboardKpis() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.apiUrl}/dashboard/kpis'), headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getRevenueTrends() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.apiUrl}/dashboard/revenue/trends'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProviders() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.apiUrl}/dashboard/providers'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getArAging() async {
    final response =
        await http.get(Uri.parse('${ApiConfig.apiUrl}/dashboard/ar'), headers: _headers);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Reports
  // ──────────────────────────────────────────────

  Future<Map<String, dynamic>> getIncompleteProcNotes({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/incomplete-proc-notes')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getPatientPortion({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/patient-portion')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getTreatmentPlan({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/treatment-plan')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getDailyProduction({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/daily-production')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProceduresReport({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/procedures')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getPaymentsReport({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/payments')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getAdjustmentsReport({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/adjustments')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProductionIncome({
    String? dateFrom, String? dateTo,
  }) async {
    final params = <String, String>{
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
    };
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/production-income')
        .replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers);
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Generic report loader
  // ──────────────────────────────────────────────

  /// Calls any /api/reports/{path} endpoint and returns parsed JSON.
  Future<Map<String, dynamic>> getReport(String path, {int page = 1, int pageSize = 50, Map<String, String>? extraParams}) async {
    final params = <String, String>{'page': '$page', 'pageSize': '$pageSize'};
    if (extraParams != null) params.addAll(extraParams);
    final uri = Uri.parse('${ApiConfig.apiUrl}/reports/$path').replace(queryParameters: params);
    final response = await http.get(uri, headers: _headers)
        .timeout(Duration(seconds: ApiConfig.timeoutSeconds));
    return _handleResponse(response);
  }

  // ──────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      _auth.logout();
      throw ApiException('Unauthorized — please log in again', 401);
    } else {
      String message = 'Request failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body.containsKey('message')) {
          message = body['message'];
        }
      } catch (_) {}
      throw ApiException(message, response.statusCode);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
