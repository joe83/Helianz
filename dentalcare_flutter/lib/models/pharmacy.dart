import 'package:flutter/material.dart';

/// Pharmacy model — matches Helianz pharmacy table via reference data
class Pharmacy {
  final int pharmacyNum;
  final String? storeName;
  final String? phone;
  final String? address;
  final String? address2;
  final String? city;
  final String? state;
  final String? zip;
  final String? note;

  Pharmacy({
    required this.pharmacyNum,
    this.storeName,
    this.phone,
    this.address,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.note,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      pharmacyNum: json['pharmacyNum'] ?? 0,
      storeName: json['storeName'],
      phone: json['phone'],
      address: json['address'],
      address2: json['address2'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      note: json['note'],
    );
  }

  String get displayName => storeName ?? 'Unknown Pharmacy';

  String get locationDisplay {
    final parts = [city, state].where((s) => s != null && s.isNotEmpty);
    return parts.join(', ');
  }

  IconData get icon => Icons.local_pharmacy_rounded;
  Color get color => Colors.teal;
}
