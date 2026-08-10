import 'package:flutter/material.dart';
import 'package:dentalcare_pro/models/patient.dart';
import 'package:dentalcare_pro/models/appointment.dart';
import 'package:dentalcare_pro/models/message.dart';
import 'package:dentalcare_pro/services/api_client.dart';
import 'package:dentalcare_pro/theme/app_theme.dart';
import 'package:dentalcare_pro/widgets/accordion.dart';
import 'package:dentalcare_pro/widgets/status_badge.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;
  final HelianzApiClient api;
  const PatientDetailScreen({super.key, required this.patient, required this.api});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  bool _loading = true;
  List<Appointment> _appointments = [];
  List<ClinicalNote> _notes = [];
  String? _error;
  bool _initLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initLoaded) {
      _initLoaded = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = widget.api;
      final results = await Future.wait([
        api.searchAppointments(patNum: widget.patient.patNum),
        api.searchNotes(patNum: widget.patient.patNum, pageSize: 10),
      ]);
      _appointments = AppointmentSearchResult.fromJson(results[0]).appointments;
      _notes = NoteSearchResult.fromJson(results[1]).notes;
      setState(() => _loading = false);
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white24,
                        child: Text(
                          p.initials,
                          style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(p.displayName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        'ID: #${p.patNum}${' · ${p.genderDisplay}'}${p.age != null ? ' · ${p.age} yrs' : ''}',
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _loading
                ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                : _error != null
                    ? SliverFillRemaining(child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))))
                    : SliverList(
                        delegate: SliverChildListDelegate([
                          Accordion(
                            title: 'Patient Info',
                            initiallyExpanded: true,
                            children: [
                              _infoRow('Phone', p.primaryPhone),
                              _infoRow('Email', p.email),
                              _infoRow('Address', _addr(p)),
                              _infoRow('Balance', p.balanceTotal != null ? '\$${p.balanceTotal!.toStringAsFixed(2)}' : null),
                              _infoRow('Status', p.patientStatusDisplay),
                            ],
                          ),
                          if (_appointments.isNotEmpty)
                            Accordion(
                              title: 'Appointments',
                              initiallyExpanded: true,
                              children: _appointments.map((a) => _appointmentRow(
                                    a.aptDateTime ?? '', a.appointmentTypeName ?? 'Appointment', a.statusDisplay)).toList(),
                            ),
                          if (_notes.isNotEmpty)
                            Accordion(
                              title: 'Recent Notes',
                              children: _notes.map((n) => _noteRow(n)).toList(),
                            ),
                        ]),
                      ),
          ),
        ],
      ),
    );
  }

  String _addr(Patient p) {
    final parts = [p.address, p.city, p.state, p.zip].where((s) => s != null && s.isNotEmpty);
    return parts.join(', ');
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondary, fontSize: 14)),
          Flexible(child: Text(value ?? '—', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _appointmentRow(String date, String detail, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Text(detail, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ])),
        StatusBadge(status: status),
      ]),
    );
  }

  Widget _noteRow(ClinicalNote n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 12, backgroundColor: AppColors.primaryLight,
            child: Text(n.initials, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Text(n.userName ?? n.provName ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const Spacer(),
          Text(n.commDateTime ?? '', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ]),
        if (n.note != null) ...[const SizedBox(height: 4), Text(n.note!, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))],
      ]),
    );
  }
}
