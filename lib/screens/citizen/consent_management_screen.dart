import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';
import '../../models/consent_model.dart';

class ConsentManagementScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onViewAuditLog;

  const ConsentManagementScreen({
    super.key,
    required this.onBack,
    required this.onViewAuditLog,
  });

  @override
  State<ConsentManagementScreen> createState() => _ConsentManagementScreenState();
}

class _ConsentManagementScreenState extends State<ConsentManagementScreen> {
  final DemoRepository _repo = DemoRepository();

  void _showConsentHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.history_edu, color: AppTheme.primaryBlue),
              SizedBox(width: 8),
              Text('Consent Audit History', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _repo.consents.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final c = _repo.consents[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: DepartmentHelper.getColor(c.departmentId).withAlpha(20),
                    child: Icon(DepartmentHelper.getIcon(c.departmentId), size: 16, color: DepartmentHelper.getColor(c.departmentId)),
                  ),
                  title: Text(c.departmentId, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  subtitle: Text('Status: ${c.status} • Updated: Today', style: const TextStyle(fontSize: 10)),
                  trailing: StatusBadgeWidget(status: c.status, compact: true),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('Consent Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 22),
            tooltip: 'Consent History',
            onPressed: _showConsentHistoryDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_person_outlined, color: AppTheme.saffron, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Citizen Data Sovereignty',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'You control which departments can access your information. You can grant, deny, or revoke access at any time.',
                    style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.35),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section Header & History Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Department Access Cards',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                InkWell(
                  onTap: _showConsentHistoryDialog,
                  child: const Text(
                    'Consent History ➜',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Department Consent Cards
            AnimatedBuilder(
              animation: _repo,
              builder: (context, _) {
                return Column(
                  children: _repo.consents.map((consent) {
                    return _buildConsentCard(consent);
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 12),

            // View Complete Interoperability Audit Log Button
            Center(
              child: OutlinedButton.icon(
                onPressed: widget.onViewAuditLog,
                icon: const Icon(Icons.table_chart_outlined, size: 18),
                label: const Text('View Live Interoperability Audit Log'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentCard(ConsentModel consent) {
    final deptColor = DepartmentHelper.getColor(consent.departmentId);
    final isGranted = consent.status == ConsentModel.statusGranted;
    final isPending = consent.status == ConsentModel.statusPending;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPending ? AppTheme.saffron.withAlpha(120) : AppTheme.borderLight,
          width: isPending ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Department Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: deptColor.withAlpha(20),
                child: Icon(DepartmentHelper.getIcon(consent.departmentId), color: deptColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consent.departmentId,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    Text(
                      consent.serviceId,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              StatusBadgeWidget(status: consent.status, compact: true),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.dividerLight),
          const SizedBox(height: 10),

          // Requested Data Fields
          const Text(
            'Data Fields Requested:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: consent.dataFields.map((field) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  field,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          // Purpose
          if (consent.purpose.isNotEmpty) ...[
            Text(
              'Purpose: ${consent.purpose}',
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
          ],

          // Dates row
          Row(
            children: [
              const Icon(Icons.event_available, size: 13, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              const Text('Granted: 10 Jan 2025', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              const SizedBox(width: 14),
              const Icon(Icons.event_busy, size: 13, color: AppTheme.textMuted),
              const SizedBox(width: 4),
              const Text('Expires: 31 Dec 2026', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
            ],
          ),

          const SizedBox(height: 12),

          // Action Buttons: Allow / Deny / Revoke
          Row(
            children: [
              if (isPending) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _repo.updateConsentStatus(consent.consentId, ConsentModel.statusGranted);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Access Granted to ${consent.departmentId}')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.statusSuccess,
                      minimumSize: const Size.fromHeight(36),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Allow Access', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _repo.updateConsentStatus(consent.consentId, ConsentModel.statusDenied);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Access Denied for ${consent.departmentId}')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.statusRejected,
                      side: const BorderSide(color: AppTheme.statusRejected),
                      minimumSize: const Size.fromHeight(36),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Deny', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ] else if (isGranted) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _repo.updateConsentStatus(consent.consentId, ConsentModel.statusRevoked);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Consent Revoked for ${consent.departmentId}')),
                      );
                    },
                    icon: const Icon(Icons.block, size: 14, color: AppTheme.statusRejected),
                    label: const Text('Revoke Consent', style: TextStyle(fontSize: 12, color: AppTheme.statusRejected)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.statusRejectedLight),
                      backgroundColor: AppTheme.statusRejectedLight.withAlpha(60),
                      minimumSize: const Size.fromHeight(36),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _repo.updateConsentStatus(consent.consentId, ConsentModel.statusGranted);
                    },
                    child: const Text('Re-Allow Access', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
