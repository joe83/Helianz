/// Appointment model — matches HelianzApi /api/appointments response
import 'package:intl/intl.dart';

class Appointment {
  final int aptNum;
  final int? patNum;
  final String? patientName;
  final int? aptStatus;
  final int? clinicNum;
  final int? provNum;
  final int? provHyg;
  final int? opNum;
  final String? opName;
  final String? aptDateTime;
  final int? length;
  final String? pattern;
  final String? note;
  final int? confirmed;
  final int? appointmentTypeNum;
  final String? appointmentTypeName;
  final bool isNewPatient;
  final bool isHygiene;
  final String? provName;
  final String? provHygName;
  final String? patientPhone;
  final String? dateTStamp;

  Appointment({
    required this.aptNum,
    this.patNum,
    this.patientName,
    this.aptStatus,
    this.clinicNum,
    this.provNum,
    this.provHyg,
    this.opNum,
    this.opName,
    this.aptDateTime,
    this.length,
    this.pattern,
    this.note,
    this.confirmed,
    this.appointmentTypeNum,
    this.appointmentTypeName,
    this.isNewPatient = false,
    this.isHygiene = false,
    this.provName,
    this.provHygName,
    this.patientPhone,
    this.dateTStamp,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      aptNum: json['aptNum'] ?? 0,
      patNum: json['patNum'],
      patientName: json['patientName'],
      aptStatus: json['aptStatus'],
      clinicNum: json['clinicNum'],
      provNum: json['provNum'],
      provHyg: json['provHyg'],
      opNum: json['opNum'],
      opName: json['opName'],
      aptDateTime: json['aptDateTime'],
      length: json['length'],
      pattern: json['pattern'],
      note: json['note'],
      confirmed: json['confirmed'],
      appointmentTypeNum: json['appointmentTypeNum'],
      appointmentTypeName: json['appointmentTypeName'],
      isNewPatient: _parseBool(json['isNewPatient']) ?? false,
      isHygiene: _parseBool(json['isHygiene']) ?? false,
      provName: json['provName'],
      provHygName: json['provHygName'],
      patientPhone: json['patientPhone'],
      dateTStamp: json['dateTStamp'],
    );
  }

  static bool? _parseBool(dynamic val) {
    if (val == null) return null;
    if (val is bool) return val;
    if (val is int) return val != 0;
    if (val is String) return val.toLowerCase() == 'true' || val == '1';
    return null;
  }

  /// Status display string — matches Helianz ApptStatus enum (0=None,1=Scheduled,2=Complete,3=UnschedList,4=ASAP,5=Broken,6=Planned)
  String get statusDisplay {
    switch (aptStatus) {
      case 1: return 'Scheduled';
      case 2: return 'Complete';
      case 3: return 'UnschedList';
      case 4: return 'ASAP';
      case 5: return 'Broken';
      case 6: return 'Planned';
      default: return 'Scheduled';
    }
  }

  bool get isCanceled => aptStatus == 5; // Broken = big X in desktop

  /// Indonesian format: converts "LastName, FirstName" → "FirstName LastName"
  String get displayName {
    final raw = patientName ?? '';
    final comma = raw.indexOf(',');
    if (comma == -1) return raw.trim();
    final last = raw.substring(0, comma).trim();
    final first = raw.substring(comma + 1).trim();
    if (first.isEmpty) return last;
    if (last.isEmpty) return first;
    return '$first $last';
  }

  DateTime? get startTime {
    if (aptDateTime == null) return null;
    return DateTime.tryParse(aptDateTime!);
  }

  /// Formatted time string (HH:mm)
  String get timeDisplay {
    final t = startTime;
    if (t == null) return '';
    return DateFormat('HH:mm').format(t);
  }
}

class AppointmentSearchResult {
  final List<Appointment> appointments;
  final int totalCount;

  AppointmentSearchResult({
    required this.appointments,
    required this.totalCount,
  });

  factory AppointmentSearchResult.fromJson(Map<String, dynamic> json) {
    return AppointmentSearchResult(
      appointments: (json['appointments'] as List?)
              ?.map((a) => Appointment.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
