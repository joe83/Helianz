import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prima_dental_care/theme/app_theme.dart';
import 'package:prima_dental_care/screens/appointments_screen.dart';
import 'package:prima_dental_care/screens/patients_screen.dart';
import 'package:prima_dental_care/screens/reports_screen.dart';
import 'package:prima_dental_care/screens/more_options_screen.dart';
import 'package:prima_dental_care/services/auth_service.dart';
import 'package:prima_dental_care/services/api_client.dart';
import 'package:prima_dental_care/services/api_config.dart';
import 'package:prima_dental_care/models/report.dart';
import 'package:prima_dental_care/widgets/bottom_nav.dart';
import 'package:prima_dental_care/widgets/clinic_switcher_sheet.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PrimaDentalCareApp());
}

class PrimaDentalCareApp extends StatelessWidget {
  const PrimaDentalCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prima Dental Care',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(AppTheme.lightTheme.textTheme),
      ),
      home: const AppBootstrap(),
    );
  }
}

/// Bootstraps services (auth, API client) before showing the main UI.
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  final AuthService _auth = AuthService();
  late final HelianzApiClient _api = HelianzApiClient(_auth);
  bool _loggedIn = false;
  bool _checking = true; // checking for saved session

  @override
  void initState() {
    super.initState();
    _auth.addListener(_onAuthChanged);
    _tryRestoreSession();
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> _loadReferenceClinics() async {
    try {
      final refJson = await _api.getReferenceData();
      final ref = ReferenceData.fromJson(refJson);
      if (ref.clinics.isNotEmpty) {
        _auth.updateAvailableClinics(ref.clinics);
      }
    } catch (_) {}
  }

  Future<void> _tryRestoreSession() async {
    await ApiConfig.load(); // load saved server URL first
    final restored = await _auth.restoreSession();
    if (restored) {
      _loadReferenceClinics();
    }
    if (mounted) {
      setState(() {
        _loggedIn = restored;
        _checking = false;
      });
    }
  }

  void _onAuthChanged() {
    // When token is cleared (logout), go back to login
    if (!_auth.isLoggedIn && _loggedIn) {
      setState(() => _loggedIn = false);
    }
  }

  void _onLoginSuccess() {
    _loadReferenceClinics();
    setState(() => _loggedIn = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_loggedIn) {
      return LoginScreen(auth: _auth, onLoginSuccess: _onLoginSuccess);
    }
    return AppServices(
      auth: _auth,
      api: _api,
      child: const MainScreen(),
    );
  }
}

/// Inherited widget to provide services down the tree and notify dependents on auth changes.
class AppServices extends InheritedNotifier<AuthService> {
  final AuthService auth;
  final HelianzApiClient api;

  const AppServices({
    super.key,
    required this.auth,
    required this.api,
    required super.child,
  }) : super(notifier: auth);

  static AppServices of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppServices>();
    assert(result != null, 'No AppServices found in context');
    return result!;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<_TabInfo> _buildTabs(AuthService auth, HelianzApiClient api) {
    final clinicKey = auth.activeClinicNum ?? 0;
    final tabs = <_TabInfo>[];
    if (auth.canViewAppointments) {
      tabs.add(_TabInfo(
        AppointmentsScreen(key: ValueKey('appts_$clinicKey')),
        'Appointments',
        Icons.calendar_today_rounded,
        'Appts',
      ));
    }
    if (auth.canViewPatients) {
      tabs.add(_TabInfo(
        PatientsScreen(key: ValueKey('patients_$clinicKey')),
        'Patients',
        Icons.people_rounded,
        'Patients',
      ));
    }
    if (auth.canViewReports) {
      tabs.add(_TabInfo(ReportsScreen(api: api), 'Reports', Icons.bar_chart_rounded, 'Reports'));
    }
    // More Options always visible (has logout)
    tabs.add(_TabInfo(MoreOptionsScreen(auth: auth, api: api), 'More Options', Icons.menu_rounded, 'More'));
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    final services = AppServices.of(context);
    final tabs = _buildTabs(services.auth, services.api);

    // Clamp index if permissions changed
    if (_currentIndex >= tabs.length) {
      _currentIndex = tabs.length - 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tabs[_currentIndex].title),
        actions: [
          Builder(
            builder: (context) {
              final canSwitch = services.auth.canSwitchClinic;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: InkWell(
                  onTap: canSwitch
                      ? () => ClinicSwitcherSheet.show(
                            context,
                            services.auth,
                            onClinicChanged: () {
                              if (mounted) setState(() {});
                            },
                          )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_hospital_rounded, size: 14, color: AppColors.accent),
                        const SizedBox(width: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 130),
                          child: Text(
                            services.auth.activeClinicName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (canSwitch) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down_rounded, size: 18, color: Colors.white70),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs.map((t) => t.screen).toList(),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: tabs.map((t) => NavItem(icon: t.icon, label: t.label)).toList(),
      ),
    );
  }
}

class _TabInfo {
  final Widget screen;
  final String title;
  final IconData icon;
  final String label;
  const _TabInfo(this.screen, this.title, this.icon, this.label);
}
