/// Patient model — matches HelianzApi /api/patients response
class Patient {
  final int patNum;
  final String? lName;
  final String? fName;
  final String? middleI;
  final String? preferred;
  final int? gender;       // 0=Male, 1=Female, 2=Unknown/Other
  final String? birthdate;
  final String? ssn;
  final String? address;
  final String? address2;
  final String? city;
  final String? state;
  final String? zip;
  final String? hmPhone;
  final String? wkPhone;
  final String? wirelessPhone;
  final String? email;
  final int? clinicNum;
  final int? patientStatus;
  final String? dateFirstVisit;
  final int? priProv;
  final String? chartNumber;
  final String? medicalUrgency;
  final String? country;
  final bool? hasIns;
  final double? balanceTotal;
  final double? insEstTotal;
  final int? age;

  Patient({
    required this.patNum,
    this.lName,
    this.fName,
    this.middleI,
    this.preferred,
    this.gender,
    this.birthdate,
    this.ssn,
    this.address,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.hmPhone,
    this.wkPhone,
    this.wirelessPhone,
    this.email,
    this.clinicNum,
    this.patientStatus,
    this.dateFirstVisit,
    this.priProv,
    this.chartNumber,
    this.medicalUrgency,
    this.country,
    this.hasIns,
    this.balanceTotal,
    this.insEstTotal,
    this.age,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patNum: json['patNum'] ?? 0,
      lName: json['lName'],
      fName: json['fName'],
      middleI: json['middleI'],
      preferred: json['preferred'],
      gender: json['gender'],
      birthdate: json['birthdate']?.toString(),
      ssn: json['ssn'],
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      hmPhone: json['hmPhone'],
      wkPhone: json['wkPhone'],
      wirelessPhone: json['wirelessPhone'],
      email: json['email'],
      clinicNum: json['clinicNum'],
      patientStatus: json['patientStatus'],
      dateFirstVisit: json['dateFirstVisit']?.toString(),
      priProv: json['priProv'],
      chartNumber: json['chartNumber'],
      medicalUrgency: json['medicalUrgency'],
      country: json['country'],
      hasIns: json['hasIns'],
      balanceTotal: (json['balanceTotal'] as num?)?.toDouble(),
      insEstTotal: (json['insEstTotal'] as num?)?.toDouble(),
      age: json['age'],
    );
  }

  /// Indonesian name format: FirstName LastName (no comma).
  /// When no first name, shows last name only.
  String get displayName {
    final last = (lName ?? '').trim();
    final first = (fName ?? '').trim();
    if (first.isEmpty) return last;
    if (last.isEmpty) return first;
    return '$first $last';
  }

  String get initials {
    final f = (fName ?? '').isNotEmpty ? fName![0] : '';
    final l = (lName ?? '').isNotEmpty ? lName![0] : '';
    return '$f$l'.toUpperCase();
  }

  String? get primaryPhone => wirelessPhone ?? hmPhone ?? wkPhone;

  String get genderDisplay {
    switch (gender) {
      case 0: return 'Male';
      case 1: return 'Female';
      default: return 'Unknown';
    }
  }

  String get patientStatusDisplay {
    switch (patientStatus) {
      case 0: return 'Patient';
      case 1: return 'NonPatient';
      case 2: return 'Inactive';
      case 3: return 'Other';
      default: return 'Patient';
    }
  }
}

class PatientSearchResult {
  final List<Patient> patients;
  final int totalCount;
  final int page;
  final int pageSize;

  PatientSearchResult({
    required this.patients,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  factory PatientSearchResult.fromJson(Map<String, dynamic> json) {
    return PatientSearchResult(
      patients: (json['patients'] as List?)
              ?.map((p) => Patient.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 50,
    );
  }
}
