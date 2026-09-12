import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';

class DeptAdminLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onBack;

  const DeptAdminLoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onBack,
  });

  @override
  State<DeptAdminLoginScreen> createState() => _DeptAdminLoginScreenState();
}

class _DeptAdminLoginScreenState extends State<DeptAdminLoginScreen> {
  String _selectedDept = 'Revenue Department';
  final TextEditingController _emailController =
      TextEditingController(text: 'sanjay.deshmukh@revenue.maha.gov.in');
  final TextEditingController _passwordController =
      TextEditingController(text: 'MahaOfficer@2026');
  final TextEditingController _otpController =
      TextEditingController(text: '482910');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
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
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          children: [
            const MaharashtraEmblemWidget(size: 60, showText: true),
            const SizedBox(height: 12),
            const Text(
              'Department Administrator Portal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryBlueDark,
              ),
            ),
            const Text(
              'Authorized Department Officers Only',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),

            const SizedBox(height: 20),

            // Demo Auto-fill Banner
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlueLight.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryBlue.withAlpha(50)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.badge_outlined, size: 16, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo: Sanjay Deshmukh (Revenue Officer, Tahsildar Pune)',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlueDark),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Department Selector
            Align(
              alignment: Alignment.centerLeft,
              child: _label('Select Department *'),
            ),
            DropdownButtonFormField<String>(
              initialValue: _selectedDept,
              decoration: const InputDecoration(prefixIcon: Icon(Icons.domain, size: 20)),
              items: const [
                DropdownMenuItem(value: 'Revenue Department', child: Text('Revenue Department')),
                DropdownMenuItem(value: 'Municipal Corporation', child: Text('Municipal Corporation')),
                DropdownMenuItem(value: 'Land Records', child: Text('Land Records (Mahabhumi)')),
                DropdownMenuItem(value: 'Agriculture Department', child: Text('Agriculture Department')),
              ],
              onChanged: (val) => setState(() => _selectedDept = val ?? _selectedDept),
            ),

            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerLeft,
              child: _label('Official Email ID *'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline, size: 20),
                hintText: 'officer@dept.maha.gov.in',
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
                hintText: 'Enter secure password',
              ),
            ),

            const SizedBox(height: 14),

            Align(
              alignment: Alignment.centerLeft,
              child: _label('2FA Officer OTP *'),
            ),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.security, size: 20),
                hintText: '6-digit Aadhaar/Kavach OTP',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: widget.onLoginSuccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Access Department Portal',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'All administrative logins are monitored and audited under NIC security guidelines.',
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
