import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class SystemAdminProfileAndSettings extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onBack;

  const SystemAdminProfileAndSettings({
    super.key,
    required this.onLogout,
    required this.onBack,
  });

  @override
  State<SystemAdminProfileAndSettings> createState() => _SystemAdminProfileAndSettingsState();
}

class _SystemAdminProfileAndSettingsState extends State<SystemAdminProfileAndSettings> {
  final DemoRepository _repo = DemoRepository();
  String _selectedLanguage = 'English';

  void _showLanguageDialog() {
    String tempLang = _selectedLanguage;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDlgState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Row(
                children: [
                  Icon(Icons.language, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Text('Select Language', style: TextStyle(fontSize: 16)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('English (Default)'),
                    value: 'English',
                    groupValue: tempLang,
                    onChanged: (v) => setDlgState(() => tempLang = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('मराठी (महाराष्ट्र राज्य राजभाषा)'),
                    value: 'मराठी',
                    groupValue: tempLang,
                    onChanged: (v) => setDlgState(() => tempLang = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('हिन्दी (राष्ट्रीय भाषा)'),
                    value: 'हिन्दी',
                    groupValue: tempLang,
                    onChanged: (v) => setDlgState(() => tempLang = v!),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _selectedLanguage = tempLang);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Interface language changed to $tempLang.')),
                    );
                  },
                  child: const Text('Save Language'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.logout, color: AppTheme.statusRejected),
              SizedBox(width: 8),
              Text('Logout Confirmation', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout from the system administrator session?',
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onLogout();
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.statusRejected),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = _repo.systemAdmin;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('Settings & Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Admin Profile Summary Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Color(0xFF0F172A),
                    child: Icon(Icons.admin_panel_settings, size: 36, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    admin.fullName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'User ID: ${admin.userId} • Role: ${admin.role}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                  Text(
                    admin.email,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 8),
                  const StatusBadgeWidget(status: 'Active', compact: true),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Settings Options List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock_reset, color: AppTheme.primaryBlue),
                    title: const Text('Change Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Optional / Future Enhancement', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password modification is handled via Maharashtra Single Sign-On (SSO).')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language, color: AppTheme.tealAccent),
                    title: const Text('Language Settings', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: Text('Current: $_selectedLanguage', style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
                    onTap: _showLanguageDialog,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security, color: AppTheme.saffron),
                    title: const Text('Security & Access Logs', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Multi-factor auth active', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppTheme.statusRejected),
                    title: const Text('Logout', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.statusRejected)),
                    subtitle: const Text('Terminate current session', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.statusRejected),
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
