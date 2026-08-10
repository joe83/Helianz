import 'package:flutter/material.dart';
import 'package:dentalcare_pro/theme/app_theme.dart';
import 'package:dentalcare_pro/services/auth_service.dart';
import 'package:dentalcare_pro/services/api_config.dart';

class LoginScreen extends StatefulWidget {
  final AuthService auth;
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.auth, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  bool _obscure = true;
  bool _showUrl = false;

  @override
  void initState() {
    super.initState();
    _urlCtrl.text = ApiConfig.baseUrl;
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final u = _userCtrl.text.trim();
    final p = _passCtrl.text;
    final url = _urlCtrl.text.trim();
    if (u.isEmpty) {
      setState(() => _error = 'Username is required');
      return;
    }
    if (url.isEmpty) {
      setState(() => _error = 'Server URL is required');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ApiConfig.setBaseUrl(url);
      final ok = await widget.auth.login(u, p);
      if (!mounted) return;
      if (ok) {
        widget.onLoginSuccess();
      } else {
        setState(() { _error = 'Invalid username or password'; _loading = false; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Connection error: $e'; _loading = false; });
    }
  }

  Future<void> _debugLogin() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty) {
      setState(() => _error = 'Server URL is required');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await ApiConfig.setBaseUrl(url);
      final ok = await widget.auth.getDebugToken();
      if (!mounted) return;
      if (ok) {
        widget.onLoginSuccess();
      } else {
        setState(() { _error = 'Cannot connect to server'; _loading = false; });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Connection error: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / title
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 24),
                Text('Helianz', style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('Dental Practice Management',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 40),

                // Error
                if (_error != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],

                // Server URL
                TextField(
                  controller: _urlCtrl,
                  enabled: !_loading,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Server URL',
                    hintText: 'http://192.168.1.100:5000',
                    prefixIcon: const Icon(Icons.dns_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_showUrl ? Icons.check : Icons.edit, size: 18),
                      onPressed: () => setState(() => _showUrl = !_showUrl),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Username
                TextField(
                  controller: _userCtrl,
                  enabled: !_loading,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passCtrl,
                  enabled: !_loading,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _login(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 16),

                // Debug / skip login (dev only)
                TextButton(
                  onPressed: _loading ? null : _debugLogin,
                  child: Text('Skip login (debug)', style: TextStyle(color: AppColors.textMuted.withOpacity(0.5), fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
