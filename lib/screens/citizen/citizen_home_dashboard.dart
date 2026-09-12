import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class CitizenHomeDashboard extends StatelessWidget {
  final Function(String route, {dynamic arguments}) onNavigate;

  const CitizenHomeDashboard({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final repo = DemoRepository();
    final user = repo.citizenUser;
    final unreadCount = repo.notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Custom Header App Bar
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppTheme.borderLight)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: () => onNavigate('profile'),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primaryBlueLight.withAlpha(40),
                              child: const Text(
                                'KP',
                                style: TextStyle(
                                  color: AppTheme.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppTheme.indiaGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Greetings & Citizen ID
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Good Morning, ${user.fullName.split(' ')[0]}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 14, color: AppTheme.primaryBlue),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Citizen ID: ${user.citizenId}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                                const Text(
                                  '• Pune, MH',
                                  style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Notification Icon with Badge
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: AppTheme.primaryBlue, size: 24),
                            onPressed: () => onNavigate('notifications'),
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.statusRejected,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$unreadCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Core Concept Banner: ONE LOGIN -> MULTIPLE SERVICES
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.hub_outlined, size: 15, color: AppTheme.saffron),
                          SizedBox(width: 6),
                          Text(
                            'ONE LOGIN  ➜  MULTIPLE GOVERNMENT SERVICES',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Completion Card (80%)
                  _buildProfileCompletionCard(context),

                  const SizedBox(height: 16),

                  // Statistics Grid
                  _buildStatisticsGrid(repo),

                  const SizedBox(height: 18),

                  // Quick Action Buttons
                  _buildQuickActions(context),

                  const SizedBox(height: 20),

                  // Quick Service Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Popular Services',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onNavigate('services'),
                        child: const Text('View All', style: TextStyle(fontSize: 13, color: AppTheme.primaryBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildQuickServicesGrid(),

                  const SizedBox(height: 20),

                  // Recent Applications Card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Recent Applications',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () => onNavigate('applications'),
                        child: const Text('Track All', style: TextStyle(fontSize: 13, color: AppTheme.primaryBlue)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildRecentApplications(repo),

                  const SizedBox(height: 20),

                  // Connected Departments Section
                  const Text(
                    'Connected Departments',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Data shared securely based on your active consent preferences.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  _buildConnectedDepartments(context),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCompletionCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.assignment_ind_outlined, size: 20, color: AppTheme.primaryBlue),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Profile Completion',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.statusSuccessLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '80% Complete',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.statusSuccess),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.80,
              minHeight: 7,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Add Bank KYC for 100% verification',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => onNavigate('profile'),
                child: const Text(
                  'View Profile ➜',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(DemoRepository repo) {
    return Row(
      children: [
        _statCard('1', 'Active', Icons.pending_actions, AppTheme.statusPending, () => onNavigate('tracker')),
        const SizedBox(width: 8),
        _statCard('1', 'Approved', Icons.check_circle_outline, AppTheme.statusSuccess, () => onNavigate('applications')),
        const SizedBox(width: 8),
        _statCard('1', 'Pending', Icons.notifications_active_outlined, AppTheme.saffron, () => onNavigate('consent')),
        const SizedBox(width: 8),
        _statCard('6', 'Services', Icons.apps, AppTheme.primaryBlue, () => onNavigate('services')),
      ],
    );
  }

  Widget _statCard(String count, String title, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderLight),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                count,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary, height: 1.1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        _actionPill(Icons.add_task, 'Apply Service', AppTheme.primaryBlue, () => onNavigate('services')),
        const SizedBox(width: 8),
        _actionPill(Icons.history, 'Applications', AppTheme.textPrimary, () => onNavigate('applications')),
        const SizedBox(width: 8),
        _actionPill(Icons.timeline, 'Track Status', const Color(0xFF0288D1), () => onNavigate('tracker')),
        const SizedBox(width: 8),
        _actionPill(Icons.verified_user_outlined, 'Consent Hub', AppTheme.tealAccent, () => onNavigate('consent')),
      ],
    );
  }

  Widget _actionPill(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withAlpha(15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withAlpha(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickServicesGrid() {
    final services = [
      {'name': 'Income Certificate', 'icon': Icons.receipt_long, 'dept': 'Revenue', 'color': Color(0xFF8E24AA)},
      {'name': 'Scholarship', 'icon': Icons.school, 'dept': 'Education', 'color': Color(0xFF0288D1)},
      {'name': 'Ration Card', 'icon': Icons.local_dining, 'dept': 'Food Supply', 'color': Color(0xFFE65100)},
      {'name': 'Birth Certificate', 'icon': Icons.child_care, 'dept': 'Municipal', 'color': Color(0xFF00897B)},
      {'name': 'Land Records (7/12)', 'icon': Icons.landscape, 'dept': 'Land Records', 'color': Color(0xFF6D4C41)},
      {'name': 'More Services', 'icon': Icons.more_horiz, 'dept': 'Catalog', 'color': AppTheme.primaryBlue},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.05,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final item = services[index];
        final color = item['color'] as Color;
        return InkWell(
          onTap: () {
            if (index == 0) {
              onNavigate('service_detail', arguments: 'SRV_INCOME_CERT');
            } else {
              onNavigate('services');
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withAlpha(25),
                  child: Icon(item['icon'] as IconData, size: 18, color: color),
                ),
                const SizedBox(height: 6),
                Text(
                  item['name'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentApplications(DemoRepository repo) {
    final recent = repo.applications.take(2).toList();
    return Column(
      children: recent.map((app) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: CircleAvatar(
              backgroundColor: DepartmentHelper.getColor(app.departmentId).withAlpha(25),
              child: Icon(
                DepartmentHelper.getIcon(app.departmentId),
                color: DepartmentHelper.getColor(app.departmentId),
                size: 20,
              ),
            ),
            title: Text(
              app.applicationData['serviceName'] ?? 'Government Service',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${app.applicationId} • ${app.departmentId}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                StatusBadgeWidget(status: app.status, compact: true),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
            onTap: () => onNavigate('tracker', arguments: app.applicationId),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConnectedDepartments(BuildContext context) {
    final depts = [
      {'name': 'Municipal Corporation', 'status': 'Sync Active', 'fields': 'Address, Property', 'color': Color(0xFF0288D1)},
      {'name': 'Banking Department', 'status': 'Sync Active', 'fields': 'KYC, Direct Benefit Transfer', 'color': Color(0xFF1565C0)},
      {'name': 'Land Records', 'status': 'Consent Pending', 'fields': '7/12 Extract, Mutation', 'color': Color(0xFF6D4C41)},
      {'name': 'Agriculture Department', 'status': 'Sync Active', 'fields': 'Land Area, Crop Pattern', 'color': Color(0xFF2E7D32)},
    ];

    return Column(
      children: [
        ...depts.map((d) {
          final color = d['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withAlpha(20),
                  child: Icon(DepartmentHelper.getIcon(d['name'] as String), color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d['name'] as String,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      Text(
                        'Fields: ${d['fields']}',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (d['status'] as String).contains('Active')
                        ? AppTheme.statusSuccessLight
                        : AppTheme.statusPendingLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    d['status'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: (d['status'] as String).contains('Active')
                          ? AppTheme.statusSuccess
                          : AppTheme.statusPending,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          onPressed: () => onNavigate('live_sync'),
          icon: const Icon(Icons.sync_alt, size: 16),
          label: const Text('Open Live Synchronization Dashboard', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
