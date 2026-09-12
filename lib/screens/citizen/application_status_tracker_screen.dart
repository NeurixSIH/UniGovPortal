import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_icons_emblem.dart';
import '../../data/demo_repository.dart';

class ApplicationStatusTrackerScreen extends StatelessWidget {
  final String applicationId;
  final VoidCallback onBack;

  const ApplicationStatusTrackerScreen({
    super.key,
    this.applicationId = 'APP20260904',
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final repo = DemoRepository();
    final app = repo.applications.firstWhere(
      (a) => a.applicationId == applicationId,
      orElse: () => repo.applications.first,
    );

    // 5 standard stages
    final stages = [
      {'title': 'Submitted', 'desc': 'Application received at Revenue Portal', 'time': '09 Sep 2026, 10:30 AM', 'done': true},
      {'title': 'Under Review', 'desc': 'Talathi officer validating land & bank records', 'time': '10 Sep 2026, 03:15 PM', 'done': true},
      {'title': 'Documents Required', 'desc': 'Check if supplementary proofs needed', 'time': 'Pending review', 'done': false},
      {'title': 'Approved', 'desc': 'Tahsildar digital signature endorsement', 'time': 'Estimated 16 Sep 2026', 'done': false},
      {'title': 'Completed', 'desc': 'Digitally signed certificate issued to Locker', 'time': 'Pending approval', 'done': false},
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: onBack,
        ),
        title: const Text('Application Tracker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Application Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.applicationId,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                      ),
                      StatusBadgeWidget(status: app.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    app.applicationData['serviceName'] ?? 'Income Certificate',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Department: ${app.departmentId}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const Divider(height: 20, color: AppTheme.dividerLight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _smallMeta('Submitted On', '09 Sep 2026'),
                      _smallMeta('Processed By', app.processedBy.isNotEmpty ? app.processedBy : 'Talathi Office'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Vertical Timeline Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.alt_route, size: 18, color: AppTheme.primaryBlue),
                      SizedBox(width: 8),
                      Text(
                        'Processing Timeline',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ...List.generate(stages.length, (i) {
                    final isLast = i == stages.length - 1;
                    final item = stages[i];
                    final isDone = item['done'] as bool;
                    final isCurrent = isDone && (i == 1);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline node & connecting line
                        Column(
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDone
                                    ? (isCurrent ? AppTheme.statusPending : AppTheme.statusSuccess)
                                    : const Color(0xFFE2E8F0),
                                border: Border.all(
                                  color: isDone ? Colors.white : const Color(0xFFCBD5E1),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: isDone
                                    ? Icon(
                                        isCurrent ? Icons.refresh : Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    : Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 42,
                                color: isDone ? AppTheme.statusSuccess : const Color(0xFFE2E8F0),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // Timeline details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isDone ? AppTheme.textPrimary : AppTheme.textMuted,
                                      ),
                                    ),
                                    Text(
                                      item['time'] as String,
                                      style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['desc'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDone ? AppTheme.textSecondary : AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.description_outlined, size: 16),
                    label: const Text('View Application', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.attach_file, size: 16),
                    label: const Text('View Documents', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading official PDF acknowledgement receipt...')),
                );
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download Acknowledgement Receipt'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _smallMeta(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
    );
  }
}
