import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dentalcare_pro/theme/app_theme.dart';
import 'package:dentalcare_pro/screens/appointments_screen.dart';
import 'package:dentalcare_pro/screens/patients_screen.dart';
import 'package:dentalcare_pro/screens/reports_screen.dart';
import 'package:dentalcare_pro/screens/more_options_screen.dart';
import 'package:dentalcare_pro/services/auth_service.dart';
import 'package:dentalcare_pro/services/api_client.dart';
import 'package:dentalcare_pro/services/api_config.dart';
import 'package:dentalcare_pro/widgets/bottom_nav.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DentalCareApp());
}

class DentalCareApp extends StatelessWidget {
  const DentalCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DentalCare Pro',
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

  Future<void> _tryRestoreSession() async {
    await ApiConfig.load(); // load saved server URL first
    final restored = await _auth.restoreSession();
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

  void _onLoginSuccess() => setState(() => _loggedIn = true);

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

/// Inherited widget to provide services down the tree.
class AppServices extends InheritedWidget {
  final AuthService auth;
  final HelianzApiClient api;

  const AppServices({
    super.key,
    required this.auth,
    required this.api,
    required super.child,
  });

  static AppServices of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppServices>();
    assert(result != null, 'No AppServices found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppServices oldWidget) =>
      auth != oldWidget.auth || api != oldWidget.api;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<_TabInfo> _buildTabs(AuthService auth, HelianzApiClient api) {
    final tabs = <_TabInfo>[];
    if (auth.canViewAppointments) {
      tabs.add(_TabInfo(const AppointmentsScreen(), 'Appointments', Icons.calendar_today_rounded, 'Appts'));
    }
    if (auth.canViewPatients) {
      tabs.add(_TabInfo(const PatientsScreen(), 'Patients', Icons.people_rounded, 'Patients'));
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
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.today_rounded),
            ),
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.refresh_rounded),
            ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
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
