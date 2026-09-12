import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class DeptAdminDashboard extends StatelessWidget {
  final Function(String route, {dynamic arguments}) onNavigate;

  const DeptAdminDashboard({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final repo = DemoRepository();
    final officer = repo.deptOfficer;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Department Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.borderLight)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryBlue,
                        child: const Icon(Icons.receipt_long, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              officer.departmentId,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Officer: ${officer.fullName} (ID: ${officer.userId})',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.statusSuccessLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Online', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.statusSuccess)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Workload Summary Chip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Active Zone: Pune Tahsildar Division',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'SLA: 98.4%',
                          style: TextStyle(color: AppTheme.saffron, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body Metrics & Action Queue
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Cards: Incoming, Under Review, Docs Required, Approved, Rejected
                  const Text(
                    'Application Workload',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _stat('12', 'Incoming', AppTheme.primaryBlue, Icons.inbox),
                      const SizedBox(width: 8),
                      _stat('4', 'Under Review', AppTheme.statusPending, Icons.pending_actions),
                      const SizedBox(width: 8),
                      _stat('2', 'Docs Req.', const Color(0xFF8E24AA), Icons.file_copy_outlined),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _stat('18', 'Approved', AppTheme.statusSuccess, Icons.check_circle_outline),
                      const SizedBox(width: 8),
                      _stat('1', 'Rejected', AppTheme.statusRejected, Icons.cancel_outlined),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Priority Review Application Queue
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Pending Review Queue',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.statusPendingLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Priority: High', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.statusPending)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Spotlight Application: APP20260904 (Krisha Patel)
                  AnimatedBuilder(
                    animation: repo,
                    builder: (context, _) {
                      final app = repo.applications.firstWhere(
                        (a) => a.applicationId == 'APP20260904',
                        orElse: () => repo.applications.first,
                      );

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.primaryBlue.withAlpha(80), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withAlpha(15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        app.applicationId,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Text('Income Certificate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                StatusBadgeWidget(status: app.status),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(height: 1, color: AppTheme.dividerLight),
                            const SizedBox(height: 10),
                            _row('Applicant', 'Krisha Patel (Citizen ID: MH123456789)'),
                            _row('Annual Income', '₹2,50,000 (Declared)'),
                            _row('Auto-Eligibility', '✓ Eligible (Matched against 4 Rules)'),
                            _row('Submitted Docs', 'Aadhaar (Verified), MSEB Bill (Verified)'),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              onPressed: () => onNavigate('dept_review', arguments: app.applicationId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                minimumSize: const Size.fromHeight(42),
                              ),
                              icon: const Icon(Icons.assignment_turned_in, size: 16),
                              label: const Text('Open Review & Endorsement Screen', style: TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Recent Department Activity
                  const Text(
                    'Recent Department Activity',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  _activityTile('Approved Ration Card (APP20260815) for Krisha Patel', '2 hrs ago', AppTheme.statusSuccess),
                  _activityTile('Cross-verified 7/12 mutation with Land Records Hub', '4 hrs ago', AppTheme.primaryBlue),
                  _activityTile('Synced address update with Municipal Corporation', 'Yesterday', AppTheme.tealAccent),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String count, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(String text, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary)),
          ),
          Text(time, style: const TextStyle(fontSize: 9, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
