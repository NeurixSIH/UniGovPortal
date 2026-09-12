import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class ApplicationHistoryScreen extends StatefulWidget {
  final Function(String appId) onSelectApplication;
  final VoidCallback onBack;

  const ApplicationHistoryScreen({
    super.key,
    required this.onSelectApplication,
    required this.onBack,
  });

  @override
  State<ApplicationHistoryScreen> createState() => _ApplicationHistoryScreenState();
}

class _ApplicationHistoryScreenState extends State<ApplicationHistoryScreen> {
  final DemoRepository _repo = DemoRepository();
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final applications = _repo.applications;
    final pendingCount = applications.where((a) => a.status == 'pending' || a.status == 'under_review').length;
    final approvedCount = applications.where((a) => a.status == 'approved' || a.status == 'completed').length;
    final rejectedCount = applications.where((a) => a.status == 'rejected').length;

    final filtered = applications.where((a) {
      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Pending') return a.status == 'pending' || a.status == 'under_review';
      if (_selectedFilter == 'Approved') return a.status == 'approved' || a.status == 'completed';
      if (_selectedFilter == 'Rejected') return a.status == 'rejected';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: widget.onBack,
        ),
        title: const Text('Application History'),
      ),
      body: Column(
        children: [
          // Summary Counter Row
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                _counterCard('Total', '${applications.length}', AppTheme.primaryBlue),
                const SizedBox(width: 8),
                _counterCard('Pending', '$pendingCount', AppTheme.statusPending),
                const SizedBox(width: 8),
                _counterCard('Approved', '$approvedCount', AppTheme.statusSuccess),
                const SizedBox(width: 8),
                _counterCard('Rejected', '$rejectedCount', AppTheme.statusRejected),
              ],
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: ['All', 'Pending', 'Approved', 'Rejected'].map((f) {
                final isSelected = _selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => _selectedFilter = f);
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

          // Application History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final app = filtered[index];
                final deptColor = DepartmentHelper.getColor(app.departmentId);

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
                    onTap: () => widget.onSelectApplication(app.applicationId),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              app.applicationId,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                            ),
                            StatusBadgeWidget(status: app.status, compact: true),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          app.applicationData['serviceName'] ?? 'Service Application',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Department: ${app.departmentId}',
                          style: TextStyle(fontSize: 11, color: deptColor, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Submitted: Sep 2026',
                              style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                            ),
                            const Row(
                              children: [
                                Text('Track Progress', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, size: 10, color: AppTheme.primaryBlue),
                              ],
                            ),
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

  Widget _counterCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(50)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
