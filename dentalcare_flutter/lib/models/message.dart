/// Clinical note model — matches HelianzApi /api/notes response
class ClinicalNote {
  final int commlogNum;
  final int? patNum;
  final String? patientName;
  final int? clinicNum;
  final int? provNum;
  final String? provName;
  final String? commDateTime;
  final String? commType;
  final String? commTypeName;
  final String? note;
  final int? userNum;
  final String? userName;
  final String? dateTStamp;
  final int? aptNum;

  ClinicalNote({
    required this.commlogNum,
    this.patNum,
    this.patientName,
    this.clinicNum,
    this.provNum,
    this.provName,
    this.commDateTime,
    this.commType,
    this.commTypeName,
    this.note,
    this.userNum,
    this.userName,
    this.dateTStamp,
    this.aptNum,
  });

  factory ClinicalNote.fromJson(Map<String, dynamic> json) {
    return ClinicalNote(
      commlogNum: json['commlogNum'] ?? 0,
      patNum: json['patNum'],
      patientName: json['patientName'],
      clinicNum: json['clinicNum'],
      provNum: json['provNum'],
      provName: json['provName'],
      commDateTime: json['commDateTime'],
      commType: json['commType'],
      commTypeName: json['commTypeName'],
      note: json['note'],
      userNum: json['userNum'],
      userName: json['userName'],
      dateTStamp: json['dateTStamp'],
      aptNum: json['aptNum'],
    );
  }

  String get initials {
    final name = userName ?? provName ?? '';
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  DateTime? get dateTime {
    if (commDateTime == null) return null;
    return DateTime.tryParse(commDateTime!);
  }
}

class NoteSearchResult {
  final List<ClinicalNote> notes;
  final int totalCount;

  NoteSearchResult({required this.notes, required this.totalCount});

  factory NoteSearchResult.fromJson(Map<String, dynamic> json) {
    return NoteSearchResult(
      notes: (json['notes'] as List?)
              ?.map((n) => ClinicalNote.fromJson(n as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
    );
  }
}
