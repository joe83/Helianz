import 'package:flutter/material.dart';
import 'package:prima_dental_care/theme/app_theme.dart';
import 'package:prima_dental_care/services/api_client.dart';
import 'package:prima_dental_care/widgets/accordion.dart';
import 'report_table_screen.dart';

class ReportsScreen extends StatelessWidget {
  final HelianzApiClient api;
  const ReportsScreen({super.key, required this.api});

  void _openReport(BuildContext context, String title, ReportType type) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ReportTableScreen(title: title, reportType: type, api: api),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // ── Production and Income ──
        Accordion(title: 'Production and Income', initiallyExpanded: true, children: [
            _rpt(context, 'Today', ReportType.prodToday),
            _rpt(context, 'Yesterday', ReportType.prodYesterday),
            _rpt(context, 'This Month', ReportType.prodThisMonth),
            _rpt(context, 'Last Month', ReportType.prodLastMonth),
            _rpt(context, 'This Year', ReportType.prodThisYear),
            _rpt(context, 'More Options', ReportType.prodMoreOptions),
            _rpt(context, 'Monthly Production Goal', ReportType.prodGoal),
          ]),
          // ── Daily ──
          Accordion(title: 'Daily', children: [
            _rpt(context, 'Adjustments', ReportType.dailyAdj),
            _rpt(context, 'Payments', ReportType.dailyPayments),
            _rpt(context, 'Procedures', ReportType.dailyProcs),
            _rpt(context, 'Write-offs', ReportType.dailyWriteoffs),
            _rpt(context, 'Incomplete Procedure Notes', ReportType.dailyIncNotes),
            _rpt(context, 'Routing Slips', ReportType.dailyRouting),
            _rpt(context, 'Unfinalized Insurance Payments', ReportType.dailyUnfinalizedIns),
          ]),
          // ── Monthly ──
          Accordion(title: 'Monthly', children: [
            _rpt(context, 'Aging of A/R', ReportType.moArAging),
            _rpt(context, 'Claims Not Sent', ReportType.moClaimsNotSent),
            _rpt(context, 'Finance Charge Report', ReportType.moFinanceCharge),
            _rpt(context, 'Outstanding Insurance Claims', ReportType.moOutInsClaims),
            _rpt(context, 'Procedures Not Billed to Insurance', ReportType.moProcNotBilled),
            _rpt(context, 'PPO Write-offs', ReportType.moPpoWriteoffs),
            _rpt(context, 'Payment Plans', ReportType.moPaymentPlans),
            _rpt(context, 'Receivables Breakdown', ReportType.moReceivables),
            _rpt(context, 'Unearned Income', ReportType.moUnearned),
            _rpt(context, 'Insurance Overpaid', ReportType.moInsOverpaid),
            _rpt(context, 'Presented TreatPlan Production', ReportType.moTreatPlanProd),
          ]),
          // ── Lists ──
          Accordion(title: 'Lists', children: [
            _rpt(context, 'Active Patients', ReportType.listActivePatients),
            _rpt(context, 'Appointments', ReportType.listAppointments),
            _rpt(context, 'Birthdays', ReportType.listBirthdays),
            _rpt(context, 'Broken Appointments', ReportType.listBrokenAppts),
            _rpt(context, 'Insurance Plans', ReportType.listInsPlans),
            _rpt(context, 'New Patients', ReportType.listNewPatients),
            _rpt(context, 'Patients - Raw', ReportType.listPatientsRaw),
            _rpt(context, 'Patient Notes', ReportType.listPatientNotes),
            _rpt(context, 'Prescriptions', ReportType.listPrescriptions),
            _rpt(context, 'Procedure Codes - Fee Schedules', ReportType.listProcFeeSched),
            _rpt(context, 'Referrals - Raw', ReportType.listReferralsRaw),
            _rpt(context, 'Referral Analysis', ReportType.listReferralAnalysis),
            _rpt(context, 'Referred Proc Tracking', ReportType.listRefProcTrack),
            _rpt(context, 'Treatment Finder', ReportType.listTreatmentFinder),
            _rpt(context, 'Web Sched Appointments', ReportType.listWebSched),
          ]),
          // ── Public Health ──
          Accordion(title: 'Public Health', children: [
            _rpt(context, 'Raw Screening Data', ReportType.phScreeningData),
            _rpt(context, 'Raw Population Data', ReportType.phPopulationData),
            _rpt(context, 'FQHC Dental Sealant Measure', ReportType.phFqhcSealant),
          ]),
      ]),
    );
  }

  Widget _rpt(BuildContext context, String label, ReportType type) {
    return InkWell(
      onTap: () => _openReport(context, label, type),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
      ),
    );
  }
}
