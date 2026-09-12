import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class LiveSyncDashboard extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onViewAuditLog;

  const LiveSyncDashboard({
    super.key,
    required this.onBack,
    required this.onViewAuditLog,
  });

  @override
  Widget build(BuildContext context) {
    final repo = DemoRepository();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: onBack,
        ),
        title: const Text('Live Synchronization'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Interoperability heartbeat verified: All 4 departments online.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Status Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.statusSuccessLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.statusSuccess.withAlpha(80)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppTheme.statusSuccess,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'All Systems Connected • Real-time Data Bridge Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.statusSuccess,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Live 100%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Central Interoperability Hub Visual Showcase
            _buildCentralHubDiagram(),

            const SizedBox(height: 16),

            // Live Metrics Counter
            _buildSyncMetricsBar(repo),

            const SizedBox(height: 20),

            // Recently Synchronized Fields Table
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recently Synchronized Fields',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                InkWell(
                  onTap: onViewAuditLog,
                  child: const Text(
                    'Full Audit Log ➜',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            AnimatedBuilder(
              animation: repo,
              builder: (context, _) {
                return Column(
                  children: repo.syncLogs.take(4).map((log) {
                    return _buildSyncRecordCard(log);
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 16),

            // View Audit Log Button
            ElevatedButton.icon(
              onPressed: onViewAuditLog,
              icon: const Icon(Icons.manage_search, size: 18),
              label: const Text('View Complete Sync Audit Log'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralHubDiagram() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header inside dark diagram
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MAHARASHTRA DATA EXCHANGE',
                style: TextStyle(
                  color: AppTheme.saffron,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              Icon(Icons.hub, color: Colors.white70, size: 18),
            ],
          ),

          const SizedBox(height: 14),

          // Central Hub Node & Connected Satellite Nodes
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Connecting Circle Lines
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withAlpha(30), width: 1.5),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryBlueLight.withAlpha(60), width: 1.2),
                  ),
                ),

                // Central Node: Interoperability Hub
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlueLight.withAlpha(120),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield, color: Colors.white, size: 24),
                        SizedBox(height: 2),
                        Text(
                          'INTEROP\nHUB',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Top Satellite: Krisha Patel (Citizen)
                Positioned(
                  top: 0,
                  child: _satellitePill('Citizen Profile (Krisha)', Icons.person, AppTheme.saffron),
                ),

                // Right Satellite: Banking
                Positioned(
                  right: 0,
                  child: _satellitePill('Banking', Icons.account_balance, const Color(0xFF42A5F5)),
                ),

                // Bottom Satellite: Municipal
                Positioned(
                  bottom: 0,
                  child: _satellitePill('Municipal Corporation', Icons.location_city, const Color(0xFF26A69A)),
                ),

                // Left Satellite: Land Records
                Positioned(
                  left: 0,
                  child: _satellitePill('Land Records', Icons.landscape, const Color(0xFF8D6E63)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sync, color: AppTheme.indiaGreen, size: 14),
              SizedBox(width: 6),
              Text(
                'Zero-Copy Tokenized Access • Audit Trail Logged',
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _satellitePill(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(180), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(60),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncMetricsBar(DemoRepository repo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _metricItem('24', 'Fields Synced', Icons.sync, AppTheme.primaryBlue),
          Container(width: 1, height: 32, color: AppTheme.dividerLight),
          _metricItem('4', 'Live Nodes', Icons.hub_outlined, AppTheme.tealAccent),
          Container(width: 1, height: 32, color: AppTheme.dividerLight),
          _metricItem('8 min ago', 'Last Sync', Icons.access_time, AppTheme.saffron),
        ],
      ),
    );
  }

  Widget _metricItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSyncRecordCard(dynamic log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlueLight.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sync_alt, size: 14, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    log.fieldChanged.isNotEmpty ? log.fieldChanged : 'Field Updated',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              StatusBadgeWidget(status: log.status, compact: true),
            ],
          ),

          const SizedBox(height: 8),

          // Source -> Target Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    log.sourceDepartment.isNotEmpty ? log.sourceDepartment : 'Source',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlueDark),
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 14, color: AppTheme.primaryBlue),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    log.targetDepartment.isNotEmpty ? log.targetDepartment : 'Target',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryBlueDark),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Old -> New Value Diff
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Previous Value', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    Text(
                      log.oldValue.isNotEmpty ? log.oldValue : 'N/A',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Synchronized Value', style: TextStyle(fontSize: 10, color: AppTheme.statusSuccess)),
                    Text(
                      log.newValue.isNotEmpty ? log.newValue : 'Current',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
