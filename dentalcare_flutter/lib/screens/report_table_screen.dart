import 'package:flutter/material.dart';
import 'package:prima_dental_care/theme/app_theme.dart';
import 'package:prima_dental_care/services/api_client.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

// ═══════════════════════════════════════════════════════════════
// Report types mapped to Helianz menu
// ═══════════════════════════════════════════════════════════════
enum ReportType {
  prodToday, prodYesterday, prodThisMonth, prodLastMonth, prodThisYear,
  prodMoreOptions, prodGoal,
  dailyAdj, dailyPayments, dailyProcs, dailyWriteoffs, dailyIncNotes,
  dailyRouting, dailyUnfinalizedIns,
  moArAging, moClaimsNotSent, moFinanceCharge, moOutInsClaims,
  moProcNotBilled, moPpoWriteoffs, moPaymentPlans, moReceivables,
  moUnearned, moInsOverpaid, moTreatPlanProd,
  listActivePatients, listAppointments, listBirthdays, listBrokenAppts,
  listInsPlans, listNewPatients, listPatientsRaw, listPatientNotes,
  listPrescriptions, listProcFeeSched, listReferralsRaw,
  listReferralAnalysis, listRefProcTrack, listTreatmentFinder, listWebSched,
  phScreeningData, phPopulationData, phFqhcSealant,
  kpiToday, revenueTrends, providers, arAging, procedures,
  proceduresReport, payments, adjustments, productionIncome,
  incompleteNotes, patientPortion, treatmentPlan, dailyProduction, placeholder,
}

class ReportTableScreen extends StatefulWidget {
  final String title; final ReportType reportType; final HelianzApiClient api;
  const ReportTableScreen({super.key, required this.title, required this.reportType, required this.api});
  @override State<ReportTableScreen> createState() => _ReportTableScreenState();
}

class _ReportTableScreenState extends State<ReportTableScreen> {
  bool _loading = true;
  String? _error;
  List<List<String>> _cells = [];
  List<String> _headers = [];
  List<String> _totalsRow = [];
  List<String> _summary = [];
  List<String> _groupedLines = []; // Group-by summary: provider, clinic, payment type
  String _footer = '';
  int _page = 1;
  int _totalCount = 0;
  static const _pageSize = 50;

  // Filter state
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final Set<int> _selectedProvNums = {};
  final Set<int> _selectedClinicNums = {};
  bool get _hasFilters => _dateFrom != null || _selectedProvNums.isNotEmpty || _selectedClinicNums.isNotEmpty;

  // Reference data for filter dropdowns
  List<Map<String, dynamic>> _refProviders = [];
  List<Map<String, dynamic>> _refClinics = [];
  bool _refLoaded = false;

  bool get _needsDateFilter => _eps.containsKey(widget.reportType);

  static const _eps = <ReportType, String>{
    ReportType.prodToday: 'prod-today', ReportType.prodYesterday: 'prod-yesterday',
    ReportType.prodThisMonth: 'prod-this-month', ReportType.prodLastMonth: 'prod-last-month',
    ReportType.prodThisYear: 'prod-this-year', ReportType.prodGoal: 'prod-goal',
    ReportType.dailyAdj: 'daily-adjustments', ReportType.dailyPayments: 'daily-payments',
    ReportType.dailyProcs: 'daily-procedures', ReportType.dailyWriteoffs: 'daily-writeoffs',
    ReportType.dailyIncNotes: 'daily-incomplete-notes', ReportType.dailyUnfinalizedIns: 'daily-unfinalized-ins',
    ReportType.moArAging: 'mo-ar-aging', ReportType.moClaimsNotSent: 'mo-claims-not-sent',
    ReportType.moOutInsClaims: 'mo-outstanding-ins-claims', ReportType.moProcNotBilled: 'mo-proc-not-billed',
    ReportType.moPpoWriteoffs: 'mo-ppo-writeoffs', ReportType.moInsOverpaid: 'mo-ins-overpaid',
    ReportType.moTreatPlanProd: 'mo-treatplan-prod',
    ReportType.listActivePatients: 'list-active-patients', ReportType.listAppointments: 'list-appointments',
    ReportType.listBirthdays: 'list-birthdays', ReportType.listBrokenAppts: 'list-broken-appointments',
    ReportType.listInsPlans: 'list-ins-plans', ReportType.listNewPatients: 'list-new-patients',
    ReportType.listPatientsRaw: 'list-patients-raw', ReportType.listPatientNotes: 'list-patient-notes',
    ReportType.listPrescriptions: 'list-prescriptions', ReportType.listProcFeeSched: 'list-proc-fee-sched',
    ReportType.listTreatmentFinder: 'list-treatment-finder', ReportType.listWebSched: 'list-web-sched-appts',
  };

  static const _days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  final _idFmt = NumberFormat('#,##0', 'id');

  @override void initState() {
    super.initState();
    _dateFrom = DateTime.now();
    _dateTo = DateTime.now();
    _loadRefData();
    _load();
  }

  Future<void> _loadRefData() async {
    try {
      final ref = await widget.api.getReferenceData();
      if (!mounted) return;
      setState(() {
        _refProviders = (ref['providers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        _refClinics = (ref['clinics'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        _refLoaded = true;
      });
    } catch (_) { /* non-critical, filter will still work without dropdowns */ }
  }

  Future<void> _load() async {
    if (widget.reportType == ReportType.placeholder) { setState(() { _error = 'Not yet available'; _loading = false; }); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final p = _eps[widget.reportType];
      if (p != null) {
        final extra = <String, String>{};
        if (_dateFrom != null) extra['f'] = DateFormat('yyyy-MM-dd').format(_dateFrom!);
        if (_dateTo != null) extra['t'] = DateFormat('yyyy-MM-dd').format(_dateTo!);
        if (_selectedProvNums.isNotEmpty) extra['provNums'] = _selectedProvNums.join(',');
        if (_selectedClinicNums.isNotEmpty) extra['clinicNums'] = _selectedClinicNums.join(',');
        final d = await widget.api.getReport(p, page: _page, pageSize: _pageSize, extraParams: extra.isEmpty ? null : extra);
        _build(d);
      } else { setState(() { _error = 'Not yet available'; _loading = false; }); }
    } catch (e) { setState(() { _error = e.toString(); _loading = false; }); }
  }

  // ── Filter dialog ──

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => _FilterSheet(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        selectedProvNums: _selectedProvNums,
        selectedClinicNums: _selectedClinicNums,
        providers: _refProviders,
        clinics: _refClinics,
        onApply: (df, dt, provs, clinics) {
          setState(() {
            _dateFrom = df;
            _dateTo = dt;
            _selectedProvNums..clear()..addAll(provs);
            _selectedClinicNums..clear()..addAll(clinics);
          });
          _page = 1;
          _load();
        },
      ),
    );
  }

  void _goPage(int delta) {
    final totalPages = (_totalCount / _pageSize).ceil();
    final next = _page + delta;
    if (next < 1 || next > totalPages) return;
    _page = next;
    _load();
  }

  void _build(Map<String, dynamic> d) {
    _totalCount = (d['count'] is int) ? d['count'] : 0;
    _totalsRow = [];
    _summary = [];
    final raw = (d['rows'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (raw.isEmpty) { setState(() { _headers = []; _cells = []; _totalsRow = []; _summary = []; _footer = ''; _loading = false; }); return; }
    final keys = raw.first.keys.toList();
    _headers = keys.map((k) => _hdr(k)).toList();
    _cells = raw.map((r) => keys.map((k) => _val(k, r[k])).toList()).toList();

    // Totals row — from API `totals` map, or auto-generated from total values
    if (d['totals'] is Map) {
      final t = d['totals'] as Map<String, dynamic>;
      _totalsRow = keys.map((k) {
        if (k == 'date') return 'TOTAL';
        if (k == 'dayName') return '';
        return _val(k, t[k]);
      }).toList();
    } else {
      // Auto-generate totals row from API total values (totalFee, totalAmount, totalShare, count)
      final totals = <String>[];
      for (final k in keys) {
        final lk = k.toLowerCase();
        if (lk == 'date') { totals.add('TOTAL'); continue; }
        if (lk == 'dayname' || lk == 'patientname') { totals.add(''); continue; }
        if (lk == 'fee' && d['totalFee'] is num) { totals.add(_idFmt.format((d['totalFee'] as num).round())); continue; }
        if (lk == 'amount' && d['totalAmount'] is num) { totals.add(_idFmt.format((d['totalAmount'] as num).round())); continue; }
        if (lk == 'share' && d['totalShare'] is num) { totals.add(_idFmt.format((d['totalShare'] as num).round())); continue; }
        totals.add('');
      }
      // Only show totals row if it has any non-empty values
      if (totals.any((t) => t.isNotEmpty && t != 'TOTAL')) {
        _totalsRow = totals;
      }
    }
    // Summary lines — from API summary field, or auto-generated from total values
    if (d['summary'] is List && (d['summary'] as List).isNotEmpty) {
      _summary = (d['summary'] as List).map((s) => s.toString()).toList();
    } else {
      final sb = <String>[];
      void add(String label, String key, {String? fmt}) {
        if (d[key] is num && (d[key] as num) != 0) {
          final v = (d[key] as num).toDouble();
          sb.add('$label: ${_idFmt.format(v.round())}');
        }
      }
      add('Total Production', 'totalProduction');
      add('Total Income', 'totalIncome');
      add('Total Amount', 'totalAmount');
      add('Total Fee', 'totalFee');
      add('Total Share', 'totalShare');
      add('Row Count', 'count');
      if (sb.isNotEmpty) _summary = sb;
    }

    // Grouped breakdowns: by provider, payment type, share
    final gl = <String>[];

    // Find all monetary value columns (case-insensitive)
    String? feeKey, amtKey, shareKey;
    for (final k in keys) {
      final lk = k.toLowerCase();
      if (lk == 'fee') feeKey = k;
      if (lk == 'amount') amtKey = k;
      if (lk == 'share') shareKey = k;
    }
    final valKey = feeKey ?? amtKey; // primary value column

    // Provider key (case-insensitive)
    final provKey = keys.firstWhere((k) {
      final lk = k.toLowerCase();
      return lk == 'provname' || lk == 'prov';
    }, orElse: () => '');
    // Payment type key — try multiple possible names
    String payKey = '';
    for (final k in keys) {
      final lk = k.toLowerCase();
      if (lk == 'paytype' || lk == 'itemname' || lk == 'paymenttype' || lk == 'type') {
        payKey = k; break;
      }
    }
    if (payKey.isEmpty) {
      // Fallback: find any key containing "pay" or "type"
      payKey = keys.firstWhere((k) {
        final lk = k.toLowerCase();
        return lk.contains('pay') || lk.contains('type');
      }, orElse: () => '');
    }

    // ── By Provider (Fee/Amount) ──
    if (valKey != null && provKey.isNotEmpty) {
      final byProv = <String, double>{};
      for (final r in raw) {
        final prov = (r[provKey] ?? '—').toString();
        final val = double.tryParse((r[valKey] ?? '0').toString()) ?? 0;
        byProv[prov] = (byProv[prov] ?? 0) + val;
      }
      if (byProv.isNotEmpty && byProv.values.any((v) => v > 0)) {
        gl.add('BY PROVIDER');
        for (final e in byProv.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
          gl.add('  ${e.key}: ${_idFmt.format(e.value.round())}');
        }
      }
    }

    // ── By Provider (Share) - for procedures reports ──
    if (shareKey != null && provKey.isNotEmpty) {
      final byShare = <String, double>{};
      for (final r in raw) {
        final prov = (r[provKey] ?? '—').toString();
        final val = double.tryParse((r[shareKey] ?? '0').toString()) ?? 0;
        byShare[prov] = (byShare[prov] ?? 0) + val;
      }
      if (byShare.isNotEmpty && byShare.values.any((v) => v > 0)) {
        gl.add('BY PROVIDER (SHARE)');
        for (final e in byShare.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
          gl.add('  ${e.key}: ${_idFmt.format(e.value.round())}');
        }
      }
    }

    // ── By Payment Type ──
    if (payKey.isNotEmpty) {
      final vk = valKey ?? amtKey ?? feeKey;
      if (vk != null) {
        final byPay = <String, double>{};
        for (final r in raw) {
          final pt = (r[payKey] ?? '—').toString();
          final val = double.tryParse((r[vk] ?? '0').toString()) ?? 0;
          byPay[pt] = (byPay[pt] ?? 0) + val;
        }
        if (byPay.isNotEmpty && byPay.values.any((v) => v > 0)) {
          gl.add('BY PAYMENT TYPE');
          for (final e in byPay.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
            gl.add('  ${e.key}: ${_idFmt.format(e.value.round())}');
          }
        }
      }
    }

    // ── By Clinic ──
    final clinicKey = keys.firstWhere((k) {
      final lk = k.toLowerCase();
      return lk == 'clinic' || lk == 'clinicname';
    }, orElse: () => '');
    if (clinicKey.isNotEmpty && valKey != null) {
      final byClinic = <String, double>{};
      for (final r in raw) {
        final cn = (r[clinicKey] ?? '—').toString();
        final val = double.tryParse((r[valKey] ?? '0').toString()) ?? 0;
        byClinic[cn] = (byClinic[cn] ?? 0) + val;
      }
      if (byClinic.isNotEmpty && byClinic.values.any((v) => v > 0)) {
        gl.add('BY CLINIC');
        for (final e in byClinic.entries) {
          gl.add('  ${e.key}: ${_idFmt.format(e.value.round())}');
        }
      }
    }

    // ── Patient count per provider ──
    if (provKey.isNotEmpty) {
      final patCount = <String, int>{};
      for (final r in raw) {
        final prov = (r[provKey] ?? '—').toString();
        patCount[prov] = (patCount[prov] ?? 0) + 1;
      }
      if (patCount.isNotEmpty) {
        gl.add('PATIENTS BY PROVIDER');
        for (final e in patCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
          gl.add('  ${e.key}: ${e.value} patients');
        }
      }
    }

    _groupedLines = gl;

    // Fallback: if no specific groups found, auto-group by any string column with 2+ distinct values
    if (gl.isEmpty && raw.length > 1 && valKey != null) {
      for (final k in keys) {
        if (k == 'date' || k == 'dayName' || k == 'patientName' || k == 'checkNum') continue;
        if (k == valKey || k == shareKey) continue; // skip numeric columns
        final set = <String>{};
        for (final r in raw) { set.add((r[k]?.toString() ?? '—')); }
        if (set.length > 1 && set.length < 50) {
          final map = <String, double>{};
          for (final r in raw) {
            final key = (r[k]?.toString() ?? '—');
            final val = double.tryParse((r[valKey] ?? '0').toString()) ?? 0;
            map[key] = (map[key] ?? 0) + val;
          }
          gl.add('BY ${_hdr(k).toUpperCase()}');
          for (final e in map.entries.toList()..sort((a, b) => b.value.compareTo(a.value))) {
            gl.add('  ${e.key}: ${_idFmt.format(e.value.round())}');
          }
          break; // only auto-group by first qualifying column
        }
      }
    }
    if (gl.isNotEmpty) _groupedLines = gl;

    final totalPages = (_totalCount / _pageSize).ceil();
    _footer = 'Page $_page of $totalPages  (${_totalCount} rows)';
    setState(() { _loading = false; });
  }

  /// Maps JSON key → display header (matches PDF report headers)
  String _hdr(String k) {
    switch (k) {
      case 'date': return 'Date'; case 'dayName': return 'Day';
      case 'patientName': return 'Patient Name'; case 'provName': return 'Prov';
      case 'payType': return 'Pay Type'; case 'checkNum': return 'Check#';
      case 'amount': return 'Amount'; case 'production': return 'Production';
      case 'adjustment': return 'Sched Adj'; case 'writeOff': return 'Write-off';
      case 'totalProd': return 'Tot Prod'; case 'patientIncome': return 'Pt Income';
      case 'insIncome': return 'Ins Income'; case 'unearnedPtIncome': return 'Unearned Pt Income'; case 'totalIncome': return 'Tot Income';
      case 'code': case 'procCode': return 'Code'; case 'toothArea': return 'Tooth/Area';
      case 'description': case 'descript': return 'Description'; case 'fee': return 'Fee';
      case 'share': return 'Share';
      case 'note': return 'Note'; case 'insurance': return 'Insurance';
      case 'agingBucket': return 'Aging'; case 'patientCount': return 'Patients';
      case 'balance': return 'Balance'; case 'estAmt': return 'Est Amt';
      case 'paidAmt': return 'Paid'; case 'daysOut': case 'daysOutstanding': return 'Days Out';
      case 'priority': return 'Prio'; case 'datePlan': return 'Plan Date';
      case 'hmPhone': return 'Phone'; case 'wirelessPhone': return 'Mobile';
      case 'dateFirstVisit': return 'First Visit'; case 'patStatus': return 'Status';
      case 'commType': return 'Type'; case 'userName': return 'User';
      case 'drug': return 'Drug'; case 'sig': return 'Sig'; case 'disp': return 'Disp';
      case 'refills': return 'Refills'; case 'rxDate': return 'Rx Date';
      case 'subscriber': return 'Subscriber'; case 'groupName': return 'Group';
      case 'planType': return 'Plan Type'; case 'operatory': case 'opName': return 'Operatory';
      case 'appointmentTypeName': return 'Appt Type'; case 'aptStatus': return 'Status';
      case 'aptDateTime': return 'Date/Time'; case 'totalAmt': return 'Total';
      case 'paid': return 'Paid'; case 'overpaid': return 'Overpaid';
      case 'estimated': return 'Est'; case 'birthMonth': return 'Birth Mo';
      case 'birthDay': return 'Birth Day'; case 'birthdate': return 'Birthdate';
      case 'numPmts': case 'numberOfPayments': return '# Pmts';
      case 'paymentAmt': return 'Pmt Amt'; case 'planNum': return 'Plan#';
      default: return k[0].toUpperCase() + k.substring(1);
    }
  }

  /// Formats a cell value: dates → dd/MM/yyyy, numbers → ID locale, day names
  String _val(String key, dynamic v) {
    if (v == null) return '';
    if (v is double || v is int) {
      final n = v.toDouble();
      if (n.abs() >= 1000) return _idFmt.format(n.round());
      if (n == n.roundToDouble()) return n.toStringAsFixed(0);
      return n.toStringAsFixed(2);
    }
    if (v is String) {
      final d = DateTime.tryParse(v);
      if (d != null) {
        if (key == 'dayName') return _days[d.weekday % 7];
        return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
      }
      return v;
    }
    return v.toString();
  }

  String _tot(Map<String, dynamic> d, List rows) {
    for (final k in ['totalAmount', 'totalProduction', 'totalFee', 'totalIncome']) {
      if (d[k] is num && (d[k] as num) != 0) return 'Total: ${_idFmt.format((d[k] as num).round())}';
    }
    return '';
  }

  double _w(String h) {
    switch (h) {
      case 'Date': case 'Day': return 68;
      case 'Code': case 'Tooth/Area': case 'Status': case 'Check#': return 60;
      case 'Prov': case 'Pay Type': case 'Fee': case 'Amount': case 'Paid': case 'Prio': return 70;
      case 'Patient Name': return 140;
      case 'Description': case 'Drug': case 'Sig': return 120;
      case 'Note': return 110;
      case 'Production': case 'Sched Adj': case 'Write-off': case 'Tot Prod':
      case 'Pt Income': case 'Ins Income': case 'Tot Income': case 'Unearned Pt Income': case 'Balance':
      case 'Est Amt': case 'Overpaid': case 'Total': return 80;
      default: return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (!_loading && _cells.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.share_rounded),
              tooltip: 'Share as CSV',
              onPressed: _shareCsv,
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf_rounded),
              tooltip: 'Export PDF',
              onPressed: _exportPdf,
            ),
          ],
          if (_needsDateFilter)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list_rounded),
                  tooltip: 'Filters',
                  onPressed: _showFilterDialog,
                ),
                if (_hasFilters)
                  Positioned(right: 6, top: 6, child: Container(width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle))),
              ],
            ),
        ],
      ),
      body: Column(children: [
        // Active filter chips summary
        if (_hasFilters)
          _buildFilterChips(),
        Expanded(child: _buildBody()),
      ]),
      floatingActionButton: (_summary.isNotEmpty || _groupedLines.isNotEmpty)
          ? FloatingActionButton.small(
              heroTag: 'summary',
              backgroundColor: AppColors.primary,
              onPressed: _showSummaryDialog,
              child: const Icon(Icons.summarize_rounded, color: Colors.white),
            )
          : null,
    );
  }

  void _showSummaryDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollCtrl) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: ListView(
          controller: scrollCtrl,
          children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.summarize_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text('Report Summary', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height: 12),

            // Grand totals
            if (_summary.isNotEmpty) ...[
              const _SectionLabel('TOTALS'),
              ..._summary.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.text)),
              )),
            ],

            // Grouped breakdowns
            if (_groupedLines.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (var i = 0; i < _groupedLines.length; i++)
                _groupedLines[i].startsWith('  ')
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 4),
                        child: Text(_groupedLines[i].trim(),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Text(_groupedLines[i],
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.8)),
                      ),
            ],
          ],
        ),
      )),
    );
  }

  // ── Share as CSV ──

  Future<void> _shareCsv() async {
    final buf = StringBuffer();
    buf.writeln(_headers.join(','));
    for (final row in _cells) {
      buf.writeln(row.map((c) => '"${c.replaceAll('"', '""')}"').join(','));
    }
    if (_totalsRow.isNotEmpty) {
      buf.writeln(_totalsRow.map((c) => '"${c.replaceAll('"', '""')}"').join(','));
    }
    final filename = '${widget.title.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(buf.toString());
    await Share.shareXFiles([XFile(file.path)], text: widget.title);
  }

  // ── Export as PDF ──

  Future<void> _exportPdf() async {
    final doc = pw.Document();
    final fmt = DateFormat('dd/MM/yyyy HH:mm');

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (ctx) => [
        pw.Header(
          level: 0,
          child: pw.Text(widget.title, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Text('Generated: ${fmt.format(DateTime.now())}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey)),
        pw.SizedBox(height: 12),
        // Table
        pw.TableHelper.fromTextArray(
          headers: _headers,
          data: [..._cells, if (_totalsRow.isNotEmpty) _totalsRow],
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignment: pw.Alignment.centerLeft,
          oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
        ),
        if (_summary.isNotEmpty) ...[
          pw.SizedBox(height: 16),
          ..._summary.map((s) => pw.Text(s, style: const pw.TextStyle(fontSize: 9))),
        ],
      ],
    ));

    final dir = await getTemporaryDirectory();
    final filename = '${widget.title.replaceAll(' ', '_')}_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(await doc.save());

    if (mounted) {
      // Try open, fall back to share
      try {
        await OpenFile.open(file.path);
      } catch (_) {
        await Share.shareXFiles([XFile(file.path)], text: widget.title);
      }
    }
  }

  Widget _buildFilterChips() {
    final chips = <Widget>[];
    if (_dateFrom != null || _dateTo != null) {
      final df = _dateFrom != null ? DateFormat('dd/MM').format(_dateFrom!) : '...';
      final dt = _dateTo != null ? DateFormat('dd/MM/yy').format(_dateTo!) : '...';
      chips.add(_chip('$df – $dt', Icons.calendar_today, () => _showFilterDialog()));
    }
    for (final pn in _selectedProvNums) {
      final p = _refProviders.firstWhere((r) => r['provNum'] == pn, orElse: () => {'abbr': '#$pn'});
      chips.add(_chip(p['abbr'] ?? '#$pn', Icons.person, () {
        setState(() => _selectedProvNums.remove(pn)); _page = 1; _load();
      }));
    }
    for (final cn in _selectedClinicNums) {
      final c = _refClinics.firstWhere((r) => r['clinicNum'] == cn, orElse: () => {'description': 'Clinic #$cn'});
      chips.add(_chip(c['description'] ?? 'Clinic #$cn', Icons.business, () {
        setState(() => _selectedClinicNums.remove(cn)); _page = 1; _load();
      }));
    }
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
        ...chips,
      ])),
    );
  }

  Widget _chip(String label, IconData icon, VoidCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 12, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary)),
            if (onTap != null) ...[
              const SizedBox(width: 2),
              const Icon(Icons.close, size: 12, color: AppColors.primary),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(_error!, style: const TextStyle(color: Colors.red))));
    if (_cells.isEmpty) return const Center(child: Text('No data', style: TextStyle(color: AppColors.textMuted, fontSize: 16)));

    // Build the full table as a single wide widget
    final table = Column(children: [
      _row(_headers, isHeader: true),
      for (var i = 0; i < _cells.length; i++) _row(_cells[i], even: i.isEven),
      if (_totalsRow.isNotEmpty) _row(_totalsRow, isTotal: true),
    ]);

    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: table,
          ),
        ),
      ),
        // Pagination footer
        if (_footer.isNotEmpty)
          Container(
            width: double.infinity,
            color: AppColors.primary.withOpacity(0.08),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: const Icon(Icons.chevron_left, size: 20), onPressed: _page > 1 ? () => _goPage(-1) : null, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
              Text(_footer, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
              IconButton(icon: const Icon(Icons.chevron_right, size: 20), onPressed: (_page * _pageSize < _totalCount) ? () => _goPage(1) : null, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
            ]),
          ),
    ]);
  }

  Widget _row(List<String> cells, {bool isHeader = false, bool even = false, bool isTotal = false}) {
    final bg = isTotal ? AppColors.primary : (isHeader ? AppColors.primary : (even ? Colors.white : const Color(0xFFF8F9FA)));
    final style = TextStyle(color: (isTotal || isHeader) ? Colors.white : AppColors.text, fontWeight: (isTotal || isHeader) ? FontWeight.w700 : FontWeight.normal, fontSize: 11);
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        children: List.generate(cells.length, (i) => SizedBox(
          width: _w(_headers[i]),
          child: Text(cells[i], style: style, overflow: TextOverflow.ellipsis),
        )),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Filter bottom sheet
// ═══════════════════════════════════════════════════════════════

class _FilterSheet extends StatefulWidget {
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Set<int> selectedProvNums;
  final Set<int> selectedClinicNums;
  final List<Map<String, dynamic>> providers;
  final List<Map<String, dynamic>> clinics;
  final void Function(DateTime? from, DateTime? to, Set<int> provs, Set<int> clinics) onApply;

  const _FilterSheet({
    required this.dateFrom, required this.dateTo,
    required this.selectedProvNums, required this.selectedClinicNums,
    required this.providers, required this.clinics,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late DateTime? _from;
  late DateTime? _to;
  late Set<int> _provs;
  late Set<int> _clinics;

  @override void initState() {
    super.initState();
    _from = widget.dateFrom;
    _to = widget.dateTo;
    _provs = Set<int>.from(widget.selectedProvNums);
    _clinics = Set<int>.from(widget.selectedClinicNums);
  }

  Future<void> _pick(bool isFrom) async {
    final initial = isFrom ? (_from ?? DateTime.now()) : (_to ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() { if (isFrom) _from = picked; else _to = picked; });
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Filter Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(onPressed: () {
                setState(() { _from = null; _to = null; _provs.clear(); _clinics.clear(); });
              }, child: const Text('Clear All')),
            ]),
            const SizedBox(height: 16),

            // Date Range
            const _SectionLabel('Date Range'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _DateField(label: 'From', date: _from, onTap: () => _pick(true))),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('—')),
              Expanded(child: _DateField(label: 'To', date: _to, onTap: () => _pick(false))),
            ]),
            const SizedBox(height: 20),

            // Providers
            if (widget.providers.isNotEmpty) ...[
              const _SectionLabel('Providers'),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 4, children: widget.providers.map((p) {
                final pn = p['provNum'] as int;
                final abbr = p['abbr'] ?? '#$pn';
                final sel = _provs.contains(pn);
                return FilterChip(
                  label: Text(abbr, style: TextStyle(fontSize: 12, color: sel ? Colors.white : null)),
                  selected: sel,
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  onSelected: (v) => setState(() { if (v) _provs.add(pn); else _provs.remove(pn); }),
                  visualDensity: VisualDensity.compact,
                );
              }).toList()),
              const SizedBox(height: 20),
            ],

            // Clinics
            if (widget.clinics.isNotEmpty) ...[
              const _SectionLabel('Clinics'),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 4, children: widget.clinics.map((c) {
                final cn = c['clinicNum'] as int;
                final desc = c['description'] ?? 'Clinic #$cn';
                final sel = _clinics.contains(cn);
                return FilterChip(
                  label: Text(desc, style: TextStyle(fontSize: 12, color: sel ? Colors.white : null)),
                  selected: sel,
                  selectedColor: AppColors.primary,
                  checkmarkColor: Colors.white,
                  onSelected: (v) => setState(() { if (v) _clinics.add(cn); else _clinics.remove(cn); }),
                  visualDensity: VisualDensity.compact,
                );
              }).toList()),
              const SizedBox(height: 20),
            ],

            // Apply button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  widget.onApply(_from, _to, _provs, _clinics);
                  Navigator.pop(ctx);
                },
                child: const Text('Apply Filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext ctx) => Text(text, style: const TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5));
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateField({required this.label, this.date, required this.onTap});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(children: [
          const Icon(Icons.calendar_today, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(date != null ? DateFormat('dd/MM/yyyy').format(date!) : label,
            style: TextStyle(fontSize: 14, color: date != null ? AppColors.text : AppColors.textMuted)),
        ]),
      ),
    );
  }
}
