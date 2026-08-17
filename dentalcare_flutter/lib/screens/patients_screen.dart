import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prima_dental_care/theme/app_theme.dart';
import 'package:prima_dental_care/models/patient.dart';
import 'package:prima_dental_care/services/api_client.dart';
import 'package:prima_dental_care/main.dart';
import 'package:prima_dental_care/widgets/search_header.dart';
import 'patient_detail_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<Patient> _patients = [];
  int _totalCount = 0;
  bool _loading = true;
  String? _error;
  bool _initLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initLoaded) {
      _initLoaded = true;
      _loadPatients();
    }
  }

  Future<void> _loadPatients({String? query}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = AppServices.of(context).api;
      final result = await api.searchPatients(query: query);
      final searchResult = PatientSearchResult.fromJson(result);
      setState(() {
        _patients = searchResult.patients;
        _totalCount = searchResult.totalCount;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _loadPatients(query: value.isEmpty ? null : value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchHeader(
                hint: 'Search patients...',
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Patients',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    if (!_loading)
                      Text(
                        '$_totalCount patients',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadPatients(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_patients.isEmpty) {
      return const Center(
        child: Text('No patients found',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
      );
    }

    return ListView.builder(
      itemCount: _patients.length,
      itemBuilder: (context, index) {
        final patient = _patients[index];
        return Card(
          child: ListTile(
            onTap: () {
              final api = AppServices.of(context).api;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientDetailScreen(patient: patient, api: api),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                patient.initials,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            title: Text(patient.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(_buildSubtitle(patient)),
            trailing: const Icon(Icons.chevron_right,
                color: AppColors.textMuted),
          ),
        );
      },
    );
  }

  String _buildSubtitle(Patient p) {
    final parts = <String>[];
    if (p.birthdate != null) parts.add('DOB: ${p.birthdate}');
    if (p.primaryPhone != null) parts.add(p.primaryPhone!);
    if (p.balanceTotal != null && p.balanceTotal! > 0) {
      parts.add('Bal: \$${p.balanceTotal!.toStringAsFixed(0)}');
    }
    return parts.join('  •  ');
  }
}
