import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prima_dental_care/theme/app_theme.dart';
import 'package:prima_dental_care/models/appointment.dart';
import 'package:prima_dental_care/models/report.dart';
import 'package:prima_dental_care/main.dart';
import 'package:prima_dental_care/widgets/time_slot.dart';
import 'appointment_edit_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime _selectedDate = DateTime.now();
  int _selectedOp = 0;
  List<Operatory> _operatories = [];
  List<Appointment> _appointments = [];
  Map<int, String> _confirmedNames = {}; // DefNum → ItemName
  bool _loading = true;
  String? _error;
  bool _initLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initLoaded) {
      _initLoaded = true;
      _loadReferenceData().then((_) => _loadAppointments());
    }
  }

  Future<void> _loadReferenceData() async {
    try {
      final services = AppServices.of(context);
      final refJson = await services.api.getReferenceData();
      final ref = ReferenceData.fromJson(refJson as Map<String, dynamic>);
      final userClinics = services.auth.clinicNums ?? [];
      final isAdmin = userClinics.contains(0);
      _operatories = ref.operatories.where((o) {
        if (o.isHidden == true) return false;
        if (isAdmin) return true;
        if (o.clinicNum == null || o.clinicNum == 0) return true;
        return userClinics.contains(o.clinicNum);
      }).toList();
      // Load confirmed status definitions
      final confirmedList = refJson['confirmedStatuses'] as List? ?? [];
      final map = <int, String>{};
      for (final d in confirmedList) {
        if (d is Map) map[d['defNum']] = d['itemName'] ?? '';
      }
      _confirmedNames = map;
    } catch (_) {}
  }

  Future<void> _loadAppointments() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = AppServices.of(context).api;
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final result = await api.searchAppointments(dateFrom: dateStr, dateTo: dateStr);
      final searchResult = AppointmentSearchResult.fromJson(result);
      // Sort by time ascending
      final sorted = List<Appointment>.from(searchResult.appointments)
        ..sort((a, b) => (a.aptDateTime ?? '').compareTo(b.aptDateTime ?? ''));
      setState(() {
        _appointments = sorted;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _changeDate(int days) {
    setState(() => _selectedDate = _selectedDate.add(Duration(days: days)));
    _loadAppointments();
  }

  List<Appointment> get _filteredAppointments {
    var list = _appointments;
    if (_operatories.isNotEmpty && _selectedOp < _operatories.length) {
      list = list.where((a) => a.opNum == _operatories[_selectedOp].operatoryNum).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(onPressed: () => _changeDate(-1), icon: const Icon(Icons.chevron_left, color: AppColors.primary)),
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ]),
                IconButton(onPressed: () => _changeDate(1), icon: const Icon(Icons.chevron_right, color: AppColors.primary)),
              ]),
            ),
            const SizedBox(height: 12),
            if (_operatories.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]),
                child: Row(
                  children: List.generate(_operatories.length, (i) {
                    final active = _selectedOp == i;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedOp = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(color: active ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(8)),
                          child: Text(_operatories[i].displayName, textAlign: TextAlign.center,
                            style: TextStyle(color: active ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                      : _buildTimeGrid(),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppointmentEditScreen())),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTimeGrid() {
    final slots = _buildSlots();
    if (slots.isEmpty) {
      return const Center(child: Text('No appointments today', style: TextStyle(color: AppColors.textMuted)));
    }
    return ListView.builder(
      itemCount: slots.length,
      itemBuilder: (_, i) {
        final s = slots[i];
        if (s.appointment != null) {
          final a = s.appointment!;
          // Show confirmed status name for scheduled appointments
          String status = a.statusDisplay;
          if (a.aptStatus == 1 && a.confirmed != null) {
            final name = _confirmedNames[a.confirmed];
            if (name != null && name.isNotEmpty) status = name;
          }
          return TimeSlot(
            time: s.time,
            patientName: a.displayName,
            procedure: a.appointmentTypeName ?? '',
            providerName: a.provName,
            note: a.note,
            status: status,
            aptStatus: a.aptStatus,
          );
        }
        return TimeSlot(time: s.time, isAvailable: true);
      },
    );
  }

  List<_Slot> _buildSlots() {
    final slots = <_Slot>[];
    final filtered = _filteredAppointments;
    var startH = 4, endH = 20;
    if (filtered.isNotEmpty) {
      final times = filtered.map((a) => a.startTime).where((t) => t != null).toList();
      if (times.isNotEmpty) {
        times.sort();
        startH = times.first!.hour;
        endH = times.last!.hour + 1;
        if (endH < 12) endH = 20;
        if (startH > 12) startH = 4;
      }
    }
    final map = <String, Appointment>{};
    for (final a in filtered) {
      final t = a.startTime;
      if (t != null) map['${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}'] = a;
    }
    for (var h = startH; h <= endH; h++) {
      for (var m = 0; m < 60; m += 15) {
        final time = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
        slots.add(_Slot(time: time, appointment: map[time]));
      }
    }
    return slots;
  }
}

class _Slot {
  final String time;
  final Appointment? appointment;
  const _Slot({required this.time, this.appointment});
}
