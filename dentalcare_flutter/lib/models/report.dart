/// Dashboard KPI model — matches HelianzApi /api/dashboard/kpis
class DashboardKpi {
  final double totalProduction;
  final double totalIncome;
  final int totalPatients;
  final int todayAppointments;
  final double arBalance;

  DashboardKpi({
    required this.totalProduction,
    required this.totalIncome,
    required this.totalPatients,
    required this.todayAppointments,
    required this.arBalance,
  });

  factory DashboardKpi.fromJson(Map<String, dynamic> json) {
    return DashboardKpi(
      totalProduction: (json['totalProduction'] as num?)?.toDouble() ?? 0,
      totalIncome: (json['totalIncome'] as num?)?.toDouble() ?? 0,
      totalPatients: json['totalPatients'] ?? 0,
      todayAppointments: json['todayAppointments'] ?? 0,
      arBalance: (json['arBalance'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Revenue trend data point
class RevenueTrend {
  final String period;
  final double production;
  final double income;

  RevenueTrend({
    required this.period,
    required this.production,
    required this.income,
  });

  factory RevenueTrend.fromJson(Map<String, dynamic> json) {
    return RevenueTrend(
      period: json['period'] ?? '',
      production: (json['production'] as num?)?.toDouble() ?? 0,
      income: (json['income'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Provider performance data
class ProviderStat {
  final int provNum;
  final String? provName;
  final double production;
  final double income;
  final int appointments;

  ProviderStat({
    required this.provNum,
    this.provName,
    required this.production,
    required this.income,
    required this.appointments,
  });

  factory ProviderStat.fromJson(Map<String, dynamic> json) {
    return ProviderStat(
      provNum: json['provNum'] ?? 0,
      provName: json['provName'],
      production: (json['production'] as num?)?.toDouble() ?? 0,
      income: (json['income'] as num?)?.toDouble() ?? 0,
      appointments: json['appointments'] ?? 0,
    );
  }
}

/// AR aging data
class ArAging {
  final double current;
  final double days30;
  final double days60;
  final double days90;
  final double over90;

  ArAging({
    required this.current,
    required this.days30,
    required this.days60,
    required this.days90,
    required this.over90,
  });

  factory ArAging.fromJson(Map<String, dynamic> json) {
    return ArAging(
      current: (json['current'] as num?)?.toDouble() ?? 0,
      days30: (json['days30'] as num?)?.toDouble() ?? 0,
      days60: (json['days60'] as num?)?.toDouble() ?? 0,
      days90: (json['days90'] as num?)?.toDouble() ?? 0,
      over90: (json['over90'] as num?)?.toDouble() ?? 0,
    );
  }
}

/// Reference data container
class ReferenceData {
  final List<Provider> providers;
  final List<Operatory> operatories;
  final List<ProcedureCode> procedureCodes;
  final List<AppointmentType> appointmentTypes;
  final List<Definition> paymentTypes;
  final List<Definition> commTypes;

  ReferenceData({
    this.providers = const [],
    this.operatories = const [],
    this.procedureCodes = const [],
    this.appointmentTypes = const [],
    this.paymentTypes = const [],
    this.commTypes = const [],
  });

  factory ReferenceData.fromJson(Map<String, dynamic> json) {
    return ReferenceData(
      providers: _parseList(json['providers'], Provider.fromJson),
      operatories: _parseList(json['operatories'], Operatory.fromJson),
      procedureCodes:
          _parseList(json['procedureCodes'], ProcedureCode.fromJson),
      appointmentTypes:
          _parseList(json['appointmentTypes'], AppointmentType.fromJson),
      paymentTypes: _parseList(json['paymentTypes'], Definition.fromJson),
      commTypes: _parseList(json['commTypes'], Definition.fromJson),
    );
  }

  static List<T> _parseList<T>(
      dynamic list, T Function(Map<String, dynamic>) fromJson) {
    if (list == null) return [];
    return (list as List)
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

class Provider {
  final int provNum;
  final String? abbr;
  final String? fName;
  final String? lName;
  final int? clinicNum;
  final bool? isHidden;
  final bool? isSecondary;
  final String? specialty;

  Provider({
    required this.provNum,
    this.abbr,
    this.fName,
    this.lName,
    this.clinicNum,
    this.isHidden,
    this.isSecondary,
    this.specialty,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        provNum: json['provNum'] ?? 0,
        abbr: json['abbr'],
        fName: json['fName'],
        lName: json['lName'],
        clinicNum: json['clinicNum'],
        isHidden: json['isHidden'],
        isSecondary: json['isSecondary'],
        specialty: json['specialty'],
      );

  String get displayName {
    if (abbr != null && abbr!.isNotEmpty) return abbr!;
    return '${fName ?? ''} ${lName ?? ''}'.trim();
  }
}

class Operatory {
  final int operatoryNum;
  final String? opName;
  final int? clinicNum;
  final int? provDentist;
  final int? provHygienist;
  final bool? isHidden;
  final int? setOrder;

  Operatory({
    required this.operatoryNum,
    this.opName,
    this.clinicNum,
    this.provDentist,
    this.provHygienist,
    this.isHidden,
    this.setOrder,
  });

  factory Operatory.fromJson(Map<String, dynamic> json) => Operatory(
        operatoryNum: json['operatoryNum'] ?? 0,
        opName: json['opName'],
        clinicNum: json['clinicNum'],
        provDentist: json['provDentist'],
        provHygienist: json['provHygienist'],
        isHidden: json['isHidden'],
        setOrder: json['setOrder'],
      );

  String get displayName => opName ?? 'Op ${operatoryNum}';
}

class ProcedureCode {
  final int codeNum;
  final String? procCode;
  final String? descript;
  final String? abbrDesc;
  final int? procCat;
  final String? procCatName;
  final double? procFee;
  final bool? isHygiene;
  final String? paintType;
  final String? treatmentArea;

  ProcedureCode({
    required this.codeNum,
    this.procCode,
    this.descript,
    this.abbrDesc,
    this.procCat,
    this.procCatName,
    this.procFee,
    this.isHygiene,
    this.paintType,
    this.treatmentArea,
  });

  factory ProcedureCode.fromJson(Map<String, dynamic> json) => ProcedureCode(
        codeNum: json['codeNum'] ?? 0,
        procCode: json['procCode'],
        descript: json['descript'],
        abbrDesc: json['abbrDesc'],
        procCat: json['procCat'],
        procCatName: json['procCatName'],
        procFee: (json['procFee'] as num?)?.toDouble(),
        isHygiene: json['isHygiene'],
        paintType: json['paintType'],
        treatmentArea: json['treatmentArea'],
      );

  String get displayName => '$procCode — ${descript ?? ''}';
}

class AppointmentType {
  final int appointmentTypeNum;
  final String? appointmentTypeName;
  final String? pattern;
  final String? codeStr;
  final String? codeStrRequired;
  final int? length;

  AppointmentType({
    required this.appointmentTypeNum,
    this.appointmentTypeName,
    this.pattern,
    this.codeStr,
    this.codeStrRequired,
    this.length,
  });

  factory AppointmentType.fromJson(Map<String, dynamic> json) =>
      AppointmentType(
        appointmentTypeNum: json['appointmentTypeNum'] ?? 0,
        appointmentTypeName: json['appointmentTypeName'],
        pattern: json['pattern'],
        codeStr: json['codeStr'],
        codeStrRequired: json['codeStrRequired'],
        length: json['length'],
      );

  String get displayName => appointmentTypeName ?? 'Type ${appointmentTypeNum}';
}

class Definition {
  final int defNum;
  final String? itemName;
  final int? category;
  final int? itemOrder;

  Definition({
    required this.defNum,
    this.itemName,
    this.category,
    this.itemOrder,
  });

  factory Definition.fromJson(Map<String, dynamic> json) => Definition(
        defNum: json['defNum'] ?? 0,
        itemName: json['itemName'],
        category: json['category'],
        itemOrder: json['itemOrder'],
      );

  String get displayName => itemName ?? 'Def ${defNum}';
}
