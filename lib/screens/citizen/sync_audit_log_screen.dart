import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';
import '../../models/audit_log_model.dart';

class SyncAuditLogScreen extends StatefulWidget {
  final VoidCallback onBack;

  const SyncAuditLogScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<SyncAuditLogScreen> createState() => _SyncAuditLogScreenState();
}

class _SyncAuditLogScreenState extends State<SyncAuditLogScreen> {
  final DemoRepository _repo = DemoRepository();
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Profile', 'Address', 'Land', 'Success'];

  void _showDetailDialog(AuditLogModel log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              const Icon(Icons.verified, color: AppTheme.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(log.fieldChanged.isNotEmpty ? log.fieldChanged : 'Sync Audit Record', style: const TextStyle(fontSize: 15)),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Log ID', log.logId),
              _detailRow('Status', log.status),
              _detailRow('Source', log.sourceDepartment),
              _detailRow('Target', log.targetDepartment),
              _detailRow('Field', log.fieldChanged),
              _detailRow('Old Value', log.oldValue.isNotEmpty ? log.oldValue : 'N/A'),
              _detailRow('New Value', log.newValue.isNotEmpty ? log.newValue : 'N/A'),
              _detailRow('Performed By', log.performedBy),
              _detailRow('Timestamp', '09 Sep 2026, 11:24 AM'),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.statusSuccessLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Hash verified on Maharashtra State Interoperability Distributed Ledger.',
                  style: TextStyle(fontSize: 10, color: AppTheme.statusSuccess, fontWeight: FontWeight.w600),
                ),
              ),
            ],
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text('$label:', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _repo.syncLogs.where((log) {
      if (_selectedCategory == 'All') return true;
      if (_selectedCategory == 'Profile') return log.category == 'Profile';
      if (_selectedCategory == 'Address') return log.category == 'Address';
      if (_selectedCategory == 'Land') return log.category == 'Land';
      if (_selectedCategory == 'Success') return log.status == 'Success';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('Sync Audit Log'),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: _categories.map((c) {
                final isSelected = _selectedCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = c);
                    },
                    selectedColor: AppTheme.primaryBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1, color: AppTheme.borderLight),

          // Audit Records List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final log = filtered[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _showDetailDialog(log),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.history_toggle_off, size: 16, color: AppTheme.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  log.fieldChanged.isNotEmpty ? log.fieldChanged : 'Field Updated',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            StatusBadgeWidget(status: log.status, compact: true),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${log.sourceDepartment} ➜ ${log.targetDepartment}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlueDark),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Old: ${log.oldValue.isNotEmpty ? log.oldValue : 'Initial'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'New: ${log.newValue.isNotEmpty ? log.newValue : 'Current'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.statusSuccess),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Today, 10:25 AM', style: TextStyle(fontSize: 9, color: AppTheme.textMuted)),
                            Text('Tap for Audit Details ➜', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
