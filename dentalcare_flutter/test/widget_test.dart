import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prima_dental_care/main.dart';
import 'package:prima_dental_care/models/report.dart';
import 'package:prima_dental_care/services/api_client.dart';
import 'package:prima_dental_care/services/auth_service.dart';
import 'package:prima_dental_care/widgets/clinic_switcher_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Clinic and Multi-Clinic Model Tests', () {
    test('ClinicInfo parses from JSON correctly', () {
      final json = {
        'clinicNum': 2,
        'description': 'Boyolali 1',
        'address': 'Jl. Pandanaran No. 45',
        'city': 'Boyolali',
        'phone': '0276-123456',
        'isMedicalClinic': 0,
      };

      final clinic = ClinicInfo.fromJson(json);
      expect(clinic.clinicNum, 2);
      expect(clinic.description, 'Boyolali 1');
      expect(clinic.address, 'Jl. Pandanaran No. 45');
      expect(clinic.city, 'Boyolali');
    });

    test('AuthService manages active clinic switching and persistence', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthService();

      final clinics = [
        ClinicInfo(clinicNum: 1, description: 'Klaten 1'),
        ClinicInfo(clinicNum: 2, description: 'Boyolali 1'),
        ClinicInfo(clinicNum: 3, description: 'Jogja 1'),
      ];

      auth.updateAvailableClinics(clinics);
      expect(auth.isMultiClinic, true);
      expect(auth.availableClinics.length, 3);

      await auth.setActiveClinic(2, 'Boyolali 1');
      expect(auth.activeClinicNum, 2);
      expect(auth.activeClinicName, 'Boyolali 1');

      await auth.setActiveClinic(0, 'All Clinics');
      expect(auth.activeClinicNum, 0);
      expect(auth.activeClinicName, 'All Clinics');
    });

    testWidgets('AppServices InheritedNotifier updates dependent widgets on clinic change', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthService();
      final api = HelianzApiClient(auth);

      auth.updateAvailableClinics([
        ClinicInfo(clinicNum: 1, description: 'Klaten 1'),
        ClinicInfo(clinicNum: 2, description: 'Boyolali 1'),
      ]);
      await auth.setActiveClinic(1, 'Klaten 1');

      await tester.pumpWidget(
        MaterialApp(
          home: AppServices(
            auth: auth,
            api: api,
            child: Builder(
              builder: (context) {
                final services = AppServices.of(context);
                return Text('Active: ${services.auth.activeClinicName}');
              },
            ),
          ),
        ),
      );

      expect(find.text('Active: Klaten 1'), findsOneWidget);

      // Now switch clinic to Boyolali 1
      await auth.setActiveClinic(2, 'Boyolali 1');
      await tester.pumpAndSettle();

      expect(find.text('Active: Boyolali 1'), findsOneWidget);
    });

    testWidgets('ClinicSwitcherSheet allows selecting branch and updates auth', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthService();

      auth.updateAvailableClinics([
        ClinicInfo(clinicNum: 1, description: 'Klaten 1'),
        ClinicInfo(clinicNum: 2, description: 'Boyolali 1'),
      ]);
      await auth.setActiveClinic(1, 'Klaten 1');

      bool changedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClinicSwitcherSheet(
              auth: auth,
              onClinicChanged: () => changedCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Boyolali 1'), findsOneWidget);

      // Tap on Boyolali 1
      await tester.tap(find.text('Boyolali 1'));
      await tester.pumpAndSettle();

      expect(auth.activeClinicNum, 2);
      expect(auth.activeClinicName, 'Boyolali 1');
      expect(changedCalled, true);
    });

    test('AuthService restricts available clinics for restricted user', () {
      final auth = AuthService();
      // If user has 1 clinic
      auth.updateAvailableClinics([ClinicInfo(clinicNum: 2, description: 'Boyolali 1')]);
      expect(auth.canSwitchClinic, false);

      // If user has 2 clinics
      auth.updateAvailableClinics([
        ClinicInfo(clinicNum: 1, description: 'Klaten 1'),
        ClinicInfo(clinicNum: 2, description: 'Boyolali 1'),
      ]);
      expect(auth.canSwitchClinic, true);
    });
  });
}
