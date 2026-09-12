import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';

class SystemAdminLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onBack;

  const SystemAdminLoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onBack,
  });

  @override
  State<SystemAdminLoginScreen> createState() => _SystemAdminLoginScreenState();
}

class _SystemAdminLoginScreenState extends State<SystemAdminLoginScreen> {
  final TextEditingController _userIdController =
      TextEditingController(text: 'SYS_ADMIN_01');
  final TextEditingController _passwordController =
      TextEditingController(text: 'SuperAdmin@Maha2026');

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const MaharashtraEmblemWidget(size: 64, showText: true),
            const SizedBox(height: 16),
            const Text(
              'System Administrator Console',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            const Text(
              'State Data & Officer Directory Management',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),

            const SizedBox(height: 24),

            // Demo Auto-fill Banner
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.saffronLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.saffron.withAlpha(80)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.admin_panel_settings, size: 16, color: AppTheme.saffron),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo: Aaditya Thackeray (State System Administrator)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: _label('Admin User ID *'),
            ),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.security, size: 20),
                hintText: 'Enter Admin ID',
              ),
            ),

            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerLeft,
              child: _label('Password *'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, size: 20),
                hintText: 'Enter master password',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: widget.onLoginSuccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A), // Dark executive navy
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Login to Admin Console',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Multi-factor encrypted session governed by Maharashtra State IT Policy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
      ),
    );
  }
}
