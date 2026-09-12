import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onBack;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onBack,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscurePassword = true;
  String _selectedLanguage = 'English';
  final TextEditingController _identifierController =
      TextEditingController(text: 'krisha.patel@maharashtra.gov.in');
  final TextEditingController _passwordController =
      TextEditingController(text: '••••••••••••');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _identifierController.dispose();
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
        actions: [
          // Language selector
          PopupMenuButton<String>(
            initialValue: _selectedLanguage,
            onSelected: (val) => setState(() => _selectedLanguage = val),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'English', child: Text('English')),
              const PopupMenuItem(value: 'मराठी', child: Text('मराठी')),
              const PopupMenuItem(value: 'हिन्दी', child: Text('हिन्दी')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 18, color: AppTheme.primaryBlue),
                  const SizedBox(width: 4),
                  Text(
                    _selectedLanguage,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.accessibility_new, size: 20, color: AppTheme.primaryBlue),
            tooltip: 'Accessibility options',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emblem & Title
            Center(
              child: Column(
                children: [
                  const MaharashtraEmblemWidget(size: 56, showText: false),
                  const SizedBox(height: 8),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryBlueDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sign in to access your government services',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab bar: Citizen Login / Sign Up
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Citizen Login'),
                  Tab(text: 'Sign Up'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Demo Quick-Fill Pill
            InkWell(
              onTap: () {
                setState(() {
                  _identifierController.text = 'krisha.patel@maharashtra.gov.in';
                  _passwordController.text = 'MahaGov@2026';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Loaded credentials for Krisha Patel (MH123456789)'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.saffronLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.saffron.withAlpha(80)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.bolt, size: 16, color: AppTheme.saffron),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Demo: Krisha Patel (Citizen ID: MH123456789)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                      ),
                    ),
                    Text(
                      'Auto-Fill',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Mobile / Email Input
            const Text(
              'Mobile Number / Email ID *',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _identifierController,
              decoration: const InputDecoration(
                hintText: 'Enter registered mobile or email',
                prefixIcon: Icon(Icons.person_outline, size: 20),
              ),
            ),

            const SizedBox(height: 14),

            // Password Input
            const Text(
              'Password *',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Enter account password',
                prefixIcon: const Icon(Icons.lock_outline, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Large Blue Login Button
            ElevatedButton(
              onPressed: widget.onLoginSuccess,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Login to Unified Portal',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            // OR Divider
            const Row(
              children: [
                Expanded(child: Divider(color: AppTheme.borderLight)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ),
                Expanded(child: Divider(color: AppTheme.borderLight)),
              ],
            ),

            const SizedBox(height: 16),

            // Aadhaar / MeriPehchaan DigiLocker Login
            OutlinedButton.icon(
              onPressed: widget.onLoginSuccess,
              icon: const Icon(Icons.fingerprint, color: AppTheme.primaryBlueDark),
              label: const Text(
                'Sign In with Aadhaar / DigiLocker',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
            ),

            const SizedBox(height: 16),

            // Register Link
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Don't have a Citizen ID? ", style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Register Now',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Secure Login Indicator
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.statusSuccessLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user, size: 14, color: AppTheme.statusSuccess),
                    SizedBox(width: 6),
                    Text(
                      '256-bit SSL Encrypted • State Data Protection Act',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.statusSuccess),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
